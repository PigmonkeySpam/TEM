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
-- todo: checkArg() everything


ScreenContainer = {}
function ScreenContainer:new(name, backgroundColour)
    checkArg(1, name, "string")
    checkArg(2, backgroundColour, "string", "nil")
    local t = setmetatable({}, { __index = ScreenContainer})

    t.name = name
    t.type = "screen_container"
    t.width, t.height = gpu.getResolution()
    t.backgroundColour = (backgroundColour or 0x000000) -- default black
    t.components = {}

    return t
end

function ScreenContainer:isClickWithinXY(x,y, item)
    if (item.posX <= x and x < item.posX + item.width) then
        if item.posY <= y and y < item.posY + item.height then
            return true
        end
    end
    return false
end

function ScreenContainer:processClick(x, y)
    for id, item in pairs(self.components) do
        if item.type == "btn" then
            if self:isClickWithinXY(x,y, item.box) then
                item:clicked()
                return id
            end
        end
    end
end


Box = {}
function Box:new(name, posX, posY, width, height, colour, borderColour)
    checkArg(6, colour, "number")
    local t = setmetatable({}, { __index = Box})

    t.name = name
    t.type = "box"
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
    if borderColour == nil then borderColour = self.borderColour end

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
    t.type = "label"
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
    self:setupTextWrapping()
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
    print(textLines)
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
function Button:new(name, func, params, box, clickSeconds, clickedColour, clickedBorderColour, clickedLabelColour)
    local t = setmetatable({}, { __index = Button})
    
    t.name = name
    t.type = "btn"
    t.func = func
    t.params = params
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


-- Todo: separate border object that can be bound to other objects?


local screen = ScreenContainer:new("screen")
local box = Box:new("box", 30,2, 25,15, colourGreen, colourGrey, testThing)
local myLabel = Label:new("new", "Here is a stupid long sentence with which I will demo text wrapping flawlessly on the first try! ...yeah no")
box:addExistingLabel(myLabel, "t", "l")
myLabel:setupTextWrapping()
box:toString()
box:draw()

local sealOffBox = Box:new("sealOffBox", 55, 20, 17,5, colourBlue, colourWhite)
local sealOffLbl = Label:new("Lable", "Seal off")
sealOffBox:addExistingLabel(sealOffLbl, "T", "L")
sealOffBox:addBasicLabel("Seal off")
local sealOffBtn = Button:new("sealOffBtn", sayHiTo, "sealOff", sealOffBox, 0.3, colourGrey, colourBlack)
local myTestBtn = Button:new("name", sayHiTo, "Joe", box, 0.5, colourRed, colourBlue)
sealOffBox:draw()
table.insert(screen.components, myTestBtn)
table.insert(screen.components, sealOffBtn)


local live = 15
while live > 0 do
    local _,_,x,y = event.pull(1,"touch")
    if x and y then
        screen:processClick(x, y)
    end
    live = live -1
end
