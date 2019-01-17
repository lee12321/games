Paddle = Class{}

function Paddle:init(skin)
    self.height = 16
    self.width = 64

    self.x = GAME_WIDTH / 2 - self.width / 2
    self.y = GAME_HEIGHT - 32
    self.dx = 0 --velocity

    self.skin = skin

    self.size = 2
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][self.size + 4 * (self.skin - 1)],
        self.x, self.y)
end

function Paddle:update(dt)
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
end