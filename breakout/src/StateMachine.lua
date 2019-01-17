StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
    }
    self.states = states or {}
    self.current = self.empty
    self.pausedGame = {}
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    if stateName == 'pause' and self.current.stateName == 'play' then
        self.pausedGame = self.current
        self.current = self.states[stateName]()
    elseif self.current.stateName == 'count' and stateName =='play' then
        if next(self.pausedGame) == nil then
            self.current = self.states[stateName]()
        else
            self.current = self.pausedGame
            self.pausedGame = {}
        end
    else
        self.current = self.states[stateName]()
    end
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end