PlayState = Class{__includes = 'BaseState'}

function PlayState:init(enterParams)
    self.level = 1
    self.board = Board(GAME_WIDTH / 2 - 30, 15)
    self.highlightedTile = nil
    self.canInput = true
    self.score = 0
    self.boardCursorX = 1
    self.boardCursorY = 1
end

function PlayState:update(dt)
    if self.canInput then
        -- cursor control
        if love.keyboard.keysPressed['down'] then
            self.boardCursorY = self.boardCursorY + 1 == 9 and 1 or self.boardCursorY + 1
        elseif love.keyboard.keysPressed['up'] then
            self.boardCursorY = self.boardCursorY - 1 == 0 and 8 or self.boardCursorY - 1
        elseif love.keyboard.keysPressed['left'] then
            self.boardCursorX = self.boardCursorX - 1 == 0 and 8 or self.boardCursorX - 1
        elseif love.keyboard.keysPressed['right'] then
            self.boardCursorX = self.boardCursorX + 1 == 9 and 1 or self.boardCursorX + 1
        end

        -- select control, and swap tile
        if love.keyboard.keysPressed['return'] then
            if self.highlightedTile == nil then
                print('select highlight tile, at ' .. self.boardCursorX, self.boardCursorY) -- DEBUG
                self.highlightedTile = self.board.tiles[self.boardCursorY][self.boardCursorX]
            elseif self.highlightedTile == self.board.tiles[self.boardCursorY][self.boardCursorX] then
                print('highlight cancel')   -- DEBUG
                self.highlightedTile = nil
            else
                self.canInput = false
                print('swapping tiles, cant input now') -- DEBUG
                local temp = self.board.tiles[self.boardCursorY][self.boardCursorX]
                swapTweens = self.highlightedTile:swap(self.board.tiles[self.boardCursorY][self.boardCursorX])
                Timer.tween(0.5, swapTweens):finish(function()
                    self.board.tiles[self.boardCursorY][self.boardCursorX] = self.highlightedTile
                    self.board.tiles[temp.GridY][temp.GridX] = temp
                    self.highlightedTile = nil
                    self:calculateMatches()
                    print('calculation finished')
                    self.canInput = true
                    print('can input now')
                    end)
                 -- debug
            end
        end
    end

    -- DEBUG
    if love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['space'] then
        print('current cursor: ' .. self.boardCursorX, self.boardCursorY)
        if self.highlightedTile ~= nil then
            print('current highlight: ' .. self.highlightedTile.GridX, self.highlightedTile.GridY)
        else
            print('current highlight: nil')
        end
    end
    Timer.update(dt)
end

function PlayState:render()
    self.board:render()
    if self.canInput then
        if self.highlightedTile ~= nil then -- render highlited tile
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.rectangle('fill',
                self.highlightedTile.x + self.board.x,
                self.highlightedTile.y + self.board.y,
                self.highlightedTile.width,
                self.highlightedTile.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setLineWidth(3)
        love.graphics.setLineStyle('rough')
        love.graphics.rectangle('line', -- render cursor
                (self.boardCursorX - 1) * 32 + self.board.x,
                (self.boardCursorY - 1) * 32 + self.board.y,
                32, 32, 8)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function PlayState:calculateMatches() 
    -- find matches and delete matches
    self.board:calculateMatches()
    if #self.board.matches > 0 then
        gSounds['match']:stop()
        gSounds['match']:play()
        self.board:floodFillMatches()
        self.board:deleteMatches(self.score)
        local fallTweens = self.board:getFallingTiles()
        print('start to add new tiles, ' .. #fallTweens .. ' tweens to do')
        Timer.tween(0.5, fallTweens):finish(function()
            self:calculateMatches()
        end)
    end
end