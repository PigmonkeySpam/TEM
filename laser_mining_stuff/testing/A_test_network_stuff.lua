print("Client A")

local component = require("component")
local event = require("event")
local modem = component.modem

modem.open(123)


print("Test: two pull events with nothing in between")
modem.broadcast(123, "ping")
local _, _, from, port, _, message = event.pull(2, "modem_message")
local _, _, from2, port2, _, message2 = event.pull(2, "modem_message")
print("Messages: "..message.." | "..message2)
assert(message == message2, "messages don't match")
assert((from ~= from2), "From addresses shouldn't be the same")


-- print("Test: two pull events with a big counting for loop between")
-- -- Will this queue up the second event
-- local _, _, from, port, _, message = event.pull(2, "modem_message")
-- for i = 1, 999 do
--     print(tostring(i))
-- end
-- local _, _, from2, port2, _, message2 = event.pull(2, "modem_message")
-- print("Messages: "..message.." | "..message2)
-- assert(message == message2)
-- assert(from ~= from2)


print("Test: two pull events with as os.sleep(4) between (timeout on each event pull is 2 sec)")
-- Will this queue up the second event
modem.broadcast(123, "ping")
local _, _, from, port, _, message = event.pull(2, "modem_message")
os.sleep(4)
local _, _, from2, port2, _, message2 = event.pull(2, "modem_message")
print("Messages: "..message.." | "..message2)
assert(message == message2)
assert(from ~= from2)