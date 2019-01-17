Brick = Class{}

function Brick:init(x, y, skin)
    self.height = 16
    self.width = 32
    self.x = x
    self.y = y

    self.skin = skin
    self.tier = 1

    self.inPlay = true
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][(self.skin - 1) * 4 + self.tier], 
            self.x, self.y)
    end
end

function Brick:hit()
    self.inPlay = false
    gSounds['brick-hit-2']:play()
end