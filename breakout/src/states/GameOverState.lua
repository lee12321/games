GameOverState = Class{__includes = 'BaseState'}

function GameOverState:enter(params)
    self.score = params['score']
end

function GameOverState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Game Over!', 0, GAME_HEIGHT / 2 -32, GAME_WIDTH,'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score: ' .. tostring(self.score), 0, GAME_HEIGHT / 2 + 16, GAME_WIDTH,'center')
    love.graphics.printf('Press Enter', 0, GAME_HEIGHT / 2 + 32, GAME_WIDTH,'center')
end

function GameOverState:update()
    if love.keyboard.wasKeyPressed('return') then
        gStateMachine:change('enterHighScore',{score = self.score} )
    end
end