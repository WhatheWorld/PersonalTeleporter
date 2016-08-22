require "util"

--[[Global variables hierarchy in this mod:
  global
    PersonalTeleporter = {}; dictionary
      beacons = {}; list
        entity = entity; contains such fields as built_by, position, surface, force - needed to teleport and to operate with players gui
        key = entity.surface.name .. "-" .. entity.position.x .. "-" .. entity.position.y; it's an id for gui elements representing this beacon
        name = "x:" .. entity.position.x .. ",y:" .. entity.position.y .. ",s:" .. entity.surface.name; it's default name to show in gui element
      player_settings = {}; dictionary, e.g. global.PersonalTeleporter.player_settings[player_name].used_portal_on_tick
        used_portal_on_tick; number
        beacons_list_is_sorted_by; number: 1 is global list as is (default), 2 is sorting by distance from start, 3 is sorting by distance from player
        beacons_list_current_page_num; number, default is 1
  PersonalTeleporter = {}; dictionary
    config = {}; dictionary
      contents of PersonalTeleporter.config see in config.lua
]]

if PersonalTeleporter == nil then
  PersonalTeleporter = {}
end
if PersonalTeleporter.config == nil then
  PersonalTeleporter.config = {}
end
require "config"

--===================================================================--
--########################## EVENT HANDLERS #########################--
--===================================================================--

script.on_configuration_changed(function(data)
  if data.mod_changes ~= nil and data.mod_changes["PersonalTeleporter"] ~= nil and data.mod_changes["PersonalTeleporter"].old_version == "0.1.6" then
    Migrate016to020()
  end
end)

script.on_init(function(event)
  for i, force in pairs(game.forces) do
    force.reset_technologies()
    force.reset_recipes()
  end
end)

--When beacon get placed by entity of any force, all players of this force should get their GUI updated.
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event) 
  local entity = event.created_entity
  local player_index = event.player_index
  local player = game.players[event.player_index]
  if event.created_entity.name == "Teleporter-Beacon" then
    RememberTeleporterBeacon(entity)
  elseif event.created_entity.name == "Portal" then
    local destination = event.created_entity.position
    event.created_entity.destroy()
    ActivatePortal(player, destination)
    player.insert({name = "Portal", count = 1})
  end
end)

--When beacon, belonging to some force, get removed, all players of this force should get their GUI updated.
script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, function(event)
  local entity = event.entity
  local player_index = event.player_index
  if event.entity.name == "Teleporter-Beacon" then
    ForgetTeleporterBeacon(entity)
  end
end)

--When new player get created in game: new game for single player or new player connected to multiplayer game, or player joined the game -
--we should update his GUI. So if his force owns beacons - he'll see them.
script.on_event({defines.events.on_player_created, defines.events.on_player_joined_game}, function(event)
  local player_index = event.player_index
  local player = game.players[player_index]
  UpdateGui(player.force)
end)

--When forces get merged, all beacons which belong to both forces should become common (should belong to the resulting force).
script.on_event(defines.events.on_forces_merging, function(event) 
  local force_to_destroy = event.source
  local force_to_reassign_to = event.destination
  UpdateGui(force_to_reassign_to)
end)

script.on_event(defines.events.on_put_item, function(event)
	local player = game.players[event.player_index]
  local destination = event.position
  ActivatePortal(player, destination)
end)

script.on_event("personal-teleporter-hotkey-main-window", function(event)
  local player_index = event.player_index
  SwitchMainWindow(game.players[player_index])
end)

