PlayState = Class{__includes = 'BaseState'}

function PlayState:init()
    self.paused = false
    self.win = false
end

function PlayState:enter(params)
    self.paddle = params['paddle']
    self.ball = params['ball']
    self.map = params['map']
    self.health = params['health']
    self.score = params['score']
    self.level = params['level']
    self.balls = {}
    self.powerUps = {}
    self.powerUpTimer = 0
    self.newBallAmount = 2
    table.insert(self.balls, self.ball)
end

function PlayState:render()
    if self.paused then
        love.graphics.printf("PAUSED", 0 , GAME_HEIGHT / 3 , GAME_WIDTH, 'center')
    end
    self.paddle:render()
    for i, ball in pairs(self.balls) do
        if ball.inPlay then
            ball:render()
        end
    end
    for k, brick in pairs(self.map) do
        brick:render()
    end
    for k, brick in pairs(self.map) do
        brick:renderParticles()
    end
    -- render powerUps
    for i, powerUp in pairs(self.powerUps) do
        if powerUp.inPlay then
            powerUp:render()
        end
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
        -- update paddle
        self.paddle:update(dt)
        -- update all balls
        for i, ball in pairs(self.balls) do
            if ball.inPlay then
                ball:update(dt)
            end
        end
        -- detect powerUp collision
        for i, powerUp in pairs(self.powerUps) do
            if powerUp.inPlay then
                powerUp:update(dt)
            end
            if powerUp:collides(self.paddle) then
                if powerUp.type == 9 then
                    powerUp.inPlay = false
                    for i = 1, self.newBallAmount do
                        local new = Ball(math.random(7))
                        new.x = self.paddle.x
                        new.y = self.paddle.y - 9
                        new.dx = math.random(-100, 100)
                        new.dy = math.random(-90, -110)
                        table.insert(self.balls, new)
                    end
                end
            end
            if powerUp.y > GAME_HEIGHT then
                powerUp.inPlay = false
            end
        end
        -- detect balls collision with paddle
        for i, ball in pairs(self.balls) do    
            if ball.inPlay and ball:collides(self.paddle) then
                ball.dy = -ball.dy
                ball.y = ball.y - 3
                if ball.x < self.paddle.x + self.paddle.width / 2 and ball.dx < 0 then
                    ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x > self.paddle.x + self.paddle.width / 2 and ball.dx > 0 then
                    ball.dx = 50 + math.abs(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x < self.paddle.x + self.paddle.width / 2 and ball.dx > 0 then
                    ball.dx = 50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x > self.paddle.x + self.paddle.width / 2 and ball.dx < 0 then
                    ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                end
            end
        end

        self.win = true -- asume win

        for k, brick in pairs(self.map) do
            brick:update(dt) --update particle system
            if brick.inPlay then
                -- if brick still in play, set the win to false
                self.win = false
            
                -- brick collision detect
                for i, ball in pairs(self.balls) do
                    if ball.inPlay and ball:collides(brick) then
                        -- scores based on brick tier
                        self.score = self.score + (brick.tier + 1 ) * 10
                        brick:hit()
                        -- increase power up timer
                        self.powerUpTimer = self.powerUpTimer + 1
                        if self.powerUpTimer == 3 then -- create power up
                            table.insert(self.powerUps, PowerUp(9))
                        end
                        -- check to see which side of the brick is hit
                        if ball.x + 2 < brick.x and ball.dx > 0 then
                            -- left
                            ball.dx = - ball.dx
                            ball.x = brick.x - 8
                        elseif  ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                            -- right
                            ball.dx = - ball.dx
                            ball.x = brick.x + brick.width 
                        elseif  ball.y < brick.y then
                            -- top
                            ball.dy = - ball.dy
                            ball.y = brick.y - 8
                        else
                            ball.dy = - ball.dy
                            ball.y = brick.y + brick.height 
                        end
                        ball.dy = ball.dy * 1.02
                        break
                    end
                end
            end
        end
        
        if self.win then
            -- if wins, go to next level
            gStateMachine:change('serve',
            {
                paddle = self.paddle,
                ball = Ball(math.random(7)),
                map = LevelMaker.createMap(self.level + 1),
                score = self.score,
                health = self.health,
                level = self.level + 1,
            }
            )
        end
        local lose = true -- asume lose
        -- if all the ball falls out of the screen, decrease health
        for i, ball in pairs(self.balls) do
            if ball.inPlay then
                lose = false
            end
            if ball.y >= GAME_HEIGHT then
                ball.inPlay = false
            end
        end

        if lose then
            self.health = self.health - 1
            if self.health == 0 then
                -- game over
                gStateMachine:change('gameOver', {
                    score = self.score
                })
            else
                self.ball.inPlay = true
                gStateMachine:change('serve', {
                    paddle = self.paddle, 
                    ball = self.ball,
                    map = self.map, 
                    health = self.health,
                    score = self.score,
                    level = self.level
                })
            end
        end
    end
end