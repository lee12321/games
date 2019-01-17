PaddleSelectState = Class{__includes = 'BaseState'}

function PaddleSelectState:init()
    self.paddles = {
        [1] = Paddle(1),
        [2] = Paddle(2),
        [3] = Paddle(3),
    }
    self.current = 1
end

function PaddleSelectState:update()
    if love.keyboard.wasKeyPressed('left') then
        self.current = (self.current - 1) == 0 and 3 or self.current - 1
        gSounds['paddle-hit']:play()
    elseif love.keyboard.wasKeyPressed('right') then
        self.current = (self.current + 1) % 3 + 1
        gSounds['paddle-hit']:play()
    elseif love.keyboard.wasKeyPressed('return') then
        gSounds['select']:play()
        gStateMachine:change('serve', {
            paddle = Paddle(self.current),
            ball = Ball(1),
            map = LevelMaker.createMap(),
            score = 0,
            health = 3,
        })
    end
end

function PaddleSelectState:render()
    love.graphics.printf("Select a paddle you like!", 0 ,  GAME_HEIGHT / 2  , GAME_WIDTH, 'center')
    love.graphics.printf("Press left or right to select, enter to start!", 0 ,  GAME_HEIGHT / 2 + 30 , GAME_WIDTH, 'center')
    self.paddles[self.current]:render()
end