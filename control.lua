--A lot of Thanks to iUltimateLP and his mod SimpleTeleporters for inspiration and for the use of His Code and graphics
if not personalTeleporter then personalTeleporter = {} end
if not personalTeleporter.config then personalTeleporter.config = {} end
require("config")
require("util")

personalTeleporterButtonNamePrefix = "personalTeleporter"
--button name should go as follows 
--personalTeleporter_"ButtonName/discription"_"additionalIdentifier"
function createButtonName(ButtonNameDiscription,additionalIdentifier)
  local buttonName = personalTeleporterButtonNamePrefix .. "_" .. ButtonNameDiscription
  if additionalIdentifier then 
    buttonName = buttonName .. "_" .. additionalIdentifier
  end
  return buttonName
end

function createTeleportButton(player)
  if player ~= nil then
    local topGui = player.gui.top
    if not topGui.personalTeleporter_PersonalTeleportTool  then
      topGui.add({type="button", name=createButtonName("PersonalTeleportTool"), caption = "Teleport", style="blueprint_button_style"})
    end
  end
end

script.on_init(function()
   initializeVaiables()
end)

script.on_configuration_changed(function()
   initializeVaiables()
end)

script.on_event(defines.events.on_player_created, function(event)
 initializeVaiables()
 local player = game.players[event.player_index]
 global.players[player.name] = {category = "" , page = 1}
 setPlayerCategory(player , global.Categories[1].name)
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
        --global.TelaportLocations[x][5] = marker entity
        --global.telaportLocations[x][6] = array of categories starting at position 1 currently only one allowed
        --global.telaportLocations[x][6][x]= is  (Categorie name,position)
    else
      for i,telaportLoc in ipairs(global.TelaportLocations) do
        if telaportLoc[5] == nil then
          local position ={}
          position.x = telaportLoc[2]
          position.y = telaportLoc[3]
          local maker = game.surfaces[1].create_entity({name="TP_marker",position = position, force = game.forces.neutral})
          maker.backer_name = telaportLoc[1]
          telaportLoc[5] = maker
        end
      end
    end
    
  if global.TelaportLocations[0] ~= nil and  global.TelaportLocations[0][6] == nil then
    for i, telaportLoc in ipairs(global.TelaportLocations) do
      if telaportLoc[6] == nil then
        local category = {name = "ALL" , position = i}
        telaportLoc[6] = {}
        telaportLoc[6][1] = category
      end
    end
    remakeWindow = true
  end
  
  if global.Categories == nil then
    global.Categories = {}
    global.Categories[1] = {name = "ALL" , showRepeats = false}
    remakeWindow = true
  end

  if global.players == nil then 
    global.players = {}
    local playerNum1 = 1
    while game.players[playerNum1] do
      player = game.players[playerNum1]
      global.players[player.name] = {}
      setPlayerCategory(player , global.Categories[1].name)
      setPlayerPage( player , 1 )
      playerNum1 = playerNum1 +1
    end
    remakeWindow = true
  end
  
  local playerNum1 = 1
  while game.players[playerNum1] do
    player = game.players[playerNum1]
    local topGui = player.gui.top
    if topGui.PersonalTeleportTool  then
      topGui.PersonalTeleportTool.destroy()
      createTeleportButton(player)
    end
    
    playerNum1 = playerNum1 +1
  end
  recreateOpenWindows()
end


function creatTelportWindow(Parplayer)

  local player = Parplayer
  local gui = player.gui.left

  if global.TeleporterButtonActivated == false then
    if gui.personlaTeleportWindow ~= nil then
      gui.personlaTeleportWindow.destroy()
    end
    return false;
  end
  
  if gui.personlaTeleportWindow ~= nil then
    gui.personlaTeleportWindow.destroy()
  end

  playersCurrentCategory = getPlayerCategory(player)
  local localTelaportLocations = getTelaportLocations(playersCurrentCategory)
  local numberOfTelaporters = tableSize(localTelaportLocations)

  local window = gui.add({type="flow", name="personlaTeleportWindow", direction="vertical", style="blueprint_thin_flow"})
  local buttons = window.add({type="frame", name="blueprintButtons", direction="horizontal", style="blueprint_thin_frame"})
  local buttonFlow = buttons.add({type="flow", name="pageButtonFlow", direction="horizontal", style="blueprint_button_flow"})
  local Count = 0
  
  for Index, Value in pairs( localTelaportLocations ) do
    Count = Count + 1
  end
  
  local teleporterPerPage = personalTeleporter.config.teleporterPerPage
  
  if Count %teleporterPerPage == 0 then
    Count = Count /teleporterPerPage
  else
    Count = Count /teleporterPerPage
    Count = math.floor((Count) +1)
  end
  local playerPage = getPlayerPage(player)
  if playerPage > Count then
    playerPage = Count
    setPlayerPage( player , playerPage )
  end
  buttonFlow.add({type="button", name=createButtonName("teleportPageBack"), caption="<", style="blueprint_button_style"})
  buttonFlow.add({type="label", name="TelaportInfoPages", caption=playerPage.."/"..Count, style="blueprint_label_style"})
  buttonFlow.add({type="button", name=createButtonName("teleportPageForward"), caption=">", style="blueprint_button_style"})
  
  for i,category in ipairs(global.Categories) do
    if category.name == playersCurrentCategory then 
      buttonFlow.add({type="button", name=createButtonName("teleportCategory",category.name), caption=category.name, style="blueprint_button_style_bold"})
    else
      buttonFlow.add({type="button", name=createButtonName("teleportCategory",category.name), caption=category.name, style="blueprint_button_style"})
    end
  end
  
  if tableSize(global.Categories) < 5 then 
    buttonFlow.add({type="button", name=createButtonName("teleportCategoryAdd"), caption="+", style="blueprint_button_style"})
  end
  
  displayed = 0
  for i,telaportLoc in pairs(localTelaportLocations) do
    if (i > (playerPage -1) *teleporterPerPage) then
      displayed = displayed + 1
      createTelaPortLocationFrame(telaportLoc,i,window,numberOfTelaporters)
      if displayed >= teleporterPerPage then
        break
      end
    end
  end
end

script.on_event(defines.events.on_gui_click, function(event)
  if beginsWith(event.element.name,personalTeleporterButtonNamePrefix) == false then
    return
  end
  local player = game.players[event.element.player_index]
  
  local elementName = string.sub(event.element.name,string.len(personalTeleporterButtonNamePrefix)+2)
  player = game.players[event.element.player_index]
  local playerWindowOpenNamePrefix = getPlayerWindowOpenNamePrefix(player)
  
  if playerWindowOpenNamePrefix ~= false and beginsWith(elementName,playerWindowOpenNamePrefix) == false then
    player.print("Cannot use GUI when menu is open.")
    return
  end
 
  local refreshWindow = false
  local refreshWindows = false
  local playerPage = getPlayerPage(player)
  local playerCategory = getPlayerCategory(player)
  
  if elementName == "PersonalTeleportTool" and player.gui.left.personlaTeleportWindow == nil then
    creatTelportWindow(player)
  
  elseif elementName == "PersonalTeleportTool" and player.gui.left.personlaTeleportWindow ~= nil then
    --close window
    local gui = player.gui.left
    if gui.personlaTeleportWindow ~= nil then
      gui.personlaTeleportWindow.destroy()
    end
  
  elseif beginsWith(elementName, "TelaportTo") then
      local hasCharter = true
      
      if player.character == nil then
        hasCharter = false
        player.print("Can not teleport when you are in god mode.")
        return
      end
     local noPT = true
     local PTHasEnergy = false
     local TBHasEnergy = false
     if player.get_inventory(defines.inventory.character_armor)[1].valid_for_read then    --get_item_count("Personal-Teleporter") > 0 then
      if player.get_inventory(defines.inventory.character_armor)[1].grid then
        local equipment = player.get_inventory(defines.inventory.character_armor)[1].grid.equipment
        for indexE,equip in pairs(equipment) do
          if equip.name == "Personal-Teleporter" then
            noPT = false
            if equip.energy > personalTeleporter.config.energyCostToTeleportEquipment then
              PTHasEnergy = true
              local data = split(elementName,"_")
              local telaportLocIndex = tonumber(data[2])
              local TelporterLocation = getTelaporter(player , telaportLocIndex)
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
                  if entity.energy > personalTeleporter.config.energyCostToTeleportBeacon then
                    TBHasEnergy = true
                    entity.energy = entity.energy - personalTeleporter.config.energyCostToTeleportBeacon
                    equip.energy = equip.energy - personalTeleporter.config.energyCostToTeleportEquipment
                    if TelporterLocation[4] ~= nil then
                      player.print("TP to: " .. TelporterLocation[1])
                      player.teleport({TelporterLocation[2],TelporterLocation[3]+.5},TelporterLocation[4])
                    else
                      player.print("TP to: " .. TelporterLocation[1])
                      player.teleport({TelporterLocation[2],TelporterLocation[3]+.5},"nauvis")
                    end
                  end
                end
              end
              --equip.energy = equip.energy - 2000000
              --local data = split(elementName,"_")
              --local telaportLocIndex = tonumber(data[2])
              --game.players[event.element.player_index].teleport({TelporterLocation[2],TelporterLocation[3]})
            end
          end
        end
      end
     end
      if noPT then
         player.print("You need a Personal Teleporter in you Power Armour before you can Teleport")
      elseif PTHasEnergy == false then
         player.print("Not enough energy in Personal Telaporter, it takes ".. personalTeleporter.config.energyCostToTeleportEquipment/1000000 .. "MJ to teleport")
      elseif TBHasEnergy == false then
         player.print("The Teleporter Beacon at your requested destination does not have enough energy, it needs " .. personalTeleporter.config.energyCostToTeleportBeacon/1000000 .. "MJ")
      end
    
  elseif beginsWith(elementName, "TelaportRenameOpen_") then
    if player.gui.center.TelaportRenameWindow ~= nill then
      return
    end
    local data = split(elementName,"_")
    local telaportLocIndex = tonumber(data[2])
    createTelaPortRenameWindow(player,telaportLocIndex,getTelaporter(player , telaportLocIndex)[1])
   
  elseif elementName == "TelaportRename_Cancel" then
    closeTelaPortRenameWindow(player)
   
  elseif elementName == "teleportPageBack" then
      if playerPage > 1 then
         setPlayerPage(player, playerPage -1 )
         creatTelportWindow(player)
      end
         
  elseif elementName == "teleportPageForward" then
    local Count = 0
    for Index, Value in pairs( getTelaportLocations( playerCategory ) ) do
      Count = Count + 1
    end
      if Count > playerPage *10 then
         setPlayerPage(player, playerPage + 1 )
         creatTelportWindow(player)
      end
   
  elseif beginsWith(elementName, "TelaportRename_OK") then
    onRenameConfirm(event)
  
  elseif beginsWith(elementName, "MoveUp") then
      local data = split(elementName,"_")
      local tpIndex = data[2]
      if tpIndex == nil    then return end
      tpIndex = tonumber(tpIndex)
      if tpIndex < 2       then return end
      local telaportLocations = getTelaportLocations(playerCategory)
      telaportLocations[tpIndex][6][1].position = tpIndex - 1
      telaportLocations[tpIndex - 1][6][1].position = tpIndex
      --reopen window
      recreateOpenWindows()
  
  elseif beginsWith(elementName, "MoveDown") then
    local data = split(elementName,"_")
    local tpIndex = data[2]
    if tpIndex == nil then
      return
    end
    local telaportLocations = getTelaportLocations(playerCategory)
    tpIndex = tonumber(tpIndex)
    if tpIndex > #telaportLocations - 1 then
      return
    end
    telaportLocations[tpIndex][6][1].position = tpIndex + 1
    telaportLocations[tpIndex + 1][6][1].position = tpIndex
    --reopen window
    recreateOpenWindows()
  
  elseif beginsWith(elementName, "teleportCategory_") then 
    local data = split(elementName,"_")
    local categoryName = data[2]
    if categoryName == getPlayerCategory(player) and (player.gui.center.TelaportCategorySettingWindow == nil) then 
      createCategorySettingWindow(player,categoryName)
      return
    end
    if categoryName ~= getPlayerCategory(player) then
      setPlayerCategory(player , categoryName)
      creatTelportWindow(player)
    end
  
  elseif elementName == "TelaportCategorySetting_Cancel" then 
    closeCategorySettingsWindow(player)
    
  elseif beginsWith(elementName, "TelaportCategorySetting_OK") then
    onCategorySettingsConfirm(event)
    
  elseif beginsWith(elementName, "TelaportSetCategoryOpen_") then 
    if player.gui.center.TelaportSetCategoryWindow == nil then
      local data = split(elementName,"_")
      local categoryPosition = data[2] 
      createTelaportSetCategoryWindow(player.gui.center ,categoryPosition, getPlayerCategory(player))
      setPlayerWindowOpenNamePrefix(player , "TelaportSetCategory")
    end
    
  elseif elementName == "TelaportSetCategory_Cancel" then 
    if player.gui.center.TelaportSetCategoryWindow ~= nil then
      player.gui.center.TelaportSetCategoryWindow.destroy()
      setPlayerWindowOpenNamePrefix(player , nil)
    end
    
  elseif beginsWith(elementName, "TelaportSetCategory_OK") then 
    local data = split(elementName,"_")
    local categoryPosition = tonumber(data[3])
    local newCategoryName = data[4]
    local currentCategory = getPlayerCategory(player)
    local done = false
    for i,telaportLoc in ipairs(global.TelaportLocations) do 
      for x,category in ipairs(telaportLoc[6]) do 
        if category.name == currentCategory and category.position == categoryPosition then
          category.position = getNextPosition( newCategoryName )
          category.name = newCategoryName
          done = true
          break
        end
      end
      if done then break end
    end
    callapseCategory(currentCategory)
    player.gui.center.TelaportSetCategoryWindow.destroy()
    setPlayerWindowOpenNamePrefix(player , nil)
    
    recreateOpenWindows()
    
  elseif elementName == "teleportCategoryAdd" then
    if player.gui.center.TelaportCategoryAddWindow == nil then
      createTelaportCategoryAddWindow(player)
    end
  
  elseif elementName == "TelaportCategoryAdd_Cancel" then
    closeCategoryAddWindow(player)
  
  elseif elementName == "TelaportCategoryAdd_OK" then 
    onCategoryAddConfirm(event)
    
  elseif beginsWith(elementName, "TelaportCategorySetting_Delete") then
    local data = split(elementName,"_")
    local CategoryCurrentName = data[3]
    local canDelete = true
    if tableSize(getTelaportLocations(CategoryCurrentName)) > 0 then
      --alert that player can not categories that still have teleporters in it
      player.print("can't delete category: " .. CategoryCurrentName .. " because it's not empty.")
      canDelete = false
    elseif tableSize(global.Categories) == 1 then
      player.print("can't delete category: " .. CategoryCurrentName .. " because it is the only category.")
    else
      for i,catagory in pairs(global.Categories) do 
        if catagory.name == CategoryCurrentName then
          table.remove(global.Categories,i)
          setPlayerCategory( player , global.Categories[1].name )
          creatTelportWindow(player)
        end
      end
    end
    --setPlayerCategory(player,newName)
    closeCategorySettingsWindow(player)
  end
end)
  
  
function cleanupName(name)
  return string.gsub(name, "_[\\.?~!@#$%^&*(){}\"']", "")
end


function createTelaPortRenameWindow(player,TelportIndex,oldName)
  local gui = player.gui.center;
  local frame = gui.add({type="frame", name="TelaportRenameWindow", direction="vertical", caption="Teleport Location Rename", tags={teleportIndex=TelportIndex}})
  frame.add({type="textfield", name="TelaportRenameText"})
  frame.TelaportRenameText.text = oldName
  
  local flow = frame.add({type="flow", name="TelaportRenameFlow", direction="horizontal"})
  flow.add({type="button", name=createButtonName("TelaportRename_Cancel"), caption="Cancel"})
  flow.add({type="button", name=createButtonName("TelaportRename_OK",TelportIndex) , caption="OK"})
  
  setPlayerWindowOpenNamePrefix(player,"TelaportRename")
  player.opened = frame;
  return frame
end

function closeTelaPortRenameWindow(player)
  if player.gui.center.TelaportRenameWindow ~= nil then
    player.gui.center.TelaportRenameWindow.destroy()
    setPlayerWindowOpenNamePrefix(player,nil)
  end
  player.opened = nil
end

script.on_event(defines.events.on_gui_closed, function(event)
  if not(event.element and event.element.valid) then
    return
  end

  local player = game.players[event.player_index]

  if event.element.name == "TelaportRenameWindow" then
    closeTelaPortRenameWindow(player)
  elseif event.element.name == "TelaportCategoryAddWindow" then
    closeCategoryAddWindow(player)
  elseif event.element.name == "TelaportCategorySettingWindow" then
    closeCategorySettingsWindow(player)
  end
end)

script.on_event(defines.events.on_gui_confirmed, function(event)
  if not(event.element and event.element.valid and event.element.parent) then
    return
  end

  if event.element.parent.name == "TelaportRenameWindow" then
    onRenameConfirm(event)
  elseif event.element.parent.name == "TelaportCategoryAddWindow" then
    onCategoryAddConfirm(event)
  elseif event.element.parent.name == "TelaportCategorySettingWindow" then
    onCategorySettingsConfirm(event)
  end
end)

function onRenameConfirm(event)
  local player = game.players[event.player_index]
  local frame = player.gui.center.TelaportRenameWindow
  if frame == nil then
    player.print("Could not find open rename window")
    return
  end
  local TelaportIndex = frame.tags.teleportIndex

  local newName = frame.TelaportRenameText.text
  if newName ~= nil then
    newName = cleanupName(newName)
    if newName ~= ""  then
      getTelaporter(player , TelaportIndex)[1] = newName
      getTelaporter(player , TelaportIndex)[5].backer_name = newName
      closeTelaPortRenameWindow(player)
      recreateOpenWindows()
    end
  end
end

  --big thanks to Foreman mod
function  createTelaPortLocationFrame(Telaport,index,gui,numberOfTelaporters)
  
   local frame = gui.add({type="frame", name=index .. "_TeleportInfoFrame", direction="horizontal", style="blueprint_thin_frame"})
    local buttonFlow = frame.add({type="flow", name=index .. "_InfoButtonFlow", direction="horizontal", style="blueprint_button_flow"})
  --  buttonFlow.add({type="button", name=index .. "_blueprintInfoDelete", caption={"btn-blueprint-delete"}, style="blueprint_button_style"})
  --  buttonFlow.add({type="button", name=index .. "_blueprintInfoLoad", caption={"btn-blueprint-load"}, style="blueprint_button_style"})
    buttonFlow.add({type="button", name=createButtonName("TelaportTo",index) , caption="T", style="blueprint_button_style"})
    buttonFlow.add({type="button", name=createButtonName("TelaportRenameOpen",index) , caption="N", style="blueprint_button_style"})
    buttonFlow.add({type="button", name=createButtonName("TelaportSetCategoryOpen",index) , caption="C", style="blueprint_button_style"})
    local suffix
    if index > 1 then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name=createButtonName("MoveUp",index), caption=suffix .. "<", style="blueprint_button_style"})
    if index < numberOfTelaporters then
      suffix = " "
    else
      suffix = "|"
    end
    buttonFlow.add({type="button", name=createButtonName("MoveDown",index) , caption=">" .. suffix, style="blueprint_button_style"})
    local label = frame.add({type="label", name=index .. "_TelaportInfoName", caption=Telaport[1], style="blueprint_label_style"})
   
end
  
  
script.on_event(defines.events.on_built_entity, function(event)
   if string.find(event.created_entity.name,"Teleporter_Beacon") then
      builtTelaporterBeacon(event)
   end
end)

function builtTelaporterBeacon(event)
  local x = event.created_entity.position.x
  local y = event.created_entity.position.y
  local surface = event.created_entity.surface.name

   initializeVaiables()
  local TP_marker = event.created_entity.surface.create_entity({name="TP_marker",position = event.created_entity.position, force = game.forces.neutral})
  TP_marker.backer_name = "x:"..x..",y:"..y..",s:"..surface

  local category = {name = global.Categories[1].name , position = getNextPosition(global.Categories[1].name)}
  table.insert(global.TelaportLocations,{"x:"..x..",y:"..y..",s:"..surface,x,y,surface,TP_marker,{category}})
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
  recreateOpenWindows()
end

script.on_event(defines.events.on_robot_built_entity, function(event)
  if string.find(event.created_entity.name,"Teleporter_Beacon") then
    builtTelaporterBeacon(event)
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

script.on_event(defines.events.on_entity_cloned, function(event)
  if string.find(event.source.name ,"Teleporter_Beacon") then
    onTeleporterCloned(event)
  end
  if string.find(event.source.name ,"TP_marker") then
    onTPMarkerCloned(event)
  end
end)

function onTPMarkerCloned(event)
  local sourceEntity = event.source
  local destinationEntity = event.destination
  
  for i,telaportLoc in ipairs(global.TelaportLocations) do
    if (i > 0) then
      if (sourceEntity.surface.name == telaportLoc[4]) then
        if (sourceEntity.position.x == telaportLoc[2] and sourceEntity.position.y == telaportLoc[3]) then
          --found source teleporter 
          telaportLoc[5] = destinationEntity
          return
          
        end
      end
      if (destinationEntity.surface.name == telaportLoc[4]) then
        if (destinationEntity.position.x == telaportLoc[2] and destinationEntity.position.y == telaportLoc[3]) then
          --found destination teleporter 
          telaportLoc[5] = destinationEntity
          return
          
        end
      end
    end
  end
  
end

function onTeleporterCloned(event)
  local sourceEntity = event.source
  local destinationEntity = event.destination
  
  for i,telaportLoc in ipairs(global.TelaportLocations) do
    if (i > 0) then
      if (sourceEntity.surface.name == telaportLoc[4]) then
        if (sourceEntity.position.x == telaportLoc[2] and sourceEntity.position.y == telaportLoc[3]) then
          --found source teleporter 
          telaportLoc[4] = destinationEntity.surface.name
          telaportLoc[2] = destinationEntity.position.x
          telaportLoc[3] = destinationEntity.position.y          
        end
      end
    end
  end
  
end

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
          if entity.type == "electric-energy-interface" then
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
  global.TelaportLocations[localTelIndex][5].destroy()
	table.remove(global.TelaportLocations,localTelIndex)
  callapseAllCategorys()
  recreateOpenWindows()
end


--thanks to Foreman modd
function endsWith(String,End)
  return End=='' or string.sub(String,-string.len(End))==End
end

function beginsWith(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function split(stringA, sep)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  string.gsub(stringA, pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function tableSize( T )
  local count = 0
  for x,t in pairs(T) do 
    count = count +1
  end
  return count 
end

function getTelaportLocations( Category )
  local locations = {}
  for i,telaportLoc in ipairs(global.TelaportLocations) do 
    for x,category in ipairs(telaportLoc[6]) do 
      if category.name == Category then
        locations[category.position] = telaportLoc
      end
    end
  end
  return locations
end

function createCategorySettingWindow(player,oldName)
  local gui = player.gui.center;
  local frame = gui.add({type="frame", name="TelaportCategorySettingWindow", direction="vertical", caption="Category Settings", tags={oldName=oldName}})
  frame.add({type="textfield", name="TelaportCategorySettingText"})
  frame.TelaportCategorySettingText.text = oldName

  local flow = frame.add({type="flow", name="TelaportCategorySettingFlow", direction="horizontal"})
  flow.add({type="button", name=createButtonName("TelaportCategorySetting_Cancel"), caption="Cancel"})
  flow.add({type="button", name=createButtonName("TelaportCategorySetting_Delete",oldName), caption="Delete"})
  flow.add({type="button", name=createButtonName("TelaportCategorySetting_OK",oldName) , caption="OK"})

  setPlayerWindowOpenNamePrefix(player, "TelaportCategorySetting")
  player.opened = frame
  return frame
end

function closeCategorySettingsWindow(player)
  player.gui.center.TelaportCategorySettingWindow.destroy()
  setPlayerWindowOpenNamePrefix(player, nil)
  player.opened = nil
end

function onCategorySettingsConfirm(event)
  local player = game.players[event.player_index]
  local frame = player.gui.center.TelaportCategorySettingWindow
  if frame == nil then
    player.print("Could not find open settings window")
    return
  end
  local CategoryCurrentName = frame.tags.oldName

  local newName = frame.TelaportCategorySettingText.text
  newName = cleanupName(newName)
  if not (newName ~= nil and newName ~= '') then
    --alert that player can not input black string as category name
    player.print("Category name cannot be blank / empty")
    return
  end

  for i,category in ipairs(global.Categories) do
    if category.name == newName then
      player.print("Can't rename Category to a name that already exist")
      return
    end
  end

  for i,category in ipairs(global.Categories) do
    if category.name == CategoryCurrentName then
      category.name = newName
    end
  end
  for i,telaportLoc in ipairs(global.TelaportLocations) do
    for x,category in ipairs(telaportLoc[6]) do
      if category.name == CategoryCurrentName then
        category.name = newName
      end
    end
  end
  setPlayerCategory(player,newName)
  
  closeCategorySettingsWindow(player)
  recreateOpenWindows()
end

function getNextPosition( Category )
  local position = 0
  for i,telaportLoc in ipairs(global.TelaportLocations) do 
    for x,category in ipairs(telaportLoc[6]) do 
      if category.name == Category then
        if category.position > position then 
          position = category.position
        end
      end
    end
  end
  return (position+1)
end 

function createTelaportSetCategoryWindow(gui,categoryPosition, currentCategory)
  local frame = gui.add({type="frame", name="TelaportSetCategoryWindow", direction="vertical", caption="Move Telaporter to:"})
  for i,category in ipairs(global.Categories) do 
    if category.name ~= currentCategory then 
      frame.add({type="button", name=createButtonName("TelaportSetCategory_OK",categoryPosition.."_"..category.name), caption=category.name})
    end
  end

  local flow = frame.add({type="flow", name="TelaportSetCategoryFlow", direction="horizontal"})
  flow.add({type="button", name=createButtonName("TelaportSetCategory_Cancel"), caption="Cancel"})

  return frame
end

function createTelaportCategoryAddWindow(player)
  local gui = player.gui.center
  local frame = gui.add({type="frame", name="TelaportCategoryAddWindow", direction="vertical", caption="New Category Name"})
  frame.add({type="textfield", name="TelaportCategoryAddText"})
  frame.TelaportCategoryAddText.text = ""

  local flow = frame.add({type="flow", name="TelaportCategoryAddFlow", direction="horizontal"})
  flow.add({type="button", name=createButtonName("TelaportCategoryAdd_Cancel"), caption="Cancel"})
  flow.add({type="button", name=createButtonName("TelaportCategoryAdd_OK") , caption="OK"})

  setPlayerWindowOpenNamePrefix(player , "TelaportCategoryAdd")
  player.opened = frame
  return frame
end

function closeCategoryAddWindow(player)
  player.gui.center.TelaportCategoryAddWindow.destroy()
  setPlayerWindowOpenNamePrefix(player,nil)
  player.opened = nil
end

function onCategoryAddConfirm(event)
  local player = game.players[event.player_index]
  local frame = player.gui.center.TelaportCategoryAddWindow
  if frame == nil then
    player.print("Could not find open window")
    return
  end

  local categoryName = frame.TelaportCategoryAddText.text
  if not(categoryName ~= nil and categoryName ~= '') then
    --alert that player can not input black string as category name
    player.print("can't have a blank category name.")
    return
  end

  if categoryNameAllreadyExist(categoryName,player) then
    player.print("A category with the same name already exists")
    return
  end

  addCategory(categoryName)
  recreateOpenWindows()
  closeCategoryAddWindow(player)
end

function getPlayerWindowOpenNamePrefix( player )
  if getGlobalPlayer( player ).WindowOpenNamePrefix == nil then 
    return false
  end
  return getGlobalPlayer( player ).WindowOpenNamePrefix
end

function setPlayerWindowOpenNamePrefix( player , WindowNamePrefix)
  getGlobalPlayer( player ).WindowOpenNamePrefix = WindowNamePrefix;
end

function getPlayerCategory( player )
  if getGlobalPlayer( player ).category == nil then 
    setPlayerCategory( player , global.Categories[1].name )
  end
  return getGlobalPlayer( player ).category
end

function setPlayerCategory( player , category )
  if getGlobalPlayer( player ).category == nil or getGlobalPlayer( player ).category ~= category then
    getGlobalPlayer( player ).category = category
    setPlayerPage( player , 1 )
  end
end

function getPlayerPage( player )
  if getGlobalPlayer( player ).page == nil then 
    setPlayerPage( player , 1 )
  end
  return getGlobalPlayer( player ).page
end

function setPlayerPage( player , page )
  getGlobalPlayer( player ).page = page
end

function addCategory(categoryName)
  global.Categories[tableSize(global.Categories)+1] = {name = categoryName}
end

function getTelaporter(player , position)
  local category = getPlayerCategory( player)
  local telaporters = getTelaportLocations(category)
  return telaporters[position]
end

function callapseCategory(category)
  local telporters = getTelaportLocations(category)
  local intPosition = 1
  for i,telaportLoc in pairs(telporters) do 
    for x,intCategory in pairs(telaportLoc[6]) do 
      if intCategory.name == category then
        intCategory.position = intPosition
        intPosition = intPosition + 1
        break
      end
    end
  end
end

function callapseAllCategorys()
  for i,catagory in pairs(global.Categories) do 
    callapseCategory(catagory.name)
  end
end

-- check to see if category name is already in use and if it is print error message
-- return true if category name is already in use else return false 
function categoryNameAllreadyExist(newCategoryName,player)
  newName = newCategoryName
    for i,category in ipairs(global.Categories) do
      if category.name == newName then
        player.print("can't rename Category to a name that already exist")
        return true
      end
    end
    return false
end

--use when you are changing something in the telaporter window to recreate any open winodws
function recreateOpenWindows()
  local playerNum1 = 1
  while game.players[playerNum1] do
    if game.players[playerNum1].gui.left.personlaTeleportWindow ~= nil then
      creatTelportWindow(game.players[playerNum1])
    end
    playerNum1 = playerNum1 +1
  end
end

-- get the player from the global varible 
-- allowed to access global to get players
-- should be the only access point to global.players
function getGlobalPlayer( player )
  if global.players[player.name] == nil then 
    global.players[player.name] = {}
    setPlayerCategory(player , global.Categories[1].name)
    setPlayerPage( player , 1 )
  end
  return  global.players[player.name]
end

function printMessage(errorLevel , message)
  game.print(message)
end
