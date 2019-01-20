function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 1, sheetHeight do
        for x = 1, sheetWidth do
            spriteSheet[sheetCounter] = love.graphics.newQuad(
                (x - 1) * tileWidth,  -- The top-left position in the Image along the x-axis
                (y - 1) * tileHeight, -- The top-left position in the Image along the y-axis
                tileWidth,  -- quad width
                tileHeight, -- quad height
                atlas:getDimensions() -- reference x & y
                )
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end