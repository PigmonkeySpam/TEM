local computer = require("computer")
local event = require("event")
local internet = require("internet")
local Json = require("json")
local sides = require("sides")
local serialization = require("serialization")
local term = require("term")
local component = require("component")
local redstone = component.redstone
local rs_interface = component.block_refinedstorage_interface

local emptyChestTime = 25
local rsInterfaceSide = 4
local inventoryUrl = ""
local passkey = "0zKWJanqSnaFsl7MKPUDlzVixZIBpNijmA72Ujmc0ovrhvt6Thxf028hIyOfGHl7"


local itemValueInCreditsList = {
    {id = {}, prettyName = "", creditValue = 1}
}


Servo = {}
function Servo:new(redstoneControlSide)
    local t = setmetatable({}, { __index = Servo})
    t.redstoneControlSide = redstoneControlSide 
    return t
end
function Servo:on()
    redstone.setOutput(self.redstoneControlSide, 15)
end
function Servo:off()
    redstone.setOutput(self.redstoneControlSide, 0)
end




function filterTypeInfoOnly(item)
    return {item.name, item.damage}
end

-- function totalInventoryItems(allItems)
--     totalled = {}
--     for i, item in pairs(allItems) do 
--         local itemTypeInfo = {item.name, item.damage}
--         if item.name ~= "minecraft:air" then -- ignore air 
--             local duplicate = false
--             for t, totalledItem in pairs(totalled) do
--                 if (itemTypeInfo == totalledItem.typeInfo) then
--                     totalled[t].size = totalled[t].size + item.size
--                     duplicate = true
--                     break -- if a duplicate is already found, no need to check the rest of the list for duplicates
--                 end
--             end 
--             if (not duplicate) then 
--                 local itemTable = {typeInfo = itemTypeInfo, size = item.size}
--                 table.insert(totalled, itemTable) 
--             end
--         end
--     end
--     return totalled
-- end

function filterRelevantInfo(item)
    return {name = item.name, damgem = item.damage, size = item.size}
end



function waitForPlayerTouchForever()
    local playername
    while true do
        _, _, _, _, _, playername = event.pull(60, "touch")
        if (playername ~= nil) then return playername end
    end
end

function waitForSpecificPlayerTouch(specificPlayername, timeout)
    _, _, _, _, _, playername = event.pull(timeout, "touch")
    if (playername == specificPlayername) then 
        return true 
    end
end
    


function selectPlayer()
    print("Right click to set yourself as the user")
    local tempPlayer = waitForPlayerTouchForever()
    print(tempPlayer.." selected as user\nWill lock in 5 seconds...\n(Please wait, do not click)")
    _, _, _, _, _, interuptingPlayername = event.pull(5, "touch")
    if (interuptingPlayername ~= nil) then 
        print("Interuptted by "..interuptingPlayername)
        os.sleep(2)
        print("\n\n\n")
        selectPlayer()
    end
    
    return tempPlayer
end


function postInventory(inventory, playername)
    local data = {
        inventory = inventory,
        playername = playername,
        passkey = passkey
    }
    local jsonData = Json:encode(data)
    -- internet.request(inventoryUrl, jsonData)
    print(jsonData)
end


local fillServo = Servo:new(sides.right)
local emptyServo = Servo:new(sides.left)
fillServo:off()
emptyServo:on()
while true do
    term.clear()
    print("\n\n\nThe Creditor - sell A.S.S. Inc. your stuff \n[version 0.1]")
    local selectedPlayername = selectPlayer()
    ::playerSelectedFor20Seconds::
    print("\n\n"..selectedPlayername.." selected for the next 20 seconds.\nRight click again to confirm items for sale (the chest will empty)")
    if (waitForSpecificPlayerTouch(selectedPlayername, 20)) then
        emptyServo:off()
        fillServo:on()
        print("Emptying chest, please wait 25 seconds.")
        os.sleep(emptyChestTime)
        fillServo:off()
        -- inventoryAll = totalInventoryItems(inventoryAllRaw)
        -- print(Json:encode_pretty(totalInventoryItems(inventoryAll)))
        inventoryList = filterRelevantInfo(rs_interface.getItems())
        postInventory(inventoryList, selectedPlayername)
        emptyServo:on()
    else
        print("Please right click again to remain selected.")
        if (waitForSpecificPlayerTouch(selectedPlayername, 8)) then
            goto playerSelectedFor20Seconds
        else
            print("You did not confirm in time\n...reboot")
            os.sleep(2)
        end
    end
end


    -- print(event.pull(4, "redstone_changed"))
    -- print(serialization.serialize(totalInventoryItems(inventoryAll)))



-- local filesystem = require("filesystem")
-- local internet = require("internet")
-- local handle = internet.request("https://raw.githubusercontent.com/sziberov/OpenComputers/master/lib/json.lua")
-- local result = ""

-- file = filesystem.open("/lib/json.lua", "a")
-- for chunk in handle do 
--     result = result..chunk 
--     print(chunk)
--     file:write(chunk)
-- end
-- file:close()
