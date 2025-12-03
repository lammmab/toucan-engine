local Node2D = require("node.2d.node2d")
local Scene = class("Scene")

function Scene:init(name,root_node)
    if not root_node or not inherits(root_node, Node2D) then
        error("Scene must have a valid Node2D root node, or a subclass of Node2D")
    end
    self.name = name or "Scene"
    self.root_node = root_node
end

function Scene:update(dt)
    self.root_node:update_all(dt)
end

function Scene:draw()
    self.root_node:draw_all()
end

return Scene