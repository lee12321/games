StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
    }
    self.current = self.empty
    self.states = states or {}
end

function StateMachine:change(stateName, enterParams)
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:render()
    self.current:render()
end

function StateMachine:update(dt)
    self.current:update(dt)
end