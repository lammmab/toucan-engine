local Vector2 = class("Vector2")

function Vector2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Vector2:copy()
    return Vector2:new(self.x, self.y)
end

function Vector2.__tostring()
    return string.format("Vector2(%f, %f)", self.x, self.y)
end

function Vector2.__add(a, b)
    return Vector2:new(a.x + b.x, a.y + b.y)
end

function Vector2.__sub(a, b)
    return Vector2:new(a.x - b.x, a.y - b.y)
end

function Vector2.__mul(a,b)
    if type(a) == "number" then
        return Vector2:new(a * b.x, a * b.y)
    elseif type(b) == "number" then
        return Vector2:new(a.x * b, a.y * b)
    else
        error("Vector2: multiply expects vector*scalar or scalar*vector")
    end
end

function Vector2:dot(b)
    return self.x * b.x + self.y * b.y
end

function Vector2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:normalized()
    local len = self:length()
    if len == 0 then return Vector2:new(0, 0) end
    return Vector2:new(self.x / len, self.y / len)
end

function Vector2:__tostring()
    return string.format("Vector2(%f, %f)", self.x, self.y)
end

return {
    Vector2 = Vector2,
    new_vec2 = function(x, y) return Vector2:new(x, y) end,
    add_vec2 = function(a, b) return a + b end,
    sub_vec2 = function(a, b) return a - b end,
    dot_vec2 = function(a, b) return a:dot(b) end,
    length_vec2 = function(a) return a:length() end,
    normalize_vec2 = function(a) return a:normalized() end,
}