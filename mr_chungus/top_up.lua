serialization = require("serialization")
component = require("component")
event = require("event")
rs_interface = component.block_refinedstorage_interface
modem = component.modem
gpu = component.gpu
modem.open(444) 


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
            return false 
        end

        totalExtracted = totalExtracted + amountExtracted
        if totalExtracted > extractAmount then
            printSuccess("Success: "..totalExtracted.." "..item.name.." extracted")
            -- todo: http message to update stock value
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
        topUp(msgIn[1], msgIn[2])
    end

end