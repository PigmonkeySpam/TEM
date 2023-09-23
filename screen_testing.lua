local component = require("component")
local gpu = component.gpu
local w, h = gpu.getResolution()

local colourBlack = 0x000000
local colourGrey = 0xD2D2D2
local colourWhite = 0xFFFFFF
local colourGreen = 0x00FF00



ProgressBar = {}
function ProgressBar:new(gpu, progress, length, width, posX, posY, direction,
                         barColour, barBackgroundColour, backgroundColour)
    local t = setmetatable({}, { __index = ProgressBar})

    t.gpu = gpu
    t.progress = (progress or 0)
    t.length = (length or 10)
    t.width = (width or 2)
    t.posX = (posX or 2)
    t.posY = (posY or 2)
    t.direction = (direction or "right")
    t.barColour = (barColour or 0x00FF00) -- default green
    t.barBackgroundColour = (barBackgroundColour or 0xD2D2D2) -- default black
    t.backgroundColour = (backgroundColour or 0xD2D2D2) -- default grey

    return t
end


function ProgressBar:getProgressAsPixels()
    local progressAsPixels = self.length * (self.progress / 100)
    return math.ceil(progressAsPixels)
end


-- Currently only works with direction "right"
function ProgressBar:draw()
    -- draw progress section
    self.gpu.setBackground(self.barColour)
    self.gpu.fill(self.posX, self.posY, self:getProgressAsPixels(), self.width, " ")

    -- draw background section
    self.gpu.setBackground(self.barBackgroundColour)
    local backgroundStartX = self.posX + self:getProgressAsPixels() + 1
    self.gpu.fill(backgroundStartX, self.posY, (self.length - self:getProgressAsPixels()), self.width, " ")
end


function ProgressBar:updateProgress(newProgress)
    self.progress = newProgress
    self:draw()
end


local pb = ProgressBar:new(gpu, 0, 100)
pb:draw()
os.sleep(1)

for i = 1, 100, 5 do
    os.sleep(1)
    pb:updateProgress(i)
    os.sleep(0.5)
end
