local push = require "push"

local GAME_WIDTH, GAME_HEIGHT = 432, 234 --fixed game resolution
local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH*.7, WINDOW_HEIGHT*.7
-- WINDOW_WIDTH, WINDOW_HEIGHT = 1280, 720

--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    push:apply('start')

    love.graphics.printf(
        'Hello Pong!',          -- text to render
        0,                      -- starting X (0 since we're going to center it based on width)
        GAME_HEIGHT / 2 - 6,  -- starting Y (halfway down the screen)
        GAME_WIDTH,           -- number of pixels to center within (the entire screen here)
        'center')               -- alignment mode, can be 'center', 'left', or 'right'

    push:apply('end')
end

-- set the game exit button
function love.keypressed(key)
    if key == 'escape' then
        -- love method to end the game
        love.event.quit()
    end
end