Paddle = Class{}

function Paddle:init(skin)
    self.height = 16
    self.width = 64

    self.x = GAME_WIDTH / 2 - self.width / 2
    self.y = GAME_HEIGHT - 32
    self.dx = 0 --velocity

    self.skin = skin

    self.size = 3
end

function Paddle:render(health)
    if health ~= nil and 3 >= health and health > 0 then
        love.graphics.draw(gTextures['main'], gFrames['paddles'][health + 4 * (self.skin - 1)],
            self.x, self.y)
    else
        love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
    end
end

function Paddle:update(dt, health)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0
    end

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt)
    else
        self.x = math.min(GAME_WIDTH - self.width, self.x + self.dx * dt)
    end

    self.width = self.height * 2 * health 
end