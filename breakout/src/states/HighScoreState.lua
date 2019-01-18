HighScoreState = Class{__includes = 'BaseState'}

function HighScoreState:enter(params)
    self.highScores = LoadHighScores()
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    assert(self.highScores)
    for i = 1, 10 do
        local name = self.highScores[i].name or '---'
        local score = self.highScores[i].score or '---'
        love.graphics.printf(tostring(i),
        GAME_WIDTH / 4, 60 + i * 13, 50, 'left')
        love.graphics.printf(name,
        GAME_WIDTH / 4 + 38, 60 + i * 13, 50, 'right')
        love.graphics.printf(tostring(score),
        GAME_WIDTH / 2, 60 + i * 13, 100, 'right')
    end
end

function HighScoreState:update()
    if love.keyboard.wasKeyPressed('escape') then
        gStateMachine:change('start')
    end
end