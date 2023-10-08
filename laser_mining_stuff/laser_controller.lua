
-- when something happens
-- I might make a touch screen user interface or redstone might be more sensible
local component = require("component")
local event = require("event")
local modem = component.modem
local redstone = component.redstone

local port = 2319
modem.open(port)
print("Port " .. port .. " is open: "..tostring(modem.isOpen(port)))


function ping(address, timeout)
    -- todo checkArg()
    modem.send(address, port, "ping")
    local _, _, from, port, _, message = event.pull(2, "modem_message")
    return (from == address and message == "pong") 
end


NodeBot = {}
function NodeBot:new(address, miningState, picDurability)
    local t = setmetatable({}, { __index = NodeBot})
    t.address = address or "unknown"
    t.miningState = miningState or "new" -- new, active, sealing_off, sealed, renabling, error
    t.connected = ping(t.address, 2)
    t.picDurability = picDurability or 69420  
    return t
end
function NodeBot:newFromSerialized(t)
    return NodeBot:new(t.address, t.miningState, t.picDurability)
end

-- todo remove
function NodeBot:ping()
    return ping(self.address, 2)
end

function NodeBot:sendWithConfirm(send, expectedConfirm, timeout)
    modem.send(self.address, port, send)
    local _, _, from, port, _, message = event.pull((timeout or 2), "modem_message")
    return (from == self.address and message == expectedConfirm) 
end



MiningNode = {}
function MiningNode:new(id, miningState, nodeBots, redstoneSide)
    local t = setmetatable({}, { __index = MiningNode})
    t.id = id
    t.miningState = (miningState or "new") -- new, active, sealing_off, sealed, renabling, error
    t.nodeBots = (nodeBots or {})
    t.redstoneSide = redstoneSide
    return t
end
function MiningNode:newFromSerialized(t)
    newBots = {}
    for i, bot in pairs(t.nodeBots) do
        table.insert(newBots, NodeBot:newFromSerialized(bot))
    end
    return MiningNode:new(t.id, t.miningState, newBots, t.redstoneSide)
end

function MiningNode:someTestStuff()
    print(self.nodeBots[1].address .. "    aaa")
end

-- function MiningNode:addBots(address1, address2)
--     local addresses = {address1, address2}
--     local bots = {}
--     for i, address in pairs(addresses) do
--         local bot = NodeBot:new(address)


local miningNode = MiningNode:new(1)
miningNode.nodeBots = {NodeBot:new("cd839e36-745c-4bf7-95ea-c5a860afd1d5"), NodeBot:new("unknown")}

print(serialization.serialize({miningNode}, true))

local serializedMiningNode = serialization.serialize(miningNode)
local otherMiningNode = MiningNode:newFromSerialized(serialization.unserialize(serializedMiningNode))

otherMiningNode:someTestStuff()

-- setup stuff ^

function MiningNode:botsAreConnected()
    for i, bot in pairs(self.nodeBots) do
        if not bot:sendWithConfirm("ping", "pong") then
            return false
        end
    end
    return true
end

function MiningNode:frameMotor(action)
    local power = nil
    if      action == "up" then power = 3
    else if action == "down" then power = 4
    else if action == "off" then power = 0
    else error("action: '"..action.."' not recognised") end
    redstone.setOutput(self.redstoneSide, power)
end


-- todo: create bot side response
function MiningNode:getConfirmationOfSealedFromNodeBots()
    local attempts = 0
    local success = false
    while (not success) do
        local _, _, from, port, _, message = event.pull(1, "modem_message")
        for i, bot in pairs(self.nodeBots) do
            if (from == bot.address) and (message == "sealed") then
                bot.miningState = "sealed"
                bot:sendWithConfirm("coolio", "gott'ya fam")
            end
        end
        success = (self.nodeBots[1].miningState == "sealed") and (self.nodeBots[2].miningState == "sealed")
        
        attempts = attempts +1
        if (attempts < maxAttempts) then 
            self:frameMotor("off")
            error("Attempts excceded waiting for node bots to confirm 'sealed'")
        end
    end
end



-- continuous checking for click


-- seal off button

function MiningNode:sealOff()
    -- todo: improve errors to work with the UI
    assert(botsAreConnected(), "Bots must be connected to seal off this node!")
    
    self.miningState = "sealing_off"
    -- network msg robots to seal off
    for i, bot in pairs(self.nodeBots) do
        ---- will retract lasers and disconnect cables
        if not bot:sendWithConfirm("seal_off", "sealing_off") then 
            error("Bot "..strsub(bot.address, 1, 6).."... did not reply to 'seal_off'")
        end
    end


    -- redstone trigger the frame motor: down
    self:frameMotor("down")
    os.sleep(5) -- todo: change to check current time
    -- should get a network message from the robots when they finish
    self:getConfirmationOfSealedFromNodeBots()

    -- kinda wait more time
    -- assume sealed off
    -- set as sealed
    self.miningState = "sealed"

end



-- //msg back to main computer / http server
-- wait a bunch of time


-- enable button for turning the laser back on
-- try do a cool loading thing...


-- restart clicked
-- set as restarting
-- redstone trigger