Bird = Class{}

GRAVITY = 10
JUMP_SPEED = -3

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = GAME_WIDTH / 3
    self.y = GAME_HEIGHT / 2 - self.height / 2

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasKeyPressed('space') then
        self.dy = JUMP_SPEED
    end

    self.y = self.y + self.dy
end

function Bird:collides()
    if self.y <= 0 or self.y + self.width -5 >= GAME_HEIGHT then
        return true
    end
    return false
end