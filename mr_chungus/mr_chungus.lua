local component = require("component")
local serialization = require("serialization")
local sides = require("sides")
event = require("event")
local rs_interface = component.block_refinedstorage_interface
local modem = component.modem
local gpu = component.gpu


modem.open(444) 

colours = {
    red = 0xFF0000,
    orange = 0xFF9135,
    yellowIsh = 0xFFAA33,
    yellow = 0xFFFB00,
    green = 0x00FF00,
    blueBright = 0x7FFFEF,
    blueCyan = 0x7FFFEF,
     
}

function colourPrint(msg, colour)
    gpu.setForeground(colour)
    print(msg)
end

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
function printGrey(msg)
    gpu.setForeground(0xAAAAAA)
    print(msg)
end
function printBlue(msg)
    gpu.setForeground(0x00AAFF)
    print(msg)
end
function printYellow(msg)
    gpu.setForeground(0xFFAA33)
    print(msg)
end

managedMaterials = {
    {name="minecraft:log"},
    {name="minecraft:clay_ball"},
    {name="minecraft:coal"},
    {name="chisel:marble2", damage=7},
    {name="minecraft:stone", damage=6},
    {name="minecraft:redstone"},
    {name="minecraft:log", damage=1},
    {name="minecraft:ender_pearl"},
    {name="minecraft:string"},
    {name="minecraft:iron_ingot"},
    {name="minecraft:stone", damage=5},
    {name="projectred-core:resource_item", damage=105},
    {name="minecraft:bone"},
    {name="minecraft:stone", damage=1},
    {name="projectred-exploration:ore", damage=3},
    {name="thermalfoundation:material", damage=128}, -- copper_ingot
    {name="minecraft:flint"},
    {name="minecraft:wheat"},
    {name="minecraft:wheat_seeds"},
    {name="minecraft:arrow"},
    {name="minecraft:log", damage=2},
    {name="chisel:limestone2", damage=7},
    {name="galacticraftcore:basic_block_core", damage=6}, -- tin ore
    {name="mekanism:oreblock", damage=1}, -- copper ore
    {name="minecraft:iron_ore"},
    {name="minecraft:gold_ingot"},
    {name="minecraft:potato"},
    {name="mekanism:oreblock", damage=2}, -- tin ore
    {name="minecraft:sapling", damage=1}, -- spruce
    {name="minecraft:snowball"},
    {name="minecraft:log2"},
    {name="minecraft:rotten_flesh"},
    {name="minecraft:stone", damage=2},
    {name="galacticraftcore:basic_block_core", damage=5}, -- copper ore
    {name="dungeontactics:trickortreat_bag"},
    {name="thermalfoundation:material", damage=129}, -- tin_ingot
    {name="mekanism:oreblock", damage=0}, -- osmium ore
    {name="galacticraftcore:basic_block_core", damage=7}, -- aluminium ore
    {name="minecraft:gravel"},
    {name="minecraft:brown_mushroom"},
    {name="minecraft:quartz"},
    {name="bhc:red_heart"},
    {name="minecraft:sand"},
    {name="thermalfoundation:ore", damage=0}, -- copper ore
    {name="minecraft:stick"},
    {name="quark:black_ash"},
    {name="minecraft:magma"},
    {name="minecraft:gunpowder"},
    {name="actuallyadditions:block_misc", damage=3}, -- black quartz ore
    {name="minecraft:beetroot_seeds"},
    {name="projectred-exploration:ore", damage=4}, -- tin ore
    {name="minecraft:reeds"},
    {name="minecraft:beetroot"},
    {name="minecraft:sapling", damage=0}, -- oak
    {name="quark:marble", damage=0}, 
    {name="chisel:basalt2", damage=7}, 
    {name="thermalfoundation:ore", damage=1}, -- tin ore
    {name="minecraft:stonebrick", damage=1}, -- mossy
    {name="minecraft:stonebrick", damage=0}, -- normal
    {name="minecraft:netherrack"}, 
    {name="minecraft:spider_eye"}, 
    {name="minecraft:sapling", damage=2}, -- birch
    {name="thermalfoundation:material", damage=772}, -- niter
    {name="enderio:item_material", damage=20}, -- grains of infinity
    {name="immersiveengineering:ore", damage=0}, -- copper ore
    {name="immersiveengineering:ore", damage=3}, -- silver ore
    {name="immersiveengineering:ore", damage=2}, -- lead ore
    {name="immersiveengineering:ore", damage=1}, -- bauxite ore
    {name="libvulpes:ore0", damage=5}, -- tin ore
    {name="libvulpes:ore0", damage=4}, -- copper ore
    {name="libvulpes:ore0", damage=8}, -- rutile ore
    {name="libvulpes:ore0", damage=0}, -- dilithium ore
    {name="libvulpes:ore0", damage=9}, -- aluminium ore
    {name="minecraft:dye", damage=4}, -- lapis
    {name="thermalfoundation:material", damage=2053}, -- basalz powder
    {name="thermalfoundation:material", damage=2050}, -- blitz rod
    {name="thermalfoundation:material", damage=2048}, -- blizz rod
    {name="minecraft:cactus"},
    {name="industrialforegoing:pink_slime"},
    {name="minecraft:log2", damage=1}, -- dark oak
    {name="minecraft:concrete", damage=0}, -- white concrete
    -- {name="minecraft:concrete", damage=1}, -- ??? concrete
    -- {name="minecraft:concrete", damage=2}, -- ??? concrete
    -- {name="minecraft:concrete", damage=3}, -- ??? concrete
    -- {name="minecraft:concrete", damage=4}, -- ??? concrete
    -- {name="minecraft:concrete", damage=5}, -- ??? concrete
    -- {name="minecraft:concrete", damage=6}, -- ??? concrete
    {name="minecraft:concrete", damage=7}, -- gray concrete
    -- {name="minecraft:concrete", damage=8}, -- ??? concrete
    -- {name="minecraft:concrete", damage=9}, -- ??? concrete
    -- {name="minecraft:concrete", damage=10}, -- ??? concrete
    -- {name="minecraft:concrete", damage=11}, -- ??? concrete
    -- {name="minecraft:concrete", damage=12}, -- ??? concrete
    -- {name="minecraft:concrete", damage=13}, -- ??? concrete
    -- {name="minecraft:concrete", damage=14}, -- ??? concrete
    -- {name="minecraft:concrete", damage=15}, -- ??? concrete
    {name="thermalfoundation:ore", damage=3}, -- lead ore
    {name="industrialforegoing:tinydryrubber"},
    {name="thermalfoundation:ore", damage=2}, -- silver ore
    {name="minecraft:sandstone", damage=0},
    {name="thermalfoundation:material", damage=770}, -- pulverized obsidian
    {name="galacticraftcore:basic_item", damage=2}, -- raw silicon
    {name="minecraft:redstone_ore"},
    {name="minecraft:glass"},
    {name="rftools:dimensional_shard_ore"},
    {name="darkutils:material", damage=0}, -- wither dust
    {name="iceandfire:witherbone"},
    {name="thermalfoundation:material", damage=132}, -- aluminium_ingot
    {name="minecraft:sapling", damage=4}, -- acacia
    {name="projectred-exploration:stone", damage=0}, -- marble
    {name="minecraft:web"},
    {name="minecraft:fence"},
    {name="minecraft:coal_ore"},
    {name="minecraft:red_mushroom"},
    {name="minecraft:clay"},
    {name="iceandfire:chain_link"},
    {name="enderio:block_enderman_skull"},
    {name="minecraft:blaze_rod"},
    {name="minecraft:skull", damage=4} -- creeper head
}

        
function extractItemsFromProduction(item, extractAmount, loopMax) 
    if loopMax == nil then loopMax = 50 end
    extractAmount = extractAmount + 500

    local totalExtracted = 0
    for i = 1, loopMax do
        amountExtracted = rs_interface.extractItem(item, 64, 1)
        if amountExtracted == nil then 
            colourPrint("Extract error for "..item.name.." | "..totalExtracted.." of "..extractAmount.." items extracted")
            return 
        end

        totalExtracted = totalExtracted + amountExtracted
        if totalExtracted > extractAmount then
            break
        end
    end
    printInfo(item.name.." "..totalExtracted.." extracted")
end


function requestFromMrChungus(item, extractAmount)
    msgToSend = serialization.serialize({item, extractAmount})
    modem.broadcast(444, msgToSend)
    -- modem.send("390023e6-d571-46e1-a28c-19277fac2ab0", 444, msgToSend)
end


function equilibrium(topUpLevel, overflowLevel)  
    for i, item in pairs(managedMaterials) do
        printInfo("")
        itemInfo = rs_interface.getItem(item)
        if itemInfo == nil then 
            itemInfo = {size=0, label=item.name}
        end

        if itemInfo.size > overflowLevel then
            printYellow(itemInfo.label..": "..itemInfo.size.." --> overflow")
            local overflowAmount = itemInfo.size - overflowLevel
            extractItemsFromProduction(item, overflowAmount)

        elseif itemInfo.size < topUpLevel then
            printBlue(itemInfo.label..": "..itemInfo.size.." --> top up")
            local topUpAmount = topUpLevel - itemInfo.size
            requestFromMrChungus(item, topUpAmount)
        else
            printGrey(itemInfo.label..": "..itemInfo.size.." --> satisfactory")
        end
    end
end




while true do
    equilibrium(10000, 11000)
end
