Ball = Class{}

function Ball:init(skin)
    self.width = 8
    self.height = 8
    self.x = GAME_WIDTH / 2 - self.width / 2
    self.y = GAME_HEIGHT - 32 - self.height
    self.dx = 0
    self.dy = 0
    self.skin = skin
    self.inPlay = true
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x <= 0 then
        self.dx = -self.dx
        self.x = self.x + 3
        gSounds['wall-hit']:play()
    elseif self.x  + self.width >= GAME_WIDTH then
        self.dx = -self.dx
        self.x = self.x - 3
        gSounds['wall-hit']:play()
    end
    if self.y <= 0 then
        self.dy = -self.dy
        self.y = self.y + 3
        gSounds['wall-hit']:play()
    end
end

function Ball:render(dt)
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end

function Ball:collides(target)
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end
    gSounds['paddle-hit']:play()
    return true
end