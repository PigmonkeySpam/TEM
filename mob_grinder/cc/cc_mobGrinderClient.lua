local baseUrl = "https://jkeys2-bs-dev.chi.ac.uk/tem/mob_grinder_control/get_mob_on_state.php?mobName="
local mobFile = fs.open("mobList.txt", "r")
local mobList = textutils.unserialize(mobFile.readAll())
mobFile.close()

print("Mob Grinder Client - Version 1.1\n==============================\n")
while true do
    os.startTimer(30)
    print("Waiting...")
    local event = os.pullEvent()
    if (event == "redstone" or string.sub(event, 1,5) == "timer") then
        print("Trigged by: "..event)
        local web = nil
        for i, mob in pairs(mobList) do
            web = http.get(baseUrl..mob.name)
            local state = web.readAll()
            if (state == "1") then
                redstone.setOutput(mob.side, true)
                print(mob.name..": on")
            elseif (state == "0") then
                redstone.setOutput(mob.side, false)
                print(mob.name..": off")
            else
                print(mob.name.." - error:")
                print(state)
            end
            os.sleep(0.2)
        end
        web.close()
        print("")
    end
end
