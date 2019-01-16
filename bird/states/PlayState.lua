PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.stateName = 'play'
    self.bird = Bird()
    self.pipePairs = {}
    self.pipeTimer = 0
    self.lastPipeY = -PIPE_HEIGHT + math.random(80) + 20 -- y-axis of the top pipe
end

function PlayState:update(dt)
    self.pipeTimer = self.pipeTimer + dt

    if self.pipeTimer > 2 then
        y = math.max(-PIPE_HEIGHT + 20, -- not higher than this position
                math.min( --get higher one 
                self.lastPipeY + math.random(-20, 20), -- last pipe position +- 20
                GAME_HEIGHT - GAP_HEIGHT - PIPE_HEIGHT -- lowest position
                )
            )
            self.lastPipeY = y
        table.insert(self.pipePairs, PipePair(y))
        self.pipeTimer = 0
    end

    self.bird:update(dt) -- update bird position, apply gravity and jump

    if self.bird:collides() then
        -- detect if bird collides top or bottom
        gStateMachine:change('title')
    end

    -- update pipe, detect collision
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:update(dt)
        for i, pipe in pairs(pipePair.pipes) do
            if pipe:collides(self.bird) then
                gStateMachine:change('title')
            end 
        end
    end

    if love.keyboard.wasKeyPressed('up') then
        gStateMachine:change('pause')
    end
end

function PlayState:render()
    self.bird:render()
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:render()
    end
end