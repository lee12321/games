Tile = Class{}

function Tile:init(GridX, GridY, color)
    self.height = 32
    self.width = 32
    self.GridX = GridX
    self.GridY = GridY
    self.x = (self.GridX - 1) * 32
    self.y = (self.GridY - 1) * 32
    self.color = color
    self.type = 3
    self.selected = false
    self.looked = false -- for flood fill
end

function Tile:render(x, y) -- x, y is offset
    love.graphics.draw(gTextures['main'], 
        gFrames['tiles'][self.type + self.color * 6], 
        self.x + x, 
        self.y + y)

end

function Tile:swap(tile)
    local tweens = {}
    self.GridX, tile.GridX = tile.GridX, self.GridX
    self.GridY, tile.GridY = tile.GridY, self.GridY
    -- self.x = (self.GridX - 1) * 32
    -- self.y = (self.GridY - 1) * 32
    -- tile.x = (tile.GridX - 1) * 32
    -- tile.y = (tile.GridY - 1) * 32
    tweens[self] = {
        x = (self.GridX - 1) * 32,
        y = (self.GridY - 1) * 32
    }
    tweens[tile] = {
        x = (tile.GridX - 1) * 32,
        y = (tile.GridY - 1) * 32
    }
    return tweens
end

function Tile:update(dt)
end