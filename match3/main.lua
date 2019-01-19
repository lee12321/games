require 'src/Dependencies'

function love.load()
    math.randomseed(os.time()) -- random seed
    love.graphics.setDefaultFilter('nearest', 'nearest') -- retro style
    love.window.setTitle('MATCH 3')
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    gStateMachine = StateMachine({
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
    })
    gStateMachine:change('start')
    love.keyboard.keysPressed = {} -- record pressed keys
    BACKGROUND_SCROLLING_SPEED = -50    -- for background scrolling
    backgroundX = 0 -- for background scrolling
end

function love.update(dt)
    if backgroundX < -1024 + GAME_WIDTH then -- update background position
        backgroundX = 0
    else
        backgroundX = backgroundX + BACKGROUND_SCROLLING_SPEED * dt
    end
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:apply('start')
    love.graphics.draw( -- draw a scrolling background
        gTextures['background'],
        backgroundX, 0, -- draw at coordinates x, y
        0, -- no rotation
        1, -- x-scale
        1 -- y-scale
    )
    gStateMachine:render()
    push:apply('end')
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == "rctrl" then -- for debug purpose, 'cont' to end
        debug.debug()
     end
end

function love.resize(w, h)
    push:resize(w, h)
end
