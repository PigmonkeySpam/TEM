
-- when something happens
-- I might make a touch screen user interface or redstone might be more sensible
local component = require("component")
local event = require("event")
local modem = component.modem

local port = 2319
modem.open(port)
print("Port " .. port .. " is open: "..tostring(modem.isOpen(port)))


local function ping(address, timeout)
    -- todo checkArg()
    modem.send(address, port, "ping")
    local _, _, from, port, _, message = event.pull(2, "modem_message")
    return (from == address and message == "pong") 
end


NodeBot = {}
function NodeBot:new(address, miningState, picDurability)
    local t = setmetatable({}, { __index = NodeBot})
    t.address = address or "unknown"
    t.miningState = miningState or "new" -- new, active, sealing_off, sealed, restarting, error
    t.picDurability = picDurability or 69420
    assert(ping(t.address, 2), ("Unable to connect to "..address))
    
    return t
end
function NodeBot:newFromSerialized(t)
    return NodeBot:new(t.address, t.miningState, t.picDurability)
end


MiningNode = {}
function MiningNode:new(id, miningState, nodeBots)
    local t = setmetatable({}, { __index = MiningNode})
    t.id = id
    t.miningState = (miningState or "new") -- new, active, sealing_off, sealed, restarting, error
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
