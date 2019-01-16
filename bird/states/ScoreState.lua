ScoreState = Class{__includes = BaseState}
goldImage = love.graphics.newImage('gold.png')

function ScoreState:init()
    self.name = 'score'
end

function ScoreState:enter(params)
    self.score = params
end

function ScoreState:update(dt)
    if love.keyboard.wasKeyPressed('n') then
        gStateMachine:change('count')
    end
end

function ScoreState:render()
    love.graphics.printf('Total Score: ' .. tostring(self.score), 0, 64, GAME_WIDTH, 'center')
    love.graphics.setFont(largeFont)
    love.graphics.printf('Game Over!', 0, 32, GAME_WIDTH, 'center')
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press n continue!', 0, 96, GAME_WIDTH, 'center')
    if self.score >= 3 then
        love.graphics.draw(goldImage, GAME_WIDTH / 2, 128)
        love.graphics.printf('You win a gold medal!', 0, 160, GAME_WIDTH, 'center')
    end
end