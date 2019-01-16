PipePair = Class{}

GAP_HEIGHT = math.random(70, 110)

function PipePair:init(y)
    GAP_HEIGHT = math.random(70, 110)
    self.x = GAME_WIDTH
    self.y = y -- top pipe's y-axis
    self.pipes = {
        ['top'] = Pipe('top', self.y),
        ['bottom'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }
    self.remove = false
    self.scored = false
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then
        self.x = self.x + PIPE_SCROLL_SPEED * dt
        self.pipes['top'].x = self.x
        self.pipes['bottom'].x = self.x 
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end