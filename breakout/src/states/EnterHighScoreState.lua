EnterHighScoreState = Class{__includes = 'BaseState'}


function EnterHighScoreState:init()
    self.chars = {
        [1] = 65,
        [2] = 65,
        [3] = 65
    }
    self.currentChar = 1
    self.highScores = LoadHighScores()
end

function EnterHighScoreState:enter(params)
    self.score = params.score
    if tonumber(self.highScores[10].score) >= self.score then
        gStateMachine:change('start')
    end
end

function EnterHighScoreState:render()
    love.graphics.printf('New High Score! Please Enter Your Name!',
    0 , GAME_HEIGHT / 3 - 30 , GAME_WIDTH, 'center')
    love.graphics.printf(string.char(self.chars[1]) .. string.char(self.chars[2]) .. string.char(self.chars[3]),
        0 , GAME_HEIGHT / 3 , GAME_WIDTH, 'center')
end

function EnterHighScoreState:update(dt)
    -- select character horizontally
    if love.keyboard.wasKeyPressed('left') then 
        self.currentChar = self.currentChar - 1 == 0 and 3 or self.currentChar - 1
    elseif love.keyboard.wasKeyPressed('right') then
        self.currentChar = self.currentChar + 1 == 4 and 1 or self.currentChar + 1
    end

    -- select character vertically
    if love.keyboard.wasKeyPressed('up') then 
        self.chars[self.currentChar] = self.chars[self.currentChar] - 1 == 64 and 90 or self.chars[self.currentChar] - 1
    elseif love.keyboard.wasKeyPressed('down') then
        self.chars[self.currentChar] = self.chars[self.currentChar] + 1 == 91 and 65 or self.chars[self.currentChar] + 1
    end

    -- caculate rank
    local rank = 0
    if love.keyboard.wasKeyPressed('return') then
        local name = string.char(self.chars[1]) .. string.char(self.chars[2]) .. string.char(self.chars[3])

        for i = 1, 10 do
            if self.highScores[i].score < self.score then
                for j = 10, i + 1, -1 do
                    self.highScores[j].score = self.highScores[j - 1].score
                    self.highScores[j].name = self.highScores[j - 1].name
                end
            -- else
            --     self.highScores[i].score = self.score
            --     self.highScores[i].name = name
                self.highScores[i].score = self.score
                self.highScores[i].name = name
                break
            end
        end
        
        local highScoreStr = ''

        for i = 1, 10 do
            highScoreStr = highScoreStr .. self.highScores[i].name .. '\n'
            highScoreStr = highScoreStr .. self.highScores[i].score .. '\n'
        end
        love.filesystem.write('breakout.lst', highScoreStr)

        gStateMachine:change('highScore')
    end
end