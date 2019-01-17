ServeState = Class{__includes = 'BaseState'}

function ServeState:enter(params)
    self.paddle = params['paddle']
    self.ball = params['ball']
    self.map = params['map']
    self.score = params['score']
    self.health = params['health']
end

function ServeState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Press space to serve", 0 , GAME_HEIGHT / 2 , GAME_WIDTH, 'center')
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.map) do
        brick:render()
    end
    RenderHearts(self.health)
    RenderScore(self.score)
end

function ServeState:update()
    self.ball.x = self.paddle.x + self.paddle.width / 2 - 4
    self.ball.y = self.paddle.y - 9
    if love.keyboard.wasKeyPressed('space') then
        self.ball.dx = math.random(-100, 100)
        self.ball.dy = math.random(-90, -110)
        -- pass those objects to the play state
        params = {
            ['paddle'] = self.paddle,
            ['ball'] = self.ball,
            ['map'] = self.map,
            ['score'] = self.score,
            ['health'] = self.health,
        }
        gStateMachine:change('play', params)
    end
end