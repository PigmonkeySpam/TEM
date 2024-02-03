local component = require("component")
local serialization = require("serialization")
local sides = require("sides")
local rs_interface = component.block_refinedstorage_interface
local gpu = component.gpu


function printError(msg)
    gpu.setForeground(0xFF0000)
    print(msg)
end
function printSuccess(msg)
    gpu.setForeground(0x00FF00)
    print(msg)
end
function printInfo(msg)
    gpu.setForeground(0xFFFFFF)
    print(msg)
end



-- component.setPrimary("block_refinedstorage_interface", "ca2ac") component.block_refinedstorage_interface.extractItem({name="minecraft:potato"}, 64, 1) component.setPrimary("block_refinedstorage_interface", "9bc5") component.block_refinedstorage_interface.extractItem({name="minecraft:potato"}, 32, 1)

-- component.setPrimary("block_refinedstorage_interface", "ca2ac")
-- component.block_refinedstorage_interface.extractItem({name="minecraft:potato"}, 64, 1)
-- component.setPrimary("block_refinedstorage_interface", "9bc5")
-- component.block_refinedstorage_interface.extractItem({name="minecraft:potato"}, 32, 1)
-- component.getPrimary("block_refinedstorage_interface")




managedMaterials = {
    {name="minecraft:log"},
    -- {name="minecraft:clay_ball"},
    -- {name="minecraft:coal"},
    -- {name="chisel:marble2", damage=7},
    -- {name="minecraft:stone", damage=6},
    -- {name="minecraft:redstone"},
    -- {name="minecraft:log", damage=1},
    -- {name="minecraft:ender_pearl"},
    -- {name="minecraft:string"},
    -- {name="minecraft:iron_ingot"},
    -- {name="minecraft:stone", damage=5},
    -- {name="projectred-core:resource_item", damage=105},
    -- {name="minecraft:bone"},
    -- {name="minecraft:stone", damage=1},
    -- {name="projectred-exploration:ore", damage=3},
    -- {name="thermalfoundation:material", damage=128}, -- copper_ingot
    -- {name="minecraft:flint"},
    -- {name="minecraft:wheat"},
    -- {name="minecraft:wheat_seeds"},
    -- {name="minecraft:arrow"},
    -- {name="minecraft:log", damage=2},
    -- {name="chisel:limestone2", damage=7},
    -- {name="galacticraftcore:basic_block_core", damage=6}, -- tin ore
    -- {name="mekanism:oreblock", damage=1}, -- copper ore
    -- {name="minecraft:iron_ore"},
    -- {name="minecraft:gold_ingot"},
    -- {name="galacticraftcore:basic_block_core", damage=6}, -- copper ore
    {name="minecraft:potato"}
    -- {name="mekanism:oreblock", damage=2}, -- tin ore
    -- {name="minecraft:sapling", damage=1}, -- spruce
    -- {name="minecraft:snowball"},
    -- {name="minecraft:log2"},
    -- {name="minecraft:rotten_flesh"},
    -- {name="minecraft:stone", damage=2}
}

production_address = "~~~"
mr_chungus_address = "???"
current_interface_address = "###"


function setInterface(address)
    printError("curr="..current_interface_address.." setTo="..address)
    if current_interface_address == address then
        return true
    end
    current_interface_address = address
    component.setPrimary("block_refinedstorage_interface", address)
    os.sleep(3)
    return true
end


function calibrateAddresses(interfaceAddresses) 
    setInterface(interfaceAddresses[1])
    if rs_interface.getFluid({name="water"}) == nil then
        mr_chungus_address = interfaceAddresses[1]
        production_address = interfaceAddresses[2]
    else
        mr_chungus_address = interfaceAddresses[2]
        production_address = interfaceAddresses[1]
    end
    print("mr_chungus_address="..mr_chungus_address)
    print("production_address="..production_address)
end




        
function extractItemsFrom(address, item, extractAmount, loopMax) 
    if loopMax == nil then loopMax = 22 end
    setInterface(address)

    print(component.getPrimary("block_refinedstorage_interface").address)
    -- print(component.getPrimary("block_refinedstorage_interface").address)

    local totalExtracted = 0
    for i = 1, loopMax do
        amountExtracted = rs_interface.extractItem(item, 64, 1)
        if amountExtracted == nil then 
            printError("Extract error for "..item.name.." | "..totalExtracted.." of "..extractAmount.." items extracted")
            break 
        end

        totalExtracted = totalExtracted + amountExtracted
        if totalExtracted > extractAmount then
            printSuccess("Success: "..totalExtracted.. " "..item.name.." extracted")
            break
        end
    end
end


function equilibrium(topUpLevel, overflowLevel)  
    for i, item in pairs(managedMaterials) do
        setInterface(production_address)
        printInfo("Attempt: "..serialization.serialize(item))
        itemInfo = rs_interface.getItem(item)
        if itemInfo == nil then 
            itemInfo = {size=0}
        end
        print("itemInfo.size="..tostring(itemInfo.size))
        if itemInfo.size > overflowLevel then
            print("overflow: "..tostring(itemInfo.size - overflowLevel))
            local overflowAmount = itemInfo.size - overflowLevel
            extractItemsFrom(production_address, item, overflowAmount)

        elseif itemInfo.size < topUpLevel then
            printSuccess("top up: "..tostring(topUpLevel - itemInfo.size))
            local topUpAmount = topUpLevel - itemInfo.size
            extractItemsFrom(mr_chungus_address, item, topUpAmount)
        end
    end
end



calibrateAddresses({
    "9bc5",
    "ca2ac"
})
while true do
    equilibrium(10000, 11000)
end
