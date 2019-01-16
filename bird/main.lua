push = require 'push'   -- resolution lib
Class = require 'class' -- class lib
require 'Bird'  -- bird class
require 'Pipe'  -- pip class
require 'PipePair' -- pipepair class

-- load state machines
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/PauseState'
require 'states/ScoreState'
require 'states/CountState'

-- set resolution
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH* 0.7, WINDOW_HEIGHT* 0.7

GAME_WIDTH, GAME_HEIGHT = 512, 288

-- ground and background settings
local background = love.graphics.newImage('background.png')
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413 -- point to shift the image back to right 
local backgroundPosition = 0 -- backgroud image x-axis

local ground = love.graphics.newImage('ground.png')
local GROUND_SCROLL_SPEED = 60
local groundPosition = 0
math.randomseed(os.time()) -- set random seed globally

sounds = {
    ['jump'] = love.audio.newSource('jump.wav', 'static'),
    ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
    ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
    ['score'] = love.audio.newSource('score.wav', 'static'),
    ['music'] = love.audio.newSource('marios_way.mp3', 'static'),
}
sounds['music']:setLooping(true)
sounds['music']:play()

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Bird')

    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- import font
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    largeFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(largeFont)

    -- initialize statemachine
    gStateMachine = StateMachine({
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['pause'] = function() return PauseState() end,
        ['score'] = function() return ScoreState() end,
        ['count'] = function() return CountState() end,
    })
    gStateMachine:change('title')

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
    if gStateMachine.current.stateName ~= 'pause' and gStateMachine.current.stateName ~= 'count' then
        backgroundPosition = (backgroundPosition + BACKGROUND_SCROLL_SPEED * dt ) % BACKGROUND_LOOPING_POINT
        groundPosition = (groundPosition + GROUND_SCROLL_SPEED * dt) % GAME_WIDTH
    end
    gStateMachine:update(dt)
    
    love.keyboard.keysPressed = {} -- update the input table to empty at this frame
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
    -- love.graphics.draw(love.graphics.newImage('pipe.png'),
    --     0, -- position to draw on x-axis
    --     0,-- position to draw on y-axis
    --     0, -- rotation
    --     1, -- x scale
    --     1) -- y scale)
    gStateMachine:render()
    push:finish()
end