--When player get clicked the button - something should happen =).
script.on_event(defines.events.on_gui_click, function(event) 
  local gui_element = event.element
  local player_index = event.element.player_index
  local player = game.players[player_index]
  if gui_element.name == "personal_teleporter_main_button" then                 -- Main mod's button
    SwitchMainWindow(game.players[player_index])
  elseif gui_element.name == "personal_teleporter_button_page_back" then      -- < -button, prev.page
    InitializePlayerGlobals(player)
    if global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num > 1 then
      global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num = global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num - 1
      UpdateMainWindow(player)
    end
  elseif gui_element.name == "personal_teleporter_button_page_forward" then      -- > -button, next page
    InitializePlayerGlobals(player)
    global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num = global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num + 1
    UpdateMainWindow(player)
  elseif gui_element.name == "personal_teleporter_button_sort_global" then      -- G -button, no sorting
    InitializePlayerGlobals(player)
    global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by = 1
    UpdateMainWindow(player)
  elseif gui_element.name == "personal_teleporter_button_sort_distance_from_start" then  -- S -button, no sorting
    InitializePlayerGlobals(player)
    global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by = 2
    UpdateMainWindow(player)
  elseif gui_element.name == "personal_teleporter_button_sort_distance_from_player" then -- P -button, no sorting
    InitializePlayerGlobals(player)
    global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by = 3
    UpdateMainWindow(player)
  elseif gui_element.name == "personal_teleporter_button_activate" then         -- T -button (teleport)
    ActivateBeacon(player, gui_element.parent.name)
  elseif gui_element.name == "personal_teleporter_button_order_up" then         -- < -button (move up)
    if ReorderBeaconUp(gui_element.parent.name, player.force.name) then
      UpdateMainWindow(player)
    end
  elseif gui_element.name == "personal_teleporter_button_order_down" then       -- > -button (move down)
    if ReorderBeaconDown(gui_element.parent.name, player.force.name) then
      UpdateMainWindow(player)
    end
  elseif gui_element.name == "personal_teleporter_button_rename" then
    OpenRenameWindow(player, gui_element.parent.name)
  elseif gui_element.name == "personal_teleporter_rename_window_button_cancel" then
    CloseRenameWindow(player)
  elseif gui_element.name == "personal_teleporter_rename_window_button_ok" then
    SaveNewBeaconsName(player, gui_element.parent.name)
    UpdateGui(player.force)
  end
end)

--===================================================================--
--############################ FUNCTIONS ############################--
--===================================================================--

--Ensures that globals were initialized.
function InitializeGeneralGlobals()
  if not global.PersonalTeleporter then
    global.PersonalTeleporter = {}
  end
  if not global.PersonalTeleporter.beacons then
    global.PersonalTeleporter.beacons = {}
  end
end

--Ensures that globals were initialized.
function InitializePlayerGlobals(player)
  InitializeGeneralGlobals()
  if not global.PersonalTeleporter.player_settings then
    global.PersonalTeleporter.player_settings = {}
  end
  if not global.PersonalTeleporter.player_settings[player.name] then
    global.PersonalTeleporter.player_settings[player.name] = {}
    global.PersonalTeleporter.player_settings[player.name].used_portal_on_tick = 1
    global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by = 1
    global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num = 1
  end
end

--Adds new beacon to global list and calls GUI update for all members of the force.
function RememberTeleporterBeacon(entity)
  InitializeGeneralGlobals()
  local beacon = {}
  beacon.key = CreateBeaconKey(entity)
  beacon.name = CreateBeaconName(entity)
  beacon.entity = entity
  table.insert(global.PersonalTeleporter.beacons, beacon)
  UpdateGui(beacon.entity.force)
end

--Removes specified beacon from global list and calls GUI update.
function ForgetTeleporterBeacon(entity)
  local key_to_forget = CreateBeaconKey(entity)
  for i = #global.PersonalTeleporter.beacons, 1, -1 do
    local beacon = global.PersonalTeleporter.beacons[i]
    if beacon.key == key_to_forget then
      table.remove(global.PersonalTeleporter.beacons, i)
      UpdateGui(entity.force)
      return
    end
  end
end

--Calculates key for beacon depending on it's position. It's beacon's UID.
function CreateBeaconKey(entity)
  return entity.surface.name .. "-" .. entity.position.x .. "-" .. entity.position.y
end

--Calculates key for beacon depending on it's position. It's beacon's UID.
function CreateBeaconName(entity)
  return "x:" .. entity.position.x .. ",y:" .. entity.position.y .. ",s:" .. entity.surface.name
end

