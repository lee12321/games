push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife.timer'
require 'lib/Queue'
require 'src/constants'
require 'src/Util'
require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'

-- load sources
gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
}

gFrames = {
    ['tiles'] = GenerateQuads(gTextures['main'], 32, 32)
}

gSounds = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
}
