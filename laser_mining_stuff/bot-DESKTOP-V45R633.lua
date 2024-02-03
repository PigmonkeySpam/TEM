local component = require("component")
local invController = component.inventory_controller

local myState = "???"
local serverAddress = "todo"

local storedToolSlot = 1
local stoneSlot = 2
local labBlockSlot = 3
local cableSlot = 4

function isPicEquipt() 
    robot.select(storedToolSlot)
    if robot.durability() == nil then
        return false
    else
        return true
    end
end 

function equipPic()
    if not isPicEquipt() then
        invController.equip()
    end
end

function equipCrescentHammer()
    if isPicEquipt() then
        invController.equip()
    end
end

function shiftRightClick()
    robot.use(sides.front, true)
end


function placeBack()
    robot.place(sides.back)
end






function doSealOff()
    -- emerge from hole ^
    equipPic()
    robot.select(stoneSlot)
    robot.swingUp()
    robot.up()

    robot.select(labBlockSlot)
    robot.swingUp()
    robot.up()

    robot.select(cableSlot)
    equipCrescentHammer()
    shiftRightClick()
    robot.up()
    -- top of hole
    shiftRightClick()
    robot.forward()
    robot.forward() -- above laser drill

    shiftRightClick()
    robot.forward()
    equipPic()
    robot.select(cableSlot)
    robot.swingDown()
    robot.forward()
    robot.turnRight()

    equipCrescentHammer()
    robot.select(cableSlot)
    shiftRightClick()
    robot.forward()

    equipPic()
    robot.select(cableSlot)
    robot.swingDown()

    robot.forward() -- above laser drill

    equipCrescentHammer()
    robot.select(cableSlot)
    shiftRightClick()
    robot.forward()
    robot.forward()

    -- start going down into other hole
    robot.down()
    robot.turnAround()
    shiftRightClick()
    robot.down()

    robot.select(labBlockSlot)
    robot.placeUp()
    robot.down()

    robot.select(stoneSlot)
    robot.placeUp()
    robot.turnRight()
    -- maybe do this? equipPic()

end




function replaceOneCableStraight()
    robot.back()
    robot.placeDown()
    robot.back() -- above laser drill
    robot.place(sides.down)

    robot.back()
    robot.placeDown()
    robot.back()
    robot.place(sides.down)
end

function replaceCables()
    -- emerge from hole ^
    equipPic()
    robot.select(stoneSlot)
    robot.swingUp()
    robot.up()

    robot.select(labBlockSlot)
    robot.swingUp()
    robot.up()

    robot.up()
    -- top of hole
    robot.select(cableSlot)


    replaceOneCableStraight()
    robot.turnRight()
    replaceOneCableStraight()


    -- start going down into other hole
    robot.down()
    robot.down()

    robot.select(labBlockSlot)
    robot.placeUp()
    robot.down()

    robot.select(stoneSlot)
    robot.placeUp()
    robot.turnLeft()
    -- maybe do this? equipPic()
end


-- maxAttempts should in theory map to seconds
function sendUntilHeard(sendMsg, expectedConfirm, maxAttempts)
    if maxAttempts == nil then maxAttempts == 11 end
    attemptCounter = 0
    while attemptCounter < maxAttempts do
        modem.send(serverAddress, port, sendMsg)
        local _, _, from, port, _, message = event.pull(1, "modem_message")
        if (from == serverAddress and message == expectedConfirm) then
            return true
        end
        attemptCounter = attemptCounter + 1
    end
    return false
end
        



while true do
    local _, _, from, port, _, message = event.pull(2, "modem_message")

    for i, item in pairs(listenList) do
        if item.fromAddress != serverAddress then continue end

    if (from == serverAddress and message == "ping") then
        modem.send(serverAddress, port, "pong")
    else if (from == serverAddress and message == "seal_off") then
        --todo sendWithConfirm("sealing_off")
        modem.send(serverAddress, port, "sealing_off")
        doSealOff()
        modem.send(serverAddress, port, "sealed_off")
    else if (from = serverAddress and message == "other thingy")
        -- do thing
    end
end

-- replaceCables()

-- doSealOff()




ListenList = {}
ll.fromAddress
ll.message
ll.action
-- for looop through each





function ListenList:new(address, miningState, picDurability)
    local t = setmetatable({}, { __index = NodeBot})
    t.address = address or "unknown"
    t.miningState = miningState or "new" -- new, active, sealing_off, sealed, renabling, error
    t.connected = ping(t.address, 2)
    t.picDurability = picDurability or 69420  
    return t
end