--Looks for beacon with specified key and returns the beacon and it's index in global list
function GetBeaconByKey(beacon_key)
  if global.PersonalTeleporter ~= nil and global.PersonalTeleporter.beacons ~= nil then
    for i, beacon in pairs(global.PersonalTeleporter.beacons) do
      if beacon.key == beacon_key then
        return beacon, i
      end
    end
  end
  return nil
end

--Counts either all beacons or those which belong to the specified force.
function CountBeacons(force_name)
  local count = 0
  if force_name == nil then
    count = #global.PersonalTeleporter.beacons
  else
    for i, beacon in pairs(global.PersonalTeleporter.beacons) do
      if beacon.entity.force.name == force_name then
        count = count + 1
      end
    end
  end
  return count
end

--Swaps the beacon with the specified key with the previous in the global list. Affects to all members of the specified force.
function ReorderBeaconUp(beacon_key, force_name)
  local beacon_to_swap, beacon_to_swap_index = GetBeaconByKey(beacon_key)
  if beacon_to_swap_index > 1 then
    for i = beacon_to_swap_index - 1, 1, -1 do
      if global.PersonalTeleporter.beacons[i].entity.force.name == force_name or PersonalTeleporter.config.all_beacons_for_all then
        global.PersonalTeleporter.beacons[beacon_to_swap_index] = global.PersonalTeleporter.beacons[i]
        global.PersonalTeleporter.beacons[i] = beacon_to_swap
        return true
      end
    end
  end
  return false
end

--Swaps the beacon with the specified key with the next in the global list. Affects to all members of the specified force.
function ReorderBeaconDown(beacon_key, force_name)
  local beacon_to_swap, beacon_to_swap_index = GetBeaconByKey(beacon_key)
  if beacon_to_swap_index ~= CountBeacons() then
    for i = beacon_to_swap_index + 1, CountBeacons() do
      if global.PersonalTeleporter.beacons[i].entity.force.name == force_name or PersonalTeleporter.config.all_beacons_for_all then
        global.PersonalTeleporter.beacons[beacon_to_swap_index] = global.PersonalTeleporter.beacons[i]
        global.PersonalTeleporter.beacons[i] = beacon_to_swap
        return true
      end
    end
  end
  return false
end

--Sorts beacons list and returns sorted list as copy.
--If sorting is by distance from game start, then firstly go beacons on nauvis, then others.
--If sorting is by distance from player, then firstly go beacons on player's current surface.
function GetBeaconsSorted(list, force_name, sort_order, player)
  local sorted_beacons = {}
  for i, beacon in pairs(list) do
    if force_name == beacon.entity.force.name or PersonalTeleporter.config.all_beacons_for_all then
      table.insert(sorted_beacons, beacon)
    end
  end
  if sort_order == 1 then
    --Do nothing
  elseif sort_order == 2 then --sort by distance from game start
    local sorted_beacons_on_nauvis = {}
    local sorted_beacons_not_on_nauvis_by_surfaces = {}
    for i, beacon in pairs(sorted_beacons) do
      if beacon.entity.surface.name == "nauvis" then
        table.insert(sorted_beacons_on_nauvis, beacon)
      else
        local surface_name = beacon.entity.surface.name
        if not sorted_beacons_not_on_nauvis_by_surfaces[surface_name] then
          sorted_beacons_not_on_nauvis_by_surfaces[surface_name] = {}
        end
        table.insert(sorted_beacons_not_on_nauvis_by_surfaces[surface_name], beacon)
      end
    end
    table.sort(sorted_beacons_on_nauvis, function(a,b)
      local dist_a = GetDistanceBetween(a.entity.position, {x = 0, y = 0})
      local dist_b = GetDistanceBetween(b.entity.position, {x = 0, y = 0})
      return dist_a < dist_b
    end)
    for surface_name, beacons_on_surface in pairs(sorted_beacons_not_on_nauvis_by_surfaces) do
      table.sort(beacons_on_surface, function(a,b)
        local dist_a = GetDistanceBetween(a.entity.position, {x = 0, y = 0})
        local dist_b = GetDistanceBetween(b.entity.position, {x = 0, y = 0})
        return dist_a < dist_b
      end)
      for n, beacon in pairs(beacons_on_surface) do
        table.insert(sorted_beacons_on_nauvis, beacon)
      end
    end
    sorted_beacons = sorted_beacons_on_nauvis
  elseif sort_order == 3 then --sort by distance from player
    local sorted_beacons_on_current_surface = {}
    local sorted_beacons_not_on_current_surface_by_surfaces = {}
    for i, beacon in pairs(sorted_beacons) do
      if beacon.entity.surface.name == player.surface.name then
        table.insert(sorted_beacons_on_current_surface, beacon)
      else
        local surface_name = beacon.entity.surface.name
        if not sorted_beacons_not_on_current_surface_by_surfaces[surface_name] then
          sorted_beacons_not_on_current_surface_by_surfaces[surface_name] = {}
        end
        table.insert(sorted_beacons_not_on_current_surface_by_surfaces[surface_name], beacon)
      end
    end
    table.sort(sorted_beacons_on_current_surface, function(a,b)
      local dist_a = GetDistanceBetween(a.entity.position, player.position)
      local dist_b = GetDistanceBetween(b.entity.position, player.position)
      return dist_a < dist_b
    end)
    for surface_name, beacons_on_surface in pairs(sorted_beacons_not_on_current_surface_by_surfaces) do
      table.sort(beacons_on_surface, function(a,b)
        local dist_a = GetDistanceBetween(a.entity.position, player.position)
        local dist_b = GetDistanceBetween(b.entity.position, player.position)
        return dist_a < dist_b
      end)
      for n, beacon in pairs(beacons_on_surface) do
        table.insert(sorted_beacons_on_current_surface, beacon)
      end
    end
    sorted_beacons = sorted_beacons_on_current_surface
  end
  return sorted_beacons
end

function GetListPage(player, list, page, page_size)
  local list_page = {} --page of list, consists all records of the specified page
  local current_page_num --current page naumber, usually equals to received "page" and doesn't changes
  local total_pages_num --total number of pages
  total_pages_num = math.floor(#list / page_size)
  if total_pages_num * page_size < #list then
    total_pages_num = total_pages_num + 1
  end
  if page <= total_pages_num then
    current_page_num = page
  else
    current_page_num = total_pages_num
    global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num = current_page_num
  end
  local first_record_num_on_page = (current_page_num  - 1)* page_size + 1
  for i = first_record_num_on_page, first_record_num_on_page + page_size - 1, 1 do
    if not list[i] then
      break
    end
    table.insert(list_page, list[i])
  end
  return list_page, current_page_num, total_pages_num
end

function ActivateBeacon(player, beacon_key)
  local required_energy_eq = PersonalTeleporter.config.energy_in_personal_teleporter_to_use_beacon
  local required_energy_beacon = PersonalTeleporter.config.energy_in_beacon_to_activate
  local beacon = GetBeaconByKey(beacon_key)
	local sending_beacon = GetSendingBeaconUnderPlayer(player, required_energy_beacon)
  local failure_message
  if sending_beacon then
    if sending_beacon.energy >= required_energy_beacon then
      local receiving_beacon_entity = GetDestinationBeacon(beacon)
      if receiving_beacon_entity.energy >= required_energy_beacon then
        Teleport(player, receiving_beacon_entity.surface.name, receiving_beacon_entity.position)
        sending_beacon.energy = sending_beacon.energy - required_energy_beacon
        receiving_beacon_entity.energy = receiving_beacon_entity.energy - required_energy_beacon
        return true
      else --receiving_beacon_entity.energy < required_energy_beacon
        failure_message = {"message-no-power-tb", math.floor(receiving_beacon_entity.energy * 100 / required_energy_beacon)}
        player.print(failure_message)
        return false
      end
    end
  end
  local equipment = GetPlayerEquipment(player)
  if equipment then
    if equipment.energy >= required_energy_eq then
      local receiving_beacon_entity = GetDestinationBeacon(beacon)
      if receiving_beacon_entity.energy >= required_energy_beacon then
        Teleport(player, receiving_beacon_entity.surface.name, receiving_beacon_entity.position)
        equipment.energy = equipment.energy - required_energy_eq
        receiving_beacon_entity.energy = receiving_beacon_entity.energy - required_energy_beacon
        return true
      else --receiving_beacon_entity.energy < required_energy_beacon
        failure_message = {"message-no-power-tb", math.floor(receiving_beacon_entity.energy * 100 / required_energy_beacon)}
        player.print(failure_message)
        return false
      end
    else --equipment.energy < required_energy_eq
      failure_message = {"message-no-power-pt", math.floor(equipment.energy * 100 / required_energy_eq)}
      player.print(failure_message)
      return false
    end
  else -- no equipment and no charged sending beacon
    failure_message = {"message-no-sending-beacons-or-equipment"}
    player.print(failure_message)
    return false
  end
end

function ActivatePortal(player, destination_position)
	if IsHolding({name="Portal", count=1}, player) then
    local cooldown_in_ticks_between_usages = 30
    InitializePlayerGlobals(player)
    if not global.PersonalTeleporter.player_settings[player.name].used_portal_on_tick then
      global.PersonalTeleporter.player_settings[player.name].used_portal_on_tick = 0
    end
    local ticks_passed_since_last_use = game.tick - global.PersonalTeleporter.player_settings[player.name].used_portal_on_tick
    if ticks_passed_since_last_use < cooldown_in_ticks_between_usages then
      if ticks_passed_since_last_use > 15 then
        player.print({"message-too-frequent-use-portal", cooldown_in_ticks_between_usages / 60})
      end
      return
    else
      local distance = GetDistanceBetween(player.position, destination_position)
      local energy_required = PersonalTeleporter.config.energy_in_personal_teleporter_to_use_portal * distance
      local equipment = GetPlayerEquipment(player)
      if equipment then
        if equipment.energy >= energy_required then
          local valid_position = CheckDestinationPosition(destination_position, player)
          if valid_position then
            player.teleport(destination_position, player.surface)
            global.PersonalTeleporter.player_settings[player.name].used_portal_on_tick = game.tick
            equipment.energy = equipment.energy - energy_required
            return true
          else
            return false
          end
        else --equipment.energy < energy_required
          local failure_message = {"message-no-power-pt", math.floor(equipment.energy * 100 / energy_required)}
          player.print(failure_message)
          return false
        end
      else
        local failure_message = {"message-no-equipment"}
        player.print(failure_message)
        return false
      end
    end
	end
end

function GetSendingBeaconUnderPlayer(player)
  local beacons_under_player = player.surface.find_entities_filtered({name = "Teleporter-Beacon", position = player.position})
  if beacons_under_player and #beacons_under_player > 0 then
    local most_charged_beacon
    for i, beacon_entity in pairs(beacons_under_player) do
      if not most_charged_beacon then
        most_charged_beacon = beacon_entity
      end
      if most_charged_beacon.energy < beacon_entity.energy then
        most_charged_beacon = beacon_entity
      end
    end
    return most_charged_beacon
  else
    return false
  end
end

function GetPlayerEquipment(player)
  if player ~= nil and player.valid and player.connected then
    local equipment = player.get_inventory(defines.inventory.player_armor)[1].grid.equipment
    local has_equipment = false
    local most_charged_personal_teleporter = false
    for i, item in pairs(equipment) do
      if item.name == "Personal-Teleporter" then
        if not most_charged_personal_teleporter then
          most_charged_personal_teleporter = item
        end
        if most_charged_personal_teleporter.energy < item.energy then
          most_charged_personal_teleporter = item
        end
      end
    end
    return most_charged_personal_teleporter
  end
  return false
end

function GetDestinationBeacon(beacon)
  return beacon.entity
end

function CheckDestinationPosition(position, player)
  if player.surface.can_place_entity({name = "medium-biter", position = position}) or PersonalTeleporter.config.straight_jump_ignores_collisions then
    return true
  end
  player.print({"message-invalid-destination"})
  return false
end

function IsHolding(stack, player) -- thanks to supercheese (Orbital Ion Cannon author)
	local holding = player.cursor_stack
	if holding and holding.valid_for_read and (holding.name == stack.name) and (holding.count >= stack.count) then
		return true
	end
	return false
end

function Teleport(player, surface_name, destination_position)
  player.teleport({destination_position.x-0.3, destination_position.y + 0.1}, surface_name)
end

function GetDistanceBetween(position1, position2)
  return math.sqrt(math.pow(position2.x - position1.x, 2) + math.pow(position2.y - position1.y, 2))
end

--===================================================================--
--############################### GUI ###############################--
--===================================================================--

--Updates GUI for all players of a given LuaForce. If this force owns any beacons - it's members will see them.
function UpdateGui(force)
  InitializeGeneralGlobals()
  local number_of_beacons_belonging_to_force = CountBeacons(force.name)
  for i, player in pairs(force.players) do
    InitializePlayerGlobals(player)
    if number_of_beacons_belonging_to_force == 0 then
      HideMainButton(player)
      HideMainWindow(player)
    else
      ShowMainButton(player)
      UpdateMainWindow(player)
    end
  end
end

--Shows mod's main button in player's GUI.
function ShowMainButton(player)
  if player ~= nil and player.valid and player.connected then
    local gui = player.gui.top
    if not gui.personal_teleporter_main_button then
      local button = gui.add({type="button", name="personal_teleporter_main_button", style = "personal_teleporter_sprite_button_style"})
      button.tooltip = {"tooltip-button-main"}
    end
  end
end

--Hides mod's main button for player.
function HideMainButton(player)
  if player ~= nil and player.valid and player.connected then
    local gui = player.gui.top
    if gui.personal_teleporter_main_button then
      gui["personal_teleporter_main_button"].destroy()
    end
  end
end

--Opens mod's main window for player.
function ShowMainWindow(player)
  if player ~= nil and player.valid and player.connected then
    local gui = player.gui.left
    if not gui.personal_teleporter_main_window then
      local window = gui.add({type="flow", name="personal_teleporter_main_window", direction="vertical", style="personal_teleporter_thin_flow"})
      local grid = window.add({type="table", name="personal_teleporter_main_window_grid", colspan=2})
      grid.style.cell_spacing = 0
      grid.style.horizontal_spacing = 0
      grid.style.vertical_spacing = 0
      local window_menu_paging = grid.add({type="frame", name="personal_teleporter_window_menu_paging", direction="horizontal", style="personal_teleporter_thin_frame"})
      local buttonFlow = window_menu_paging.add({type="flow", name="personal_teleporter_paging", direction="horizontal", colspan=2, style="personal_teleporter_button_flow"})
      local button
      button = buttonFlow.add({type="button", name="personal_teleporter_button_page_back", caption="<", style="personal_teleporter_button_style"})
      button.tooltip = {"tooltip-button-page-prev"}
      buttonFlow.add({type="label", name="personal_teleporter_label_page_number", caption="21-30/500", style="personal_teleporter_label_style"})
      button = buttonFlow.add({type="button", name="personal_teleporter_button_page_forward", caption=">", style="personal_teleporter_button_style"})
      button.tooltip = {"tooltip-button-page-next"}
      local window_menu_sorting = grid.add({type="frame", name="personal_teleporter_window_menu_sorting", direction="horizontal", style="personal_teleporter_thin_frame"})
      buttonFlow = window_menu_sorting.add({type="flow", name="personal_teleporter_buttons_sorting", direction="horizontal", colspan=2, style="personal_teleporter_button_flow"})
      buttonFlow.add({type="label", name="personal_teleporter_sorting_label", caption={"label-sort-by"}, style="personal_teleporter_label_style"})
      button = buttonFlow.add({type="button", name="personal_teleporter_button_sort_global", caption="G", style="personal_teleporter_button_style"})
      button.tooltip = {"tooltip-button-sort-global"}
      button = buttonFlow.add({type="button", name="personal_teleporter_button_sort_distance_from_player", caption="P", style="personal_teleporter_button_style"})
      button.tooltip = {"tooltip-button-sort-distance-from-player"}
      button = buttonFlow.add({type="button", name="personal_teleporter_button_sort_distance_from_start", caption="S", style="personal_teleporter_button_style"})
      button.tooltip = {"tooltip-button-sort-distance-from-start"}
      UpdateMainWindow(player)
    end
  end
end

--Updates GUI-list of beacons, if player's mod's window is opened. All sortings are beeing initiated from this function.
function UpdateMainWindow(player)
  if player ~= nil and player.valid and player.connected then
    local gui = GetBeaconsButtonsGrid(player)
    if gui then
      --[[At first we'll remove existing rows (except window menu - first two gui elements in table).
          If we'll do it in straight order, then the first column of table will be as wide as the second.]]
      for i = #gui.children_names, 1, -1 do
        local gui_name = gui.children_names[i]
        if not string.find(gui_name, "window_menu") then
          gui[gui_name].destroy()
        end
      end
      local list = global.PersonalTeleporter.beacons
      InitializePlayerGlobals(player)
      local list_sorted = GetBeaconsSorted(list, player.force.name, global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by, player)
      local list_page, current_page_num, total_pages_num = GetListPage(player, list_sorted, global.PersonalTeleporter.player_settings[player.name].beacons_list_current_page_num, PersonalTeleporter.config.page_size)
      gui.personal_teleporter_window_menu_paging.personal_teleporter_paging.personal_teleporter_label_page_number.caption = current_page_num .. "/" .. total_pages_num
      --Now let's add by one row for each beacon.
      for i, beacon in pairs(list_page) do
        local player_force = player.force.name
        local beacon_force = beacon.entity.force.name
        if player.force.name == beacon.entity.force.name or PersonalTeleporter.config.all_beacons_for_all then
          InitializePlayerGlobals(player)
          local sort_type = global.PersonalTeleporter.player_settings[player.name].beacons_list_is_sorted_by
          AddRow(gui, beacon, i, sort_type)
        end
      end
    end
  end
end

--Closes mod window for player.
function HideMainWindow(player)
  if player ~= nil and player.valid and player.connected then
    local gui = player.gui.left
    if gui.personal_teleporter_main_window then
      gui["personal_teleporter_main_window"].destroy()
    end
  end
end

--Closes opened mod window for player and opens closed window.
function SwitchMainWindow(player)
  if player ~= nil and player.valid and player.connected then
    if not player.gui.top.personal_teleporter_main_button then
      return
    end
    local gui = player.gui.left
    if gui.personal_teleporter_main_window then
      HideMainWindow(player)
    else
      ShowMainWindow(player)
    end
  end
end

--Adds rob with buttons and labels. One row represents one beacon. Index-based naming is not good, because rows should be sortable.
function AddRow(container, beacon, index, sort_type)
  local frame = container.add({type="frame", name="personal_teleporter_buttons_tools_" .. index, direction="horizontal", style="personal_teleporter_thin_frame"})
  local buttonFlow = frame.add({type="flow", name=beacon.key, direction="horizontal", style="personal_teleporter_button_flow"})
  buttonFlow.add({type="button", name="personal_teleporter_button_activate", caption="T", style="personal_teleporter_button_style"})
  buttonFlow.add({type="button", name="personal_teleporter_button_rename", caption="N", style="personal_teleporter_button_style"})
  if sort_type == 1 then
    local suffix
    if index > 1 then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name="personal_teleporter_button_order_up", caption=suffix .. "<", style="personal_teleporter_button_style"})
    if index < CountBeacons(beacon.entity.force.name) then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name="personal_teleporter_button_order_down", caption=">" .. suffix, style="personal_teleporter_button_style"})
  end
  frame = container.add({type="frame", name=beacon.key, direction="horizontal", style="personal_teleporter_thin_frame"})
  local label = frame.add({type="label", name="personal_teleporter_label_beacons_name", caption=beacon.name, style="personal_teleporter_label_style"})
end

--Returns GUI-container for putting rows representing beacons. If mod window is hidden for the specified player, returns nil.
function GetBeaconsButtonsGrid(player)
  if player.gui.left.personal_teleporter_main_window then
    local container = player.gui.left["personal_teleporter_main_window"]
    if container.personal_teleporter_main_window_grid then
      container = container["personal_teleporter_main_window_grid"]
      return container
    end
  end
  return nil
end

function OpenRenameWindow(player, beacon_key)
  local gui = player.gui.center
  if gui.personal_teleporter_rename_window then
    return
  end
  local beacon = GetBeaconByKey(beacon_key)
  local frame = gui.add({type="frame", name="personal_teleporter_rename_window", direction="vertical", caption={"caption-rename-window"}})
  --frame.add({type="label", name="personal_teleporter_label_beacons_name", caption=beacon.name, style="personal_teleporter_label_style"})
  local text_box = frame.add({type="textfield", name="personal_teleporter_rename_textbox"})
  frame.personal_teleporter_rename_textbox.text = beacon.name
  local flow = frame.add({type="flow", name=beacon.key, direction="horizontal"})
  flow.add({type="button", name = "personal_teleporter_rename_window_button_cancel", caption={"caption-button-cancel"}})
  flow.add({type="button", name = "personal_teleporter_rename_window_button_ok" , caption={"caption-button-ok"}})
end

function CloseRenameWindow(player)
  local gui = player.gui.center
  if gui.personal_teleporter_rename_window then
    gui.personal_teleporter_rename_window.destroy()
  end
end

function SaveNewBeaconsName(player, beacon_key)
  local gui = player.gui.center
  if not gui.personal_teleporter_rename_window then
    return
  end
  local beacon = GetBeaconByKey(beacon_key)
  local new_name = gui.personal_teleporter_rename_window.personal_teleporter_rename_textbox.text
  if string.len(new_name) < 2 then
    new_name = CreateBeaconName(beacon.entity)
  end
  beacon.name = new_name
  gui.personal_teleporter_rename_window.destroy()
end

--===================================================================--
--####################### MIGRATION FROM 0.1.6 ######################--
--===================================================================--
function Migrate016to020()
  game.players[1].print("Trying to migrate PersonalTeleporter from 0.1.6 to 0.2.X...")
  if global.TelaportLocations ~= nil then
    game.players[1].print("...migrating...")
    --global.TelaportLocations[x][1] = name
    --global.TelaportLocations[x][2] = x 
    --global.TelaportLocations[x][3] = y 
    --global.TelaportLocations[x][4] = surface
    for i, old_entry in pairs(global.TelaportLocations) do
      if old_entry ~= nil and old_entry[2] ~= nil and old_entry[3] ~= nil then
        local position = {x = old_entry[2], y = old_entry[3]}
        local surface_name = "nauvis"
        if old_entry[4] ~= nil then
          surface_name = old_entry[4]
        end
        local beacons_ent = game.surfaces[surface_name].find_entities_filtered({name="Teleporter-Beacon", position=position})
        if beacons_ent and beacons_ent[1] and beacons_ent[1].valid then
          local beacon_entity = beacons_ent[1]
          local name
          if old_entry[1] and string.len(old_entry[1]) > 0 then
            name = old_entry[1]
          else
            name = CreateBeaconName(beacon_entity)
          end
          local key = CreateBeaconKey(beacon_entity)
          if not global.PersonalTeleporter then
            global.PersonalTeleporter = {}
          end
          if not global.PersonalTeleporter.beacons then
            global.PersonalTeleporter.beacons = {}
          end
          local beacon = {entity = beacon_entity, key = key, name = name}
          table.insert(global.PersonalTeleporter.beacons, beacon)
        end
      end
      old_entry = nil
    end
    global.TelaportLocations = nil
    global.TeleporterButtonActivated = nil
    global.guiTelSetting = nil
    for i, player in pairs(game.players) do
      if player.gui.top.PersonalTeleportTool ~= nil then
        player.gui.top.PersonalTeleportTool.destroy()
      end
      if player.gui.left.personlaTeleportWindow ~= nil then
        player.gui.left.personlaTeleportWindow.destroy()
      end
    end
    for i, force in pairs(game.forces) do
      if force.technologies["Personal-Teleportation"].researched then
        force.technologies["Personal-Teleportation-Adv"].researched = true
      end
      UpdateGui(force)
    end
    game.players[1].print("...successfully migrated!")
  else
    game.players[1].print("...nothing to migrate.")
  end
end
