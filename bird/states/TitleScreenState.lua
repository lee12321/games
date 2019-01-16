TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    self.stateName = 'title'
end

function TitleScreenState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf('Press space to start game', 0, 64, GAME_WIDTH, 'center')
end

function TitleScreenState:update(dt)
    if love.keyboard.wasKeyPressed('space') then
        gStateMachine:change('play')
    end
end