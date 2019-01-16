CountState = Class{__includes = BaseState}

CountSpeed = 1

function CountState:init()
    self.stateName = 'count'
    self.countdown = 3
    self.count = 0
end

function CountState:update(dt)
    self.count = self.count + dt
    if self.count >= CountSpeed then
        self.count = self.count % CountSpeed
        self.countdown = self.countdown - 1
    end
    if self.countdown < 0 then
        gStateMachine:change('play')
    end
end

function CountState:render()
    if next(gStateMachine.pausedGame) ~= nil then
        gStateMachine.pausedGame:render()
    end
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.countdown), 0, 64, GAME_WIDTH, 'center')
end