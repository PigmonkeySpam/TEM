local event = require("event")
local component = require("component")
local gpu = component.gpu
local w, h = gpu.getResolution()

local colourBlack = 0x000000
local colourGrey = 0xD2D2D2
local colourWhite = 0xFFFFFF
local colourGreen = 0x00FF00
local colourLightBlue = 0x00FFFF
local colourBlue = 0x0000FF
local colourRed = 0xFF0000



-- RectanglePoints = {}
-- function RectanglePoints:new(posX, posY, width, height)
--     local t = setmetatable({}, { __index = RectanglePoints})

--     t.posX = (posX or 2)
--     t.posY = (posY or 2)
--     t.width = (width or 10)
--     t.height = (height or 10)

--     return t
-- end

Box = {}
function Box:new(name, posX, posY, width, height, colour, borderColour)
    local t = setmetatable({}, { __index = Box})

    t.name = name
    t.posX = (posX or 2)
    t.posY = (posY or 2)
    t.width = (width or 10)
    t.height = (height or 10)
    t.colour = (colour or 0x00FF00) -- default green
    t.borderColour = (borderColour or 0xD2D2D2) -- default grey
    t.labels = {}

    return t
end

function Box:toString()
    print("posX: "..self.posX)
end

function Box:draw(boxColour, borderColour)
    if boxColour == nil then boxColour = self.colour end
    -- print("1) borderColour: "..(borderColour or "nil")..", self.borderColour: "..self.borderColour)
    if borderColour == nil then borderColour = self.borderColour end
    -- print("2) borderColour: "..borderColour..", self.borderColour: "..self.borderColour)


    -- Main box part
    gpu.setBackground(boxColour)
    gpu.fill(self.posX, self.posY, self.width, self.height, " ")

    -- Border
    gpu.setForeground(borderColour)
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
    
    -- Labels
    for k, label in pairs(self.labels) do
        label:draw()
    end
end

function Box:addExistingLabel(label, alignVertical, alignHorizontal) 
    label:setupParent(self, alignVertical, alignHorizontal)
    table.insert(self.labels, label)
end

function Box:addBasicLabel(text)
    label = Label:new("basic", text)
    label:setupParent(self, "T", "L")
    table.insert(self.labels, label)
end

Label = {}
function Label:new(name, text, textColour, posX, posY)
    local t = setmetatable({}, { __index = Label})

    t.name = name
    t.text = (text or "I'm so empty")
    t.textColour = (textColour or 0xFFFFFF)
    t.backgroundColour = (backgroundColour or 0x000000)
    t.posX = (posX or 1)
    t.posY = (posY or 1)

    return t
end

function Label:setupParent(parent, alignVertical, alignHorizontal) 
    self.parent = (parent or false)
    self.alignVertical = (alignVertical or false)
    self.alignHorizontal = (alignHorizontal or false)
end


function getCentre(parentWidthOrHeight, childWidthOrHeight)
    parentCentre = parentWidthOrHeight / 2
end

function Label:setupTextWrapping()
    width = self.parent.width - 4
    textLines = {}
    line = ""
    for word in self.text:gmatch("%S+") do
        if not (line == "") then 
            line = line.." " 
        end
        testLine = line..word
        if string.len(testLine) == width then
            table.insert(textLines, testLine)
            line = ""
        elseif string.len(testLine) > width then
            table.insert(textLines, line)
            line = ""..word
        else
            line = line..word
        end
    end
    table.insert(textLines, line)
    self.textLines = textLines
end

function Label:draw()
    gpu.setForeground(self.textColour)

    for k, textLine in pairs(self.textLines) do
        parent = self.parent
        -- find middle x
        parentCentre = parent.width / 2
        textWidth = string.len(textLine)
        self.posX = (parent.posX + parentCentre) - (textWidth / 2) 

        -- find middle y
        parentCentre = parent.height / 2
        textHeight = #self.textLines
        self.posY = parent.posY + parentCentre + k - (textHeight / 2)

        gpu.set(self.posX, self.posY-1, textLine)
    end
end


function sayHiTo(name)
    print("Hello to "..name.."!")
end

Button = {}
function Button:new(func, funcInput, box, clickSeconds, clickedColour, clickedBorderColour, clickedLabelColour)
    local t = setmetatable({}, { __index = Button})
    
    t.func = func
    t.params = funcInput
    t.box = box
    t.clickSeconds = clickSeconds
    t.clickedColour = clickedColour
    t.clickedBorderColour = clickedBorderColour
    
    return t
end

function Button:clicked()
    -- draw clicked colour button
    self.box:draw(self.clickedColour, self.clickedBorderColour)
    self.func(self.params)
    os.sleep(self.clickSeconds)
    -- and back to normal
    self.box:draw()
end


-- Border = {}
-- function Border:new(name, posX, posY, width, height, colour, borderColour)
--     local t = setmetatable({}, { __index = Border})

--     t.posX = (posX or 2)
--     t.posY = (posY or 2)
--     t.width = (width or 10)
--     t.height = (height or 10)
--     t.colour = (colour or 0x00FF00) -- default green
--     t.borderColour = (borderColour or 0xD2D2D2) -- default grey

--     return t
-- end

local box = Box:new("box", 30,2, 25,15, colourGreen, colourGrey, testThing)
local myLabel = Label:new("new", "Here is a stupid long sentence with which I will demo text wrapping flawlessly on the first try! ...yeah no")
box:addExistingLabel(myLabel, "t", "l")
myLabel:setupTextWrapping()
box:toString()
box:draw()

local myTestBtn = Button:new(sayHiTo, "Joe", box, 0.5, colourRed, colourBlue)


local live = 15
while live > 0 do
    local _,_,x,y = event.pull(1,"touch")
    if x and y then
        -- myTestBtn.func(myTestBtn.params)
        myTestBtn:clicked()
        -- print(myTestBtn.box.colour)
    end
    live = live -1
end
