push = require 'push'   -- resolution lib
Class = require 'class' -- class lib
require 'Bird'  -- bird class
-- set resolution
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH* 0.7, WINDOW_HEIGHT* 0.7

GAME_WIDTH, GAME_HEIGHT = 512, 288

-- ground and background settings
local background = love.graphics.newImage('background.png')
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413 -- point to shift back to right 
local backgroundPosition = 0

local ground = love.graphics.newImage('ground.png')
local GROUND_SCROLL_SPEED = 60
local groundPosition = 0



local bird = Bird()
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Bird')
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    love.keyboard.keysPressed = {} -- a input table to store the keys pressed this frame
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasKeyPressed(key)
    -- a function to query if a key is pressed last frame
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    backgroundPosition = (backgroundPosition + BACKGROUND_SCROLL_SPEED * dt ) % BACKGROUND_LOOPING_POINT
    groundPosition = (groundPosition + GROUND_SCROLL_SPEED * dt) % GAME_WIDTH

    bird:update(dt) -- update bird position, apply gravity and jump

    love.keyboard.keysPressed = {} -- update the input table to empty this frame
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true -- if a key is pressed, store it in input tale

    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    love.graphics.draw(background, -backgroundPosition, 0)
    love.graphics.draw(ground, -groundPosition, GAME_HEIGHT - 15)
    bird:render()
    push:finish()
end
