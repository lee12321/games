local push = require "push"
Class = require "class"

-- import class
require 'Player'
require 'Ball'
require 'Bot'

--fixed game resolution
GAME_WIDTH, GAME_HEIGHT = 432, 234 
local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = WINDOW_WIDTH*.7, WINDOW_HEIGHT*.7

-- set paddle speed
PADDLE_SPEED = 100


--[[
    Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
    -- filter, title
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pong')

    -- random seeds
    math.randomseed(os.time())

    -- retro font
    smallFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- load sound resource
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- set resolution
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })

    -- initialize player score
    player1Score = 0
    player2Score = 0
    servePlayer = 1

    -- initialize paddle position
    player1 = Player(10, 30, 5, 20)
    player2 = Bot(GAME_WIDTH - 10, GAME_HEIGHT - 30, 5, 20)
    player2isBot = true

    -- initialize ball
    ball = Ball(GAME_WIDTH / 2 - 2, GAME_HEIGHT / 2 - 2, 4, 4)

    -- initialize game state
    gameState = 'start'
end


--[[
    update frame every delta time in seconds
]]
function love.update(dt)
    if gameState == 'serve' then
        if servePlayer == 1 then
            ball.dx = math.random(100, 150)
        else
            ball.dx = -math.random(100, 150)
        end
    end

    if gameState == 'play' then
        -- collides detection
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            -- change bounce angle
            if ball.dy < 0 then
                ball.dy = math.random(10, 150)
            else
                ball.dy = -math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 5
            -- change bounce angle
            if ball.dy < 0 then
                ball.dy = math.random(10, 150)
            else
                ball.dy = -math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        -- bounce from upper bond or lower bond
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        
        if ball.y >= GAME_HEIGHT - 4 then
            ball.y = GAME_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        -- score update
        if ball.x < 0 then
            sounds['score']:play()
            player2Score = player2Score + 1
            if player2Score == 11 then
                gameState = 'win'
                winningPlayer = 2
            else
                servePlayer = 1
                ball:reset()
                gameState = 'serve'
            end
        end
        if ball.x > GAME_WIDTH then
            sounds['score']:play()
            player1Score = player1Score + 1
            if player1Score == 11 then
                gameState = 'win'
                winningPlayer = 1
            else
                servePlayer = 2
                ball:reset()
                gameState = 'serve'
            end
        end

    
        -- player1 control
        if love.keyboard.isDown('w') then
            player1.dy = -PADDLE_SPEED
        elseif love.keyboard.isDown('s') then
            player1.dy = PADDLE_SPEED
        else
            player1.dy = 0
        end

        -- player2 control
        if player2isBot == true then
            player2:follow(ball)
        else
            if love.keyboard.isDown('up') then
                player2.dy = -PADDLE_SPEED
            elseif love.keyboard.isDown('down') then
                player2.dy = PADDLE_SPEED
            else
                player2.dy = 0
            end
        end

        -- ball position update
        if gameState == 'play' then
            ball:update(dt)
        end

        -- player position update
        player1:update(dt)
        player2:update(dt)
    end
end

--[[
    Called after update by LÖVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
    -- render with Game res
    push:apply('start')

    -- clear with backgroud color
    love.graphics.clear({40 / 255, 45 / 255, 52 / 255, 255})

    -- render hello message
    love.graphics.setFont(smallFont)
    if gameState == 'start' then
        love.graphics.printf(
            'Press space to start!',          -- text to render
            0,                      -- starting X (0 since we're going to center it based on width)
            GAME_HEIGHT / 2 - 50,  -- starting Y (halfway down the screen)
            GAME_WIDTH,           -- number of pixels to center within (the entire screen here)
            'center')               -- alignment mode, can be 'center', 'left', or 'right'
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press space to serve!', 0, GAME_HEIGHT / 2 - 50, GAME_WIDTH, 'center')
    elseif gameState == 'pause' then
        love.graphics.printf('Game paused! Press space to continue!', 0, GAME_HEIGHT / 2 - 50, GAME_WIDTH, 'center')
    elseif gameState == 'win' then
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins! Press space to restart!', 0, GAME_HEIGHT / 2 - 50, GAME_WIDTH, 'center')
    end

    -- render score
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), GAME_WIDTH / 2 - 70, 
        GAME_HEIGHT / 7)
    love.graphics.print(tostring(player2Score), GAME_WIDTH / 2 + 50,
        GAME_HEIGHT / 7)

    -- render player
    player1:render()
    player2:render()

    -- render ball
    ball:render()

    -- render FPS
    displayFPS()

    push:apply('end')
end
--[[
    Keyboard handling, called by LÖVE2D each frame; 
    passes in the key we pressed so we can access.
]]
function love.keypressed(key)
    if key == 'escape' then
        -- love method to end the game
        if gameState == 'play' then
            gameState = 'pause'
        else
            love.event.quit()
        end
    end

    if key == 'space' then
        -- change the game state
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'pause' then
            gameState = 'play'
        elseif gameState == 'win' then
            player1Score = 0
            player2Score = 0
            ball:reset()
            gameState = 'serve'
        -- elseif gameState == 'play' then
        --     gameState = 'start'

        --     -- reset ball position and speed
        --     ball:reset()

        end
    end
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end