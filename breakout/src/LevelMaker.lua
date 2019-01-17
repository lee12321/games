LevelMaker = Class{}

function LevelMaker.createMap()
    local Rows = math.random(3, 5)
    local Cols = math.random(7, 13)
    local bricks = {}
    for y = 1, Rows do
        for x = 1, Cols do
            b = Brick((x - 1) 
                        * 32 
                        + 8 
                        + (13 - Cols) * 16, 
                        y * 16, 1)
            table.insert(bricks, b)
        end
    end
    return bricks
end