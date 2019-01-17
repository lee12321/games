StartState = Class{__includes = 'BaseState'}

local highlighted = 1

function StartState:update(dt)
    if love.keyboard.wasKeyPressed('up') or love.keyboard.wasKeyPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasKeyPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasKeyPressed('return') then
        gSounds['select']:play()
        if highlighted == 1 then
            gStateMachine:change('paddleSelect')
        end
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf("BREAKOUT", 0 , GAME_HEIGHT / 3 , GAME_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])

    if highlighted == 1 then
        love.graphics.setColor(103 / 255, 1, 1, 255) -- render selected 
    end
    love.graphics.printf("Start", 0 , GAME_HEIGHT / 2 + 70, GAME_WIDTH, 'center')
    
    love.graphics.setColor(1, 1, 1, 255)

    if highlighted == 2 then
        love.graphics.setColor(103 / 255, 1, 1, 255) -- render selected 
    end
    love.graphics.printf("High Score", 0 ,  GAME_HEIGHT / 2 + 90 , GAME_WIDTH, 'center')
    
    love.graphics.setColor(1, 1, 1, 255)
end