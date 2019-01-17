PlayState = Class{__includes = 'BaseState'}

function PlayState:init()
    self.paused = false
end

function PlayState:enter(params)
    self.paddle = params['paddle']
    self.ball = params['ball']
    self.map = params['map']
    self.health = params['health']
    self.score = params['score']
end

function PlayState:render()
    if self.paused then
        love.graphics.printf("PAUSED", 0 , GAME_HEIGHT / 3 , GAME_WIDTH, 'center')
    end
    self.paddle:render()
    self.ball:render()
    for k, brick in pairs(self.map) do
        brick:render()
    end
    RenderHearts(self.health)
    RenderScore(self.score)
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasKeyPressed('space') then
            -- pause function
            self.paused = false
            gSounds['music']:play()
        end
    else
        if love.keyboard.wasKeyPressed('space') then
            -- pause function
            self.paused = true
            gSounds['music']:stop()
        end

        self.paddle:update(dt)
        self.ball:update(dt)

        if self.ball:collides(self.paddle) then
            self.ball.dy = -self.ball.dy
            self.ball.y = self.ball.y - 3
            if self.ball.x < self.paddle.x + self.paddle.width / 2 and self.ball.dx < 0 then
                self.ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            elseif self.ball.x > self.paddle.x + self.paddle.width / 2 and self.ball.dx > 0 then
                self.ball.dx = 50 + math.abs(5 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            -- elseif self.ball.x < self.paddle.x + self.paddle.width / 2 and self.ball.dx > 0 then
            --     self.ball.dx = 50 + -(5 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            -- elseif self.ball.x > self.paddle.x + self.paddle.width / 2 and self.ball.dx < 0 then
            --     self.ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - self.ball.x))
            end
        end

        for k, brick in pairs(self.map) do
            if brick.inPlay and self.ball:collides(brick) then
                brick:hit()
                self.score = self.score + brick.tier * 10
                -- check to see which side of the brick is hit
                if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                    -- left
                    self.ball.dx = - self.ball.dx
                    self.ball.x = brick.x - 8
                elseif  self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                    -- right
                    self.ball.dx = - self.ball.dx
                    self.ball.x = brick.x + brick.width 
                elseif  self.ball.y < brick.y then
                    -- top
                    self.ball.dy = - self.ball.dy
                    self.ball.y = brick.y - 8
                else
                    self.ball.dy = - self.ball.dy
                    self.ball.y = brick.y + brick.height 
                end
                self.ball.dy = self.ball.dy * 1.02
                break
            end
        end
        -- if the ball falls out of the screen, decrease health
        if self.ball.y >= GAME_HEIGHT then
            self.health = self.health - 1
            if self.health == 0 then
                gStateMachine:change('game-over', {
                    score = self.score
                })
            else
                gStateMachine:change('serve', {
                    paddle = self.paddle, 
                    ball = self.ball,
                    map = self.map, 
                    health = self.health,
                    score = self.score,
                })
            end
        end
    end
end