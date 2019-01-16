PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.stateName = 'pause'
end

function PauseState:update()
    if love.keyboard.wasKeyPressed('up') then
        gStateMachine:change('play')
    end
end

function PauseState:render()
    gStateMachine.pausedGame:render()
    love.graphics.printf('Game Paused', 0, 64, GAME_WIDTH, 'center')
end