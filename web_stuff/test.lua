-- https://github.com/kikito/inspect.lua/blob/master/inspect.lua
local internet = require("internet")
    
local url = "https://jkeys2-bs-dev.chi.ac.uk/tem/mob_grinder_control/set_mob_state.php"
-- local params = "?mobName=spider"
-- local handle = internet.request(url..params)
local handle = internet.request(url, {mobName="spider", secret="a"})
local result = ""
for chunk in handle do result = result..chunk end
-- Print the body of the HTTP response
print(result)
    
-- Grab the metatable for the handle. This contains the
-- internal HTTPRequest object.
local mt = getmetatable(handle)
    
-- The response method grabs the information for
-- the HTTP response code, the response message, and the
-- response headers.
local code, message, headers = mt.__index.response()
print("code = "..tostring(code))
print("message = "..tostring(message))
