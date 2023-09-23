function getTotalCyclesCountFromFile()
    if not fs.exists("total_cycles.txt") then
        print("No file found, starting from 0")
        sleep(2)
        return 0
    end
    local totalCyclesFile = fs.open("total_cycles.txt", "r")
    local totalCycles = tonumber(totalCyclesFile.readLine())
    totalCyclesFile.close()
    return totalCycles
end


function setTotalCyclesCountFile(newCount)
    local totalCyclesFile = fs.open("total_cycles.txt", "w")
    totalCyclesFile.write(tostring(newCount))
    totalCyclesFile.close()
end


local totalCycles = getTotalCyclesCountFromFile()
while true do
    redstone.setOutput("left", true)
    totalCycles = totalCycles + 1
    setTotalCyclesCountFile(totalCycles)
    sleep(0.8)
    redstone.setOutput("left", false)
    
    for i = 30, 0, -1 do
        term.clear()
        print("Total cycles: " .. totalCycles)
        print("Waiting: " .. i .. " seconds remaining")
        sleep(1)
    end
end