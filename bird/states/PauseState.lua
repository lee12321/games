PauseState = Class{__includes = BaseState}

function PauseState:init()
    self.stateName = 'pause'
end

function PauseState:enter()
    sounds['music']:stop()
end

function PauseState:exit()
    sounds['music']:play()
end

function PauseState:update()
    if love.keyboard.wasKeyPressed('up') then
        gStateMachine:change('count')
    end
end

function PauseState:render()
    gStateMachine.pausedGame:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Game Paused', 0, 64, GAME_WIDTH, 'center')
end