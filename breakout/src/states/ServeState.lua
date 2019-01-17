ServeState = Class{__includes = 'BaseState'}

function ServeState:enter(params)
    self.paddle = Paddle(params)
    self.ball = Ball(1)
    self.map = LevelMaker.createMap()
end

function ServeState:render()
    love.graphics.printf("Press space to serve", 0 , GAME_HEIGHT / 2 , GAME_WIDTH, 'center')
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.map) do
        brick:render()
    end
end

function ServeState:update()
    if love.keyboard.wasKeyPressed('space') then
        self.ball.dx = math.random(-100, 100)
        self.ball.dy = math.random(-90, -110)
        params = {
            ['paddle'] = self.paddle,
            ['ball'] = self.ball,
            ['map'] = self.map
        }
        gStateMachine:change('play', params)
    end
end