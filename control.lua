--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics


require "config"
require "util"
function createTeleportButton(player)
  if player ~= nil then
    local topGui = player.gui.top
    if not topGui.PersonalTeleportTool  then
      topGui.add({type="button", name="PersonalTeleportTool", caption = "Teleport", style="blueprint_button_style"})
      --guiSettings.foremanVisable = true
    end
  end
end

script.on_init(function()
   initializeVaiables()
  --createTeleportButton(game.players[1])
end)
script.on_configuration_changed(function()
   initializeVaiables()
  --createTeleportButton(game.players[1])
end)

script.on_event(defines.events.on_player_created, function(event)
 initializeVaiables()
 if global.TeleporterButtonActivated == true then
 
   local playerNum5 = 1
      
      while game.players[playerNum5] do
         createTeleportButton(game.players[playerNum5])
         playerNum5 = playerNum5 +1
      end
 
    --for playernum3,player3 in ipairs(game.players) do
    --createTeleportButton(player3)
    -- createTeleportButton(game.players[x])
     --end
  end
end)

function initializeVaiables()
if global.TelaportLocations == nil then
   global.TelaportLocations = {}
   global.TelaportLocations[0] = {}
   global.TeleporterButtonActivated = false
      --global.TelaportLocations[x][1] = name
      --global.TelaportLocations[x][2] = x 
      --global.TelaportLocations[x][3] = y 
      --global.TelaportLocations[x][4] = surface
   end
if global.guiTelSetting == nil then
   global.guiTelSetting = {}
   global.guiTelSetting.visiable = false
   global.guiTelSetting.window = nil
   global.guiTelSetting.page = 1
   
end
end


function creatTelportWindow(Parplayer)



   local player = Parplayer
      local gui = player.gui.top
   if gui.personlaTeleportWindow ~= nil then
      gui.personlaTeleportWindow.destroy()

   end

   global.guiTelSetting.visiable = true
      
   local window = gui.add({type="flow", name="personlaTeleportWindow", direction="vertical", style="blueprint_thin_flow"})
   global.guiTelSetting.window = window
   local buttons = window.add({type="frame", name="blueprintButtons", direction="horizontal", style="blueprint_thin_frame"})
    local buttonFlow = buttons.add({type="flow", name="pageButtonFlow", direction="horizontal", style="blueprint_button_flow"})
local Count = 0
for Index, Value in pairs( global.TelaportLocations ) do
  Count = Count + 1
end
if Count %10 == 0 then
      Count = Count /10
   
   else
      Count = Count /10
      Count = math.floor((Count) +1)
      end
   buttonFlow.add({type="button", name="teleportPageBack", caption="<", style="blueprint_button_style"})
   buttonFlow.add({type="label", name="TelaportInfoPages", caption=global.guiTelSetting.page.."/"..Count, style="blueprint_label_style"})
   buttonFlow.add({type="button", name="teleportPageForward", caption=">", style="blueprint_button_style"})
    displayed = 0
   for i,telaportLoc in ipairs(global.TelaportLocations) do
      if (i > (global.guiTelSetting.page -1) *10) then
        displayed = displayed + 1
        createTelaPortLocationFrame(telaportLoc,i,window)
        if displayed >= 10 then
          break
        end
      end
     
  
    end

end

