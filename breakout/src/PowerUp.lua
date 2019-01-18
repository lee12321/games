PowerUp = Class{}

function PowerUp:init(type)
    self.x = math.random(16, GAME_WIDTH - 16)
    self.y = 0
    self.width = 16
    self.height = 16
    self.dy = 50
    self.type = type
    self.inPlay = true
end

function PowerUp:render()
    love.graphics.draw(gTextures['main'], gFrames['powerUps'][self.type], self.x, self.y)
end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
end

function PowerUp:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end
    gSounds['paddle-hit']:play()
    return true
end
