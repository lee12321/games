Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.height = height
    self.width = width

    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

--[[
    update ball movement
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

--[[
    collide detection
]]
function Ball:collides(player)
    if self.x > player.x + player.width or player.x > self.x + self.width then
        return false
    end

    if self.y > player.y + player.height or player.y > self.y + self.height then
        return false
    end

    return true
end
--[[
    method to reset the ball at the starting position
]]
function Ball:reset()
    self.y = GAME_HEIGHT / 2 - 2
    self.x = GAME_WIDTH / 2 - 2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

--[[
    function to be called in main love.draw
]]
function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

