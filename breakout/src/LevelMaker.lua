LevelMaker = Class{}


-- render patterns
local SKIP = 1
local SOLID = 2
local ALTERNATE = 3
local None = 4

function LevelMaker.createMap(level)
    -- Generate cols and rows based on level
    level = level > 5 and 5 or level
    local Rows = math.random(level, 1 + level)
    local Cols = math.random(7 + level, 8 + level)
    Cols = Cols % 2 == 0 and Cols + 1 or Cols 
    -- Highest bricks tier and color setting
    local highestColor = math.min(level + 2, 4)
    local highestTier = math.min(level, 3)
    -- Two pattern, alternate or solid
    local altColor1 = math.random(1, highestColor)
    local altColor2 = math.random(1, highestColor)
    local altTier1 = math.random(0, highestTier)
    local altTier2 = math.random(0, highestTier)

    local solidColor = math.random(1, highestColor)
    local solidTier = math.random(1, highestTier)

    -- Add all bricks to a table and return
    local bricks = {}
    for y = 1, Rows do
        -- Flags to determine if skip a brick
        local skipPattern = math.random(1, 2) == 1 and true or false
        local skipFlag = math.random(1, 2) == 1 and true or false
        local altPattern = math.random(1, 2) == 1 and true or false
        local altFlag = math.random(1, 2) == 1 and true or false
        
        for x = 1, Cols do  -- generate loop
            -- do skipping
            if skipPattern and skipFlag then
                skipFlag = not skipFlag
                goto continue
            else
                skipFlag = not skipFlag
            end
            -- generate brick
            b = Brick((x - 1) 
                        * 32 
                        + 8 
                        + (13 - Cols) * 16, 
                        y * 16)
            table.insert(bricks, b)
            -- do color alternate and tier alternate
            if altPattern then
                if altFlag then
                    b.skin = altColor1
                    b.tier = altTier1
                    altFlag = not altFlag
                else
                    b.skin = altColor2
                    b.tier = altTier2
                    altFlag = not altFlag
                end
            else
                b.skin = solidColor
                b.tier = solidTier
            end
        ::continue::
        end
    end
    -- if no bricks generated, redo it
    if #bricks == 0 then
        return self.createMap
    else
        return bricks
    end
end

    