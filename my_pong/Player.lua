Player = Class{}

function Player:init(x, y, width, height)
    self.x = x
    self.y = y
    self.height = height
    self.width = width
    self.dy = 0
end

--[[
    make player update in screen
]]
function Player:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(GAME_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    function to be called in main love.draw
]]
function Player:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end