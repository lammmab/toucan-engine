local nodes = require("node.node_api")
local vector2 = require("math.vector2")
local scene_manager = require("scene_manager.manager")
local Engine = {}
Engine.__index = Engine

function Engine.new(main_scene)
    local self = setmetatable({}, Engine)

    self.apis = {nodes, vector2}
    self.scene_manager = scene_manager:new({main_scene})

    self:setup_apis()
    return self
end

function Engine:setup_apis()
    _G.Engine = _G.Engine or {}
    for i=1,#self.apis do
        local api = self.apis[i]
        for name, value in pairs(api) do
            if _G.Engine[name] == nil then
                _G.Engine[name] = value
            else
                print("Warning: global " .. name .. " already exists in API, skipping.")
            end
        end
    end
end

return Engine