Tile = Class{}

function Tile:init(x, y, color)
    self.height = 32
    self.width = 32
    self.x = x
    self.y = y
    self.color = color
    self.type = 1
    self.selected = false
    self.looked = false -- for flood fill
end

function Tile:render()
    if self.selected then
        love.graphics.setColor(1, 1, 1, 0.5)
        love.graphics.draw(gTextures['main'], gFrames['tiles'][self.type + self.color * 6], self.x, self.y)
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.draw(gTextures['main'], gFrames['tiles'][self.type + self.color * 6], self.x, self.y)
    end
end

function Tile:update(dt)
end