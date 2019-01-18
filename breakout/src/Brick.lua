Brick = Class{}

paletteColors = { -- colors used in particle sys
    -- blue
    [1] = {
        ['r'] = 99 / 255,
        ['g'] = 155 / 255,
        ['b'] = 255 / 255
    },
    -- green
    [2] = {
        ['r'] = 106 / 255,
        ['g'] = 190 / 255,
        ['b'] = 47 / 255
    },
    -- red
    [3] = {
        ['r'] = 217 / 255,
        ['g'] = 87 / 255,
        ['b'] = 99 / 255
    },
    -- purple
    [4] = {
        ['r'] = 215 / 255,
        ['g'] = 123 / 255,
        ['b'] = 186 / 255
    },
    -- gold
    [5] = {
        ['r'] = 251 / 255,
        ['g'] = 242 / 255,
        ['b'] = 54 / 255
    }
}

function Brick:init(x, y)
    self.height = 16
    self.width = 32
    self.x = x
    self.y = y

    self.skin = 1
    self.tier = 0

    self.inPlay = true

    -- https://love2d.org/wiki/ParticleSystem
    self.pSys = love.graphics.newParticleSystem(gTextures['particle'], 64)

    self.pSys:setParticleLifetime(0.5, 1)
    self.pSys:setLinearAcceleration(-15, 0, 15, 80)
    self.pSys:setEmissionArea('normal', 10, 10) 
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(gTextures['main'], 
            gFrames['bricks'][1 + (self.skin - 1) * 4 + self.tier], 
            self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.pSys, self.x + 16, self.y + 8)
end

function Brick:hit()
    self.pSys:setColors(
        paletteColors[self.skin].r,
        paletteColors[self.skin].g,
        paletteColors[self.skin].b,
        55 * (self.tier + 1)/ 255,
        paletteColors[self.skin].r,
        paletteColors[self.skin].g,
        paletteColors[self.skin].b,
        0
    )
    self.pSys:emit(64)

    if self.tier == 0 then
        self.inPlay = false
        gSounds['brick-hit-1']:play()
    else
        self.tier = self.tier - 1
        gSounds['brick-hit-2']:play()
    end
end

function Brick:update(dt)
    self.pSys:update(dt)
end