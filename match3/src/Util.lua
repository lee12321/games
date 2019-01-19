function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for x = 1, sheetWidth do
        for y = 1, sheetHeight do
            spriteSheet[sheetCounter] = love.graphics.newQuad(
                x * tileWidth,  -- The top-left position in the Image along the x-axis
                y * tileHeight, -- The top-left position in the Image along the y-axis
                tileWidth,  -- quad width
                tileHeight, -- quad height
                atlas:getDimensions() -- reference x & y
                )
            sheetCounter = sheetCounter + 1
        end
    end

    return spriteSheet
end