script.on_event(defines.events.on_gui_click, function(event)
  local refreshWindow = false
  local refreshWindows = false
  local player = game.players[event.element.player_index]
  
  if event.element.name == "PersonalTeleportTool" and global.guiTelSetting.visiable == false then
    creatTelportWindow(player)
  
  elseif event.element.name == "PersonalTeleportTool" and global.guiTelSetting.visiable == true then
    --close window
     global.guiTelSetting.visiable = false;
     global.guiTelSetting.window.destroy()
  
  elseif endsWith(event.element.name, "_TelaportTo") then
     local noPT = true
     local PTHasEnergy = false
     local TBHasEnergy = false
     if player.get_inventory(defines.inventory.player_armor)[1].valid_for_read then    --get_item_count("Personal-Teleporter") > 0 then
      if player.get_inventory(defines.inventory.player_armor)[1].grid then
        local equipment = player.get_inventory(defines.inventory.player_armor)[1].grid.equipment
        for indexE,equip in pairs(equipment) do
          if equip.name == "Personal-Teleporter" then
            noPT = false
            if equip.energy > 2000000 then
              PTHasEnergy = true
              local data = split(event.element.name,"_")
              local telaportLocIndex = tonumber(data[1])
              local TelporterLocation = global.TelaportLocations[telaportLocIndex]
              if TelporterLocation == nil then
                return
              end
              --check to see if teleport beakon has power
              local teleportSurface = "nauvis"
              if TelporterLocation[4] ~= nil then
                teleportSurface = TelporterLocation[4]
              end
              local localEntities = game.surfaces[teleportSurface].find_entities({{TelporterLocation[2]-1,TelporterLocation[3]+1},{TelporterLocation[2]+1,TelporterLocation[3]-1}})
              for x,entity in ipairs(localEntities) do
                if string.find(entity.name,"Teleporter_Beacon")  then
                  if entity.energy > 10000 then
                    TBHasEnergy = true
                    entity.energy = entity.energy - 10000000
                    equip.energy = equip.energy - 2000000
                    if TelporterLocation[4] ~= nil then
                      game.players[event.element.player_index].print("TP to: " .. TelporterLocation[2] .. ", " .. TelporterLocation[3] .. ", " .. TelporterLocation[4] .. ".")
                      game.players[event.element.player_index].teleport({TelporterLocation[2],TelporterLocation[3]},TelporterLocation[4])
                    else
                      game.players[event.element.player_index].print("TP to: " .. TelporterLocation[2] .. ", " .. TelporterLocation[3] .. ".")
                      game.players[event.element.player_index].teleport({TelporterLocation[2],TelporterLocation[3]},"nauvis")
                    end
                  end
                end
              end
              --equip.energy = equip.energy - 2000000
              --local data = split(event.element.name,"_")
              --local telaportLocIndex = tonumber(data[1])
              --game.players[event.element.player_index].teleport({TelporterLocation[2],TelporterLocation[3]})
            end
          end
        end
      end
     end
      if noPT then
         player.print("You need a Personal Teleporter in you Power Armour before you can Teleport")
      elseif PTHasEnergy == false then
         player.print("Not enough energy in Personal Telaporter, it takes 2MJ to teleport")
      elseif TBHasEnergy == false then
         player.print("The Teleporter Beacon at your requested destination does not have enough energy, it needs 10MJ")
      end
    
  elseif endsWith(event.element.name, "_TelaportRename") then
    if guiTelSettingRenameWindowVisible then
      return
    end
    local data = split(event.element.name,"_")
    local telaportLocIndex = tonumber(data[1])
    guiTelSettingRenameWindowVisible = true
    createTelaPortRenameWindow(player.gui.center,telaportLocIndex,global.TelaportLocations[telaportLocIndex][1])
   
  elseif event.element.name == "TelaportRenameCancel" then
    if guiTelSettingRenameWindowVisible then
      player.gui.center.TelaportRenameWindow.destroy()
      guiTelSettingRenameWindowVisible = false
    end
   
   elseif event.element.name == "teleportPageBack" then
      if global.guiTelSetting.page > 1 then
         global.guiTelSetting.page = global.guiTelSetting.page -1
         creatTelportWindow(player)
      end
         
   elseif event.element.name == "teleportPageForward" then
    local Count = 0
    for Index, Value in pairs( global.TelaportLocations ) do
      Count = Count + 1
    end
      if Count > global.guiTelSetting.page *10 then
         global.guiTelSetting.page = global.guiTelSetting.page + 1
         creatTelportWindow(player)
      end
   
 elseif endsWith(event.element.name,"_TelaportRenameOK") then
    local data = split(event.element.name,"_")
    local TelaportIndex = data[1]
    if guiTelSettingRenameWindowVisible and TelaportIndex ~= nil then
      TelaportIndex = tonumber(TelaportIndex)
      local newName = player.gui.center.TelaportRenameWindow.TelaportRenameText.text
      if newName ~= nil then
        newName = cleanupName(newName)
        if newName ~= ""  then
          global.TelaportLocations[TelaportIndex][1] = newName
          player.gui.center.TelaportRenameWindow.destroy()
          guiTelSettingRenameWindowVisible = false
          if global.guiTelSetting.visiable == true then 
            creatTelportWindow(game.players[1])
          end
        end
      end
    end
  
   elseif endsWith(event.element.name,"_MoveUp") then
      local data = split(event.element.name,"_")
      local tpIndex = data[1]
      if tpIndex == nil    then return end
      tpIndex = tonumber(tpIndex)
      if tpIndex < 2       then return end
      local tempTP = global.TelaportLocations[tpIndex]
      global.TelaportLocations[tpIndex] = global.TelaportLocations[tpIndex - 1]
      global.TelaportLocations[tpIndex - 1] = tempTP
      --reopen window
      global.guiTelSetting.visiable = false;
      global.guiTelSetting.window.destroy()
      creatTelportWindow(player)
  
   elseif endsWith(event.element.name,"_MoveDown") then
      local data = split(event.element.name,"_")
      local tpIndex = data[1]
      if tpIndex == nil then
      return
    end
      tpIndex = tonumber(tpIndex)
      if tpIndex > #global.TelaportLocations - 1 then
      return
    end
      local tempTP = global.TelaportLocations[tpIndex]
      global.TelaportLocations[tpIndex] = global.TelaportLocations[tpIndex + 1]
      global.TelaportLocations[tpIndex + 1] = tempTP
      --reopen window
      global.guiTelSetting.visiable = false;
      global.guiTelSetting.window.destroy()
      creatTelportWindow(player)
   
  end
end)
  
  
  function cleanupName(name)
  return string.gsub(name, "[\\.?~!@#$%^&*(){}\"']", "")
end


  function createTelaPortRenameWindow(gui,TelportIndex,oldName)
   local frame = gui.add({type="frame", name="TelaportRenameWindow", direction="vertical", caption="Teleport Location Rename"})
    frame.add({type="textfield", name="TelaportRenameText"})
    frame.TelaportRenameText.text = oldName

    local flow = frame.add({type="flow", name="TelaportRenameFlow", direction="horizontal"})
    flow.add({type="button", name="TelaportRenameCancel", caption="Cancel"})
    flow.add({type="button", name=TelportIndex .. "_TelaportRenameOK" , caption="OK"})

    return frame
  
  end
  
  --big thanks to Foreman mod
function  createTelaPortLocationFrame(Telaport,index,gui)
   local frame = gui.add({type="frame", name=index .. "_TeleportInfoFrame", direction="horizontal", style="blueprint_thin_frame"})
    local buttonFlow = frame.add({type="flow", name=index .. "_InfoButtonFlow", direction="horizontal", style="blueprint_button_flow"})
  --  buttonFlow.add({type="button", name=index .. "_blueprintInfoDelete", caption={"btn-blueprint-delete"}, style="blueprint_button_style"})
  --  buttonFlow.add({type="button", name=index .. "_blueprintInfoLoad", caption={"btn-blueprint-load"}, style="blueprint_button_style"})
    buttonFlow.add({type="button", name=index .. "_TelaportTo", caption="T", style="blueprint_button_style"})
    buttonFlow.add({type="button", name=index .. "_TelaportRename", caption="N", style="blueprint_button_style"})
    local suffix
    if index > 1 then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name=index .. "_MoveUp", caption=suffix .. "<", style="blueprint_button_style"})
    if index < #global.TelaportLocations then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name=index .. "_MoveDown", caption=">" .. suffix, style="blueprint_button_style"})
    local label = frame.add({type="label", name=index .. "_TelaportInfoName", caption=Telaport[1], style="blueprint_label_style"})
   
  end
  
  
