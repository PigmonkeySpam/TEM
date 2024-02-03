print("Client B")

local component = require("component")
local event = require("event")
local modem = component.modem

modem.open(123)


print("Test: two pull events with nothing in between")
modem.broadcast(123, "ping")
while true do
    local _, _, from, port, _, message = event.pull(2, "modem_message")
    if (message == "ping") then
        modem.send(from, 123, "pong")
    end
end
