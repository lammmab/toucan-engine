local Node2D = class("Node2D", require("node.node"))
local Vector2 = require("math.vector2").Vector2

function Node2D:init(name, is_root_node, parent, children, position, rotation, scale)
    Node2D.super.init(self, name or "Node2D", is_root_node or false, parent, children or {})

    self.position = position or Vector2:new(0, 0)
    self.rotation = rotation or 0
    self.scale = scale or Vector2:new(1, 1)

    self:updateGlobalTransform()
end

function Node2D:set_position(position)
    if typeof(position) ~= "vector2" then
        error("Position must be a Vector2.")
    end
    self.position = position
    self:updateGlobalTransform()
end

function Node2D:set_rotation(rotation)
    if typeof(rotation) ~= "number" then
        error("Rotation must be a number.")
    end
    self.rotation = rotation
    self:updateGlobalTransform()
end

function Node2D:set_scale(scale)
    if typeof(scale) ~= "vector2" then
        error("Scale must be a Vector2.")
    end
    self.scale = scale
    self:updateGlobalTransform()
end

function Node2D:get_position() return self.position end
function Node2D:get_rotation() return self.rotation end
function Node2D:get_scale() return self.scale end

function Node2D:updateGlobalTransform()
    if self.parent then
        self.global_position = self.parent.global_position + self.position 
        self.global_rotation = self.parent.global_rotation + self.rotation
        self.global_scale = self.parent.global_scale * self.scale
    else
        self.global_position = self.position
        self.global_rotation = self.rotation
        self.global_scale = self.scale
    end

    for _, child in ipairs(self.children) do
        child:updateGlobalTransform()
    end
end

function Node2D:update_all(dt)
    for i=1,#self.children do
        local child = self.children[i]
        child:update(dt)
    end
end

function Node2D:draw_all()
    for i=1,#self.children do
        local child = self.children[i]
        child:draw()
    end
end

function Node2D:update(dt)
    -- Override
end

function Node2D:draw(dt)
    -- Override
end

return Node2D