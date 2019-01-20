Queue = Class{}

function Queue:init()
    self.first = 1
    self.last = 0
    self.content = {}
end

function Queue:push(value)
    self.last = self.last + 1
    self.content[self.last] = value
end

function Queue:pop()
    if self.first > self.last then
        return nil
    end
    local value = self.content[self.first]
    self.first = self.first + 1
    return value
end
