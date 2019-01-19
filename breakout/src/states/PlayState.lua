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
    self.powerUpTimer = {
        [9] = math.random(3, 5),
        [10] = math.random(2, 3)
    }
    self.hits = 0
    self.newBallAmount = 2
    table.insert(self.balls, self.ball)
end

function PlayState:render()
    if self.paused then
        love.graphics.printf("PAUSED", 0 , GAME_HEIGHT / 3 , GAME_WIDTH, 'center')
    end
    self.paddle:render(self.health)
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
        self.paddle:update(dt, self.health)
        -- update all balls
        for i, ball in pairs(self.balls) do
            if ball.inPlay then
                ball:update(dt)
            end
        end
        -- update powerUp and detect powerUp collision
        for i, powerUp in pairs(self.powerUps) do
            if powerUp.inPlay then --update powerup
                powerUp:update(dt)
            end
            if powerUp.inPlay and powerUp:collides(self.paddle) then -- powerup collision
                if powerUp.type == 9 then
                    powerUp.inPlay = false
                    for i = 1, self.newBallAmount do
                        local new = Ball(math.random(7))
                        new.x = self.paddle.x + self.paddle.width / 2
                        new.y = self.paddle.y - 9
                        new.dx = math.random(-100, 100)
                        new.dy = math.random(-90, -110)
                        table.insert(self.balls, new)
                    end
                elseif powerUp.type == 10 then
                    powerUp.inPlay = false
                    for i, brick in pairs(self.map) do
                        brick.lock = false
                    end
                    LockedBrickExists = false
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
                ball.y = self.paddle.y - ball.height - 2
                if ball.x < self.paddle.x + self.paddle.width / 2 and ball.dx <= 0 then
                    ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x > self.paddle.x + self.paddle.width / 2 and ball.dx >= 0 then
                    ball.dx = 50 + math.abs(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x < self.paddle.x + self.paddle.width / 2 and ball.dx >= 0 then
                    ball.dx = 50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                elseif ball.x > self.paddle.x + self.paddle.width / 2 and ball.dx <= 0 then
                    ball.dx = -50 + -(5 * (self.paddle.x + self.paddle.width / 2 - ball.x))
                end
            end
        end

        self.win = true -- asume win

        --detect ball brick collision
        for k, brick in pairs(self.map) do
            brick:update(dt) --update particle system
            if brick.inPlay then
                -- if brick still in play, set the win to false
                self.win = false
            
                -- brick collision detect
                for i, ball in pairs(self.balls) do
                    if ball.inPlay and ball:collides(brick) then
                        -- scores based on brick tier
                        if not brick.lock then
                            self.score = self.score + (brick.tier + 1 ) * 10
                        end
                        brick:hit()
                        -- increase power up timer or release powerUp
                        self.hits = self.hits + 1
                        if self.hits % self.powerUpTimer[9] == self.powerUpTimer[9] - 1  then -- create power up
                            table.insert(self.powerUps, PowerUp(9))
                        elseif self.hits % self.powerUpTimer[10] == self.powerUpTimer[10] - 1 and LockedBrickExists then
                            -- if there is locked brick, generate key after certain hits untill no lock exists
                            table.insert(self.powerUps, PowerUp(10))
                        end
                        -- check to see which side of the brick is hit
                        if ball.x + 2 < brick.x and ball.dx > 0 then
                            -- left
                            ball.dx = - ball.dx
                            ball.x = brick.x - ball.width - 1
                        elseif  ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                            -- right
                            ball.dx = - ball.dx
                            ball.x = brick.x + brick.width + 1
                        elseif  ball.y < brick.y then
                            -- top
                            ball.dy = - ball.dy
                            ball.y = brick.y - ball.height - 1
                        else
                            ball.dy = - ball.dy
                            ball.y = brick.y + brick.height + 1
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