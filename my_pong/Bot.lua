Bot = Class{}

function Bot:init(x, y, width, height)
    self.x = x
    self.y = y
    self.height = height
    self.width = width
    self.dy = 0
end

--[[
    make Bot update in screen
]]
function Bot:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(GAME_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

--[[
    function to be called in main love.draw
]]
function Bot:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
--[[
    method to follow the ball
]]
function Bot:follow(ball)
    if self.y + self.height / 2> ball.y then
        self.dy = -PADDLE_SPEED
    elseif self.y + self.height / 2 < ball.y then
        self.dy = PADDLE_SPEED
    else
        self.dy = 0
    end
end