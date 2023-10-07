
-- when something happens
-- I might make a touch screen user interface or redstone might be more sensible
local component = require("component")
local event = require("event")
local modem = component.modem

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
function MiningNode:new(id, miningState, nodeBots)
    local t = setmetatable({}, { __index = MiningNode})
    t.id = id
    t.miningState = (miningState or "new") -- new, active, sealing_off, sealed, renabling, error
    t.nodeBots = (nodeBots or {})
    return t
end
function MiningNode:newFromSerialized(t)
    newBots = {}
    for i, bot in pairs(t.nodeBots) do
        table.insert(newBots, NodeBot:newFromSerialized(bot))
    end
    return MiningNode:new(t.id, t.miningState, newBots)
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




-- continuous checking for click


-- seal off button

function MiningNode:sealOff()
    -- todo: improve errors to work with the UI
    assert(botsAreConnected(), "Bots must be connected to seal off this node!")
    --! set that laser to "sealing off"
    self.miningState = "sealing_off"
    -- todo --->>
            -- redstone trigger the laser retraction
            --? will probably end up doing this with another computer to control the redstone ...so send a msg to that

    -- network msg to robots
    for i, bot in pairs(self.nodeBots) do
        if not bot:sendWithConfirm("seal_off", "sealing_off") then 
            error("Bot "..strsub(bot.address, 1, 6).."... did not reply to 'seal_off'")
        end
    end



-- redstone trigger the frame motor
-- msg back to main computer / http server
-- wait a bunch of time
-- should get a network message from the robots when they finish
-- kinda wait more time
-- assume sealed off
-- set as sealed


-- enable button for turning the laser back on
-- try do a cool loading thing...


-- restart clicked
-- set as restarting
-- redstone trigger