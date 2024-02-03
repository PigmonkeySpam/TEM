serialization = require("serialization")
component = require("component")
event = require("event")
rs_interface = component.block_refinedstorage_interface
modem = component.modem
gpu = component.gpu
modem.open(444) 





--! have a separate calibrate stock functinon
--! we only really need to know stuff when the stock drops below a certain point

function updateStockValue(item, stockValue)
    -- get stock level
    if stockValue == nil then
        itemResult = rs_interface.getItem(item)
        if itemResult == nil then
            stockValue = 0
        else
            stockValue = itemResult.size()
        end
    end

    -- http msg
end



local mobNodeOnStates = {
    {mobName="spider", state=true},
    {mobName="creeper", state=true},
    {mobName="blizz", state=true},
    {mobName="blitz", state=true},
    {mobName="basalz", state=true}
}
local mobMaterials = {
    {mobName = "blizz", id={name="thermalfoundation:material", damage=2049}}, -- blizz powder
    {mobName = "blitz", id={name="thermalfoundation:material", damage=2051}}, -- blitz powder
    {mobName = "basalz", id={name="thermalfoundation:material", damage=2053}} -- basalz powder
}


function setMobNodeOnState(mobName, state)
    for i, mobNodeOnState in pairs(mobNodeOnStates) do
        if mobNodeOnState.mobName == mobName then
            if state ~= mobNodeOnState then
                mobNodeOnStates[i].state = state
                -- todo http stuff
                -- todo: plus the redstone pulse (so all the computers get the new state)
            end
        end
    end
end


function doesMaterialNeedRestock(itemInfo, material)
    if itemInfo == nil then
        itemAmount = 0
    else
        itemAmount = itemInfo.size
    end

    if itemAmount < 100 then
        return true
    else
        return false
    end
end


  

function mobGrinderCheck(item)
    for i, material in pairs(mobMaterials) do
        if item == material.id then
            itemInfo = rs_interface.getItem(item)
            doesMaterialNeedRestock(itemInfo, material)





--! >>>>>>>> existing
function printError(msg)
    gpu.setForeground(0xFF0000)
    print(msg)
end
function printSuccess(msg)
    gpu.setForeground(0x00FF00)
    print(msg)
end
function printInfo(msg)
    gpu.setForeground(0xFFFFFF)
    print(msg)
end

function topUp(item, extractAmount)
    if loopMax == nil then loopMax = 22 end

    local totalExtracted = 0
    for i = 1, loopMax do
        amountExtracted = rs_interface.extractItem(item, 64, 1)
        if amountExtracted == nil then 
            printError("Extract error for "..item.name.." | "..totalExtracted.." of "..extractAmount.." items extracted")
            -- todo: http message to indicate the item below 10K
            break 
        end

        totalExtracted = totalExtracted + amountExtracted
        if totalExtracted > extractAmount then
            printSuccess("Success: "..totalExtracted.." "..item.name.." extracted")
            -- todo: http message to update stock value ...maybe- don't really need to send stock levels, just if the mob grinders need to turn on or not
            -- todo: the actually useful thing
            break
        end
    end
    printInfo("Extracted "..totalExtracted)
end


while true do
    local _, _, from, port, _, message = event.pull(5, "modem_message") 
    print(message)
    if from == "e35a3146-c21a-452c-9fcf-29593b7ef0f0" then
        msgIn = serialization.unserialize(message)
        item = msgIn[1]
        extractAmount = msgIn[2]
        topUp(item, extractAmount)
        mobGrinderCheck(item)
    end

end