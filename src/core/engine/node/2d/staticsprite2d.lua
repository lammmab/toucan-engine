local StaticSprite2D = class("StaticSprite2D", require("node.2d.node2d"))

function StaticSprite2D:init(name, is_root_node, parent, children, position, rotation, scale, path)
    StaticSprite2D.super.init(self, name, is_root_node, parent, children, position, rotation, scale)
    
    self.path = path
    self._asset = Engine.get_asset(path)
    self._w = self._asset:getWidth()
    self._h = self._asset:getHeight()
end

function StaticSprite2D:draw()
    love.graphics.draw(
        self._asset, 
        self.global_position.x, 
        self.global_position.y, 
        self.global_rotation, 
        self.global_scale.x, 
        self.global_scale.y,
        self._w / 2,
        self._h / 2
    )
end