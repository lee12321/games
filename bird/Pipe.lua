Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
PIPE_SCROLL_SPEED = -60
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.orientation = orientation
    self.x = GAME_WIDTH
    -- self.y = math.random(GAME_HEIGHT * 1 / 3, GAME_HEIGHT - 20)
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, -- drawable 
        self.x, -- position to draw on x-axis
        self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y,-- position to draw on y-axis
        0, -- rotation
        1, -- x scale
        self.orientation == 'top' and -1 or 1) -- y scale
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL_SPEED * dt
end

function Pipe:collides(bird)
    if bird.x + bird.width - 2 >= self.x and bird.x <= self.x + self.width + 2 then
        if bird.y + bird.height - 5 >= self.y and bird.y - 5 <= self.y + PIPE_HEIGHT then
            return true
        end
        return false
    end
end