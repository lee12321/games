Board = Class{}

TILE_COLOR_SELECT = {[1] = 0, [2] = 3, [3] = 8, [4] = 10, [5] = 11, [6] = 13}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}
    -- generate radom tiles
    for y = 1, 8 do
        self.tiles[y] = {} -- new row
        for x = 1, 8 do
            table.insert(self.tiles[y], Tile(x, y, TILE_COLOR_SELECT[math.random(#TILE_COLOR_SELECT)]))
        end
    end
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            if self.tiles[y][x] ~= nil then
                self.tiles[y][x]:render(self.x, self.y) -- render tiles offset
            end
        end
    end
end

function Board:calculateMatches()
    -- detect matches horizontally
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            if x < 7 then
                local targetColor = self.tiles[y][x].color
                local tempMatch3 = {}
                for i = x, 8 do
                    if self.tiles[y][i].color == targetColor then
                        table.insert(tempMatch3, self.tiles[y][i])
                    else
                        break
                    end
                end
                if #tempMatch3 >= 3 then
                    table.insert(self.matches, tempMatch3)
                end  
            end

        end
    end
    -- detect matches vertically
    for x = 1, 8 do
        for y = 1, 8 do
            if y < 7 then
                local targetColor = self.tiles[y][x].color
                local tempMatch3 = {}
                for i = y, 8 do
                    if self.tiles[i][x].color == targetColor then
                        table.insert(tempMatch3, self.tiles[i][x])
                    else
                        break
                    end
                end
                if #tempMatch3 >= 3 then
                    table.insert(self.matches, tempMatch3)
                end  
            end
        end
    end
end

function Board:floodFillMatches()
    if #self.matches > 0 then
        for i, match in pairs(self.matches) do
            local queue = Queue()
            match[1].looked = true
            queue:push(match[1])
            local tempMatch = {}
            while queue.first <= queue.last do
                local currentTile = queue:pop()
                table.insert(tempMatch, currentTile)
                -- check if the left tile is the same color
                if currentTile.GridX - 1 > 0 then
                    local leftTile = self.tiles[currentTile.GridY][currentTile.GridX - 1]
                    if not leftTile.looked and currentTile.color == leftTile.color then
                        leftTile.looked = true
                        table.insert(tempMatch, leftTile)
                        queue:push(leftTile)
                    end
                end
                -- check if the right tile is the same color
                if currentTile.GridX + 1 < 9 then
                    local rightTile = self.tiles[currentTile.GridY][currentTile.GridX + 1]
                    if not rightTile.looked and currentTile.color == rightTile.color then
                        rightTile.looked = true
                        table.insert(tempMatch, rightTile)
                        queue:push(rightTile)
                    end
                end
                -- check if the top tile is the same color
                if currentTile.GridY - 1 > 0 then
                    local topTile = self.tiles[currentTile.GridY - 1][currentTile.GridX]
                    if not topTile.looked and currentTile.color == topTile.color then
                        topTile.looked = true
                        table.insert(tempMatch, topTile)
                        queue:push(topTile)
                    end
                end
                -- check if the bottom tile is the same color
                if currentTile.GridY + 1 < 9 then
                    local bottomTile = self.tiles[currentTile.GridY + 1][currentTile.GridX]
                    if not bottomTile.looked and currentTile.color == bottomTile.color then
                        bottomTile.looked = true
                        table.insert(tempMatch, bottomTile)
                        queue:push(bottomTile)
                    end
                end
            end
            if #tempMatch > 3 then
                self.matches[i] = tempMatch
            end
        end
        -- clear up
        for i, match in pairs(self.matches) do
            for j, tile in pairs(match) do
                tile.looked = false
            end
        end
    end
end

function Board:deleteMatches(score)
    -- calculate score of matched tile, delete all matches
    for i, match in pairs(self.matches) do
        for j, tile in pairs(match) do
            if self.tiles[tile.GridY][tile.GridX] ~= nil then
                score = score + self.tiles[tile.GridY][tile.GridX].type * 10 
                self.tiles[tile.GridY][tile.GridX] = nil
            end
        end
    end
    self.matches = {}
end

function Board:getFallingTiles()
    -- bring the tile down if there is a space
    local tweens = {}
    for x = 1, 8 do
        local y = 8
        local spaceY = 0
        local foundSpace = false
        while y >= 1 do
            local currentTile = self.tiles[y][x]
            if foundSpace then
                if currentTile then -- go up untill we find a tile
                    self.tiles[spaceY][x] = currentTile -- fill the space
                    currentTile.GridY = spaceY
                    self.tiles[y][x] = nil  --change current grid to nil
                    tweens[currentTile] = {
                        y = (currentTile.GridY - 1) * 32
                    }
                    print('fall twins added')
                    foundSpace = false
                    y = spaceY  -- go back to the space just filled with tile
                    spaceY = 0
                end
            else    -- go up untill we find a space
                if currentTile == nil then
                    spaceY = y
                    foundSpace = true
                end
            end
            y = y - 1
        end
    end
    -- create new tile to fill space
    for x = 1, 8 do
        for y = 8, 1 , -1 do
            if not self.tiles[y][x] then
                local newTile = Tile(x, y, TILE_COLOR_SELECT[math.random(#TILE_COLOR_SELECT)])
                newTile.y = -32
                self.tiles[y][x] = newTile
                tweens[newTile] = {
                    y = (newTile.GridY - 1) * 32
                }
                print('fall twins added')
            end
        end
    end
    print('total tweens added: ' .. #tweens)
    return tweens
end