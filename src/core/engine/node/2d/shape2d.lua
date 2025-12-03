local Shape2D = class("Shape2D", require("node.2d.node2d"))
local Vector2 = require("math.vector2")

local shapes = {
    ["rectangle"] = 1,
    ["circle"] = 2,
}

function Shape2D:init(name, is_root_node, parent, children, position, rotation, shape, size, color)
    if parent and not inherits(parent, require("node.2d.node2d")) then
        error("Parent must be a Node2D.")
    end
    Shape2D.super.init(self, name, is_root_node, parent, children, position, rotation)
    if shape and not shapes[shape] then
        error("Invalid shape type: " .. tostring(shape))
    end
    
    if size and typeof(size) ~= "vector2" then
        error("Size must be a Vector2.")
    end
    self.shape = shape or "circle"
    self.size = size or Vector2:new(32,32)
    self.color = color or {1,0,0}
end

function Shape2D:draw()
    love.graphics.setColor(self.color)
    if self.shape == "rectangle" then
        love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.x, self.size.y)
    elseif self.shape == "circle" then
        local radius = self.size.x
        love.graphics.circle("fill", self.position.x, self.position.y, radius)
    end
    love.graphics.setColor(1,1,1)
end

return Shape2D