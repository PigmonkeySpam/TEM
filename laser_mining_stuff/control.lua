


-- when something happens
-- I might make a touch screen user interface or redstone might be more sensible
local component = require("component")
local event = require("event")
local modem = component.modem

local port = 2319
modem.open(port)
print("Port " .. port .. " is open: " modem.isOpen(port))




NodeBot = {}
function NodeBot:new(address, state)
    local t = setmetatable({}, { __index = NodeBot})

    t.address = id
    t.state = "active" -- active, sealing_off, sealed, reconnecting, error

    return t
end


MiningNode = {}
function MiningNode:new(id, state, nodeBots)
    local t = setmetatable({}, { __index = MiningNode})

    t.id = id
    t.state = "active" -- active, sealing_off, sealed, reconnecting, error
    t.nodeBots = nodeBots

    return t
end


function ProgressBar:getProgressAsPixels()
    local progressAsPixels = self.length * (self.progress / 100)
    return math.ceil(progressAsPixels)
end

