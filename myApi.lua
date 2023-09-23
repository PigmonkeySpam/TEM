local component = require("component")
local gpu = component.gpu
local w, h = gpu.getResolution()

local colourBlack = 0x000000
local colourGrey = 0xD2D2D2
local colourWhite = 0xFFFFFF
local colourGreen = 0x00FF00



RectanglePoints = {}
function RectanglePoints:new(posX, posY, width, height)
    local t = setmetatable({}, { __index = RectanglePoints})

    t.posX = (posX or 2)
    t.posY = (posY or 2)
    t.width = (width or 10)
    t.height = (height or 10)

    return t
end

Box = {}
function Box:new(name, posX, posY, width, height, colour, borderColour)
    local t = setmetatable({}, { __index = Box})

    t.posX = (posX or 2)
    t.posY = (posY or 2)
    t.width = (width or 10)
    t.height = (height or 10)
    t.colour = (colour or 0x00FF00) -- default green
    t.borderColour = (borderColour or 0xD2D2D2) -- default grey

    return t
end

function Box:toString()
    print("posX: "..self.posX)
end

function Box:draw()
    -- Main box part
    gpu.setBackground(self.colour)
    gpu.fill(self.posX, self.posY, self.width, self.height, " ")
    
    -- Border
    gpu.setForeground(self.borderColour)
    --corners
    gpu.set(self.posX, self.posY, "▛")
    gpu.set(self.posX + self.width-1, self.posY, "▜")
    gpu.set(self.posX, self.posY + self.height-1, "▙")
    gpu.set(self.posX + self.width-1, self.posY + self.height-1, "▟")

    --top
    gpu.fill(self.posX+1, self.posY, self.width-2, 1, "🮂")
    --right
    gpu.fill(self.posX+self.width-1, self.posY+1, 1, self.height-2, "▐")
    --bottom
    gpu.fill(self.posX+1, self.posY+self.height-1, self.width-2, 1, "▂")
    --left
    gpu.fill(self.posX, self.posY+1, 1, self.height-2, "▌")

end



local box = Box:new("box", 30,2, 25,15, colourGreen, colourGrey)
box:toString()
box:draw()
