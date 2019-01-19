require 'src/Dependencies'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('breakout')
    push:setupScreen(GAME_WIDTH, GAME_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    }
    
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }
    
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
    }

    gStateMachine = StateMachine({
        ['start'] = function() return StartState() end,
        ['paddleSelect'] = function() return PaddleSelectState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['gameOver'] = function() return GameOverState() end,
        ['highScore'] = function() return HighScoreState() end,
        ['enterHighScore'] = function() return EnterHighScoreState() end,
    })

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['powerUps'] = GenerateQuadsPowerUps(gTextures['main']),
        ['lockBrick'] = table.slice(GenerateQuads(gTextures['main'], 32, 16), 24, 24, 1)
    }

    gStateMachine:change('start', {highScores = LoadHighScores()})
    gSounds['music']:play()
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keyboard.wasKeyPressed(key)
    -- a function to query if a key is pressed last frame
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {} -- update the input table to empty at this frame
end

function love.draw()
    BACK_GROUND_WIDTH = gTextures['background']:getWidth()
    BACK_GROUND_HEIGHT = gTextures['background']:getHeight()
    push:apply('start')
    love.graphics.draw(
        gTextures['background'],
        0, 0, -- draw at coordinates 0, 0
        0, -- no rotation
        GAME_WIDTH / (BACK_GROUND_WIDTH - 1),
        GAME_HEIGHT / (BACK_GROUND_HEIGHT - 1)
    )
    gStateMachine:render()
    push:apply('end')
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == "rctrl" then --set to whatever key you want to use
        debug.debug()
     end
end

-- global function to render hearts

function RenderHearts(health)

    local x = GAME_WIDTH - 100
    local y = 3

    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], x, y)
        x = x + 10
    end
    
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], x, y)
        x = x + 10
    end
end

function RenderScore(score)
    local x = GAME_WIDTH - 70
    
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('score: ' .. tostring(score), x, 3, 50)
end

function LoadHighScores()
    love.filesystem.setIdentity('breakout')

    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10 , 1, -1 do
            scores = scores .. 'CT0\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end
        love.filesystem.write('breakout.lst' ,scores)
    end

    local scores = {}
    local counter = 1
    local nameFlag = true

    for j = 1, 10 do
        scores[j] = {
            name = nil,
            score = nil
        }
    end

    for line in love.filesystem.lines('breakout.lst') do
        if nameFlag then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end
        nameFlag = not nameFlag
    end
    assert(scores[10])
    return scores
end