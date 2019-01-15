push = require 'push'
Class = require 'class'
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH* 0.7, WINDOW_HEIGHT* 0.7

GAME_WIDTH, GAME_HEIGHT = 512, 288

local background = love.graphics.newImage('background.png')
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413
local backgroundPosition = 0

local ground = love.graphics.newImage('ground.png')
local GROUND_SCROLL_SPEED = 60
local groundPosition = 0


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Bird')
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    backgroundPosition = (backgroundPosition + BACKGROUND_SCROLL_SPEED * dt ) % BACKGROUND_LOOPING_POINT
    groundPosition = (groundPosition + GROUND_SCROLL_SPEED * dt) % GAME_WIDTH
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundPosition, 0)
    love.graphics.draw(ground, -groundPosition, GAME_HEIGHT - 15)
    push:finish()
end