script.on_event(defines.events.on_built_entity, function(event)
   if string.find(event.created_entity.name,"Teleporter_Beacon") then
      --add telaporter to telaportLoc
      local x = event.created_entity.position.x
      local y = event.created_entity.position.y
      local surface = event.created_entity.surface.name
      
       initializeVaiables()
      
      table.insert(global.TelaportLocations,{"x:"..x..",y:"..y..",s:"..surface,x,y,surface})
      global.TeleporterButtonActivated = true
      local playerNum = 1
      
      while game.players[playerNum] do
         createTeleportButton(game.players[playerNum])
         playerNum = playerNum +1
      end
      
      --for playerNum,playerLoop1 in ipairs(game.players) do
         --game.players[1].print("here 3")
         --createTeleportButton(playerLoop1)
      --end
      if global.guiTelSetting.visiable == true then 
      
         local playerNum1 = 1
      
         while game.players[playerNum1] do
            creatTelportWindow(game.players[playerNum1])
            playerNum1 = playerNum1 +1
         end
      
      
      
         --for playerNum2,playerLoop2 in ipairs(game.players) do
         --game.players[1].print("here 6")
         --   creatTelportWindow(playerLoop2)
         --end
      end
   end

end)

script.on_event(defines.events.on_robot_built_entity, function(event)
   if string.find(event.created_entity.name,"Teleporter_Beacon") then
      --add telaporter to telaportLoc
      local x = event.created_entity.position.x
      local y = event.created_entity.position.y
    local surface = event.created_entity.surface.name
      
       initializeVaiables()
      
      table.insert(global.TelaportLocations,{"x:"..x..",y:"..y..",s:"..surface,x,y,surface})
      global.TeleporterButtonActivated = true
      local playerNum = 1
      
      while game.players[playerNum] do
         createTeleportButton(game.players[playerNum])
         playerNum = playerNum +1
      end
      
      --for playerNum,playerLoop1 in ipairs(game.players) do
         --game.players[1].print("here 3")
         --createTeleportButton(playerLoop1)
      --end
      if global.guiTelSetting.visiable == true then 
      
         local playerNum1 = 1
      
         while game.players[playerNum1] do
            creatTelportWindow(game.players[playerNum1])
            playerNum1 = playerNum1 +1
         end
      
      
      
         --for playerNum2,playerLoop2 in ipairs(game.players) do
         --game.players[1].print("here 6")
         --   creatTelportWindow(playerLoop2)
         --end
      end
   end

end)


script.on_event(defines.events.on_robot_mined, function(event)
   if string.find(event.item_stack.name ,"Teleporter_Beacon") then
      updateTelporterList()
   end


end)


script.on_event(defines.events.on_player_mined_item, function(event)
   if string.find(event.item_stack.name ,"Teleporter_Beacon") then
      updateTelporterList()
   end


end)



script.on_event(defines.events.on_entity_died, function(event)
   if string.find(event.entity.name ,"Teleporter_Beacon") then
      updateTelporterList()
   end


end)

function updateTelporterList()
   for i,telaportLoc in ipairs(global.TelaportLocations) do
    if (i > 0) then
      local teleportSurface = "nauvis"
      if telaportLoc[4] ~= nil then
        teleportSurface = telaportLoc[4]
      end
      local localEntities = game.surfaces[teleportSurface].find_entities({{telaportLoc[2]-1,telaportLoc[3]+1},{telaportLoc[2]+1,telaportLoc[3]-1}})
      --local localEntities = game.surfaces["nauvis"].find_entity("T",{telaportLoc[2],telaportLoc[3]})
      local destoryed = true
      for x,entity in ipairs(localEntities) do
        if string.find(entity.name,"Teleporter_Beacon") then
          if entity.type == "accumulator" then
            if entity.health > 0 then
              destoryed = false
            end
          end
        end
      end
      if destoryed == true then
        removeTelFromList(i)
      end
    end
  end
end

function removeTelFromList(localTelIndex)
	table.remove(global.TelaportLocations,localTelIndex)
	if global.guiTelSetting.visiable == true then 
		local playerNum1 = 1
		while game.players[playerNum1] do
			creatTelportWindow(game.players[playerNum1])
			playerNum1 = playerNum1 +1
		end
	end
end


--thanks to Foreman modd
function endsWith(String,End)
  return End=='' or string.sub(String,-string.len(End))==End
end

function split(stringA, sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  string.gsub(stringA, pattern, function(c) fields[#fields+1] = c end)
  return fields
end