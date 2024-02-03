local component = require("component")
local serialization = require("serialization")
local sides = require("sides")
event = require("event")
local rs_interface = component.block_refinedstorage_interface
local modem = component.modem
local gpu = component.gpu

local defaultTopUpLevel = 5000
local defaultOverflowLevel = 6000


function getSelectedItemIds()
    local allItemsList = rs_interface.getItems()
    if (#allItemsList == 0) then
        print("Error: no items found in the tongue - please add one type of item to that RS system")
        return nil
    end

    local idsToAdd = {}
    for itemInfo in pairs(allItemsList) do
        idToAdd = {name = itemInfo.name, damage = itemInfo.damage}
        table.insert(idsToAdd, idToAdd)
    end
    return idsToAdd
end


end
print("Add some items to the tongue and press enter to select them...")
-- select item in storage

-- confirm selection

-- add this to the list ...which is on a different computer