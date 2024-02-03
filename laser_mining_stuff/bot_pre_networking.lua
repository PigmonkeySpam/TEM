local component = require("component")
local invController = component.inventory_controller

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



replaceCables()

-- doSealOff()
