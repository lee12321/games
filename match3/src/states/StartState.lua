StartState = Class{ __includes = 'BaseState' }

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('MATCH 3', 0, GAME_HEIGHT / 2 - 16, GAME_WIDTH, 'center')
end

function StartState:update(dt)
    if love.keyboard.keysPressed['return'] then
        gStateMachine:change('play')
    end
end