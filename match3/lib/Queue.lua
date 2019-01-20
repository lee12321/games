Queue = Class{}

function Queue:init()
    self.first = 1
    self.last = 0
    self.content = {}
end

function Queue:push(value)
    local last = self.last + 1
    self.last = last
    self.content[last] = value
end

function Queue:pop()
    first = self.first
    if self.first > self.last then
        return nil
    end
    local value = self.content[first]
    self.first = first + 1
    return value
end
