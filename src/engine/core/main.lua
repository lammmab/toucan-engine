dofile("global.lua")

local ToucanEngine = require("engine")
local Node2D = require("node.2d.node2d")
local Scene = require("scene_manager.scene")
local StaticSprite2D = require("node.2d.shape2d")
local vector2 = require("math.vector2").Vector2
local new_color = require("math.color").new_color3
local engine
local elapsed = 0
local shape

-- Current TODO:
-- 1. Create the file structure of a project
-- 2. Easily decode any l2d file (Scene)
-- 3. Hook UI -> love2d (somehow)

local root_node
function love.load()
    root_node = Node2D:new("RootNode", true)

    shape = StaticSprite2D:new("MyRectangle", false, root_node, {}, vector2:new(50,50), 0, "rectangle", vector2:new(32,32))
    
    shape:set_script("test_script.lua")
    shape:run_script()
    
    local main_scene = Scene:new("Main", root_node)
    engine = ToucanEngine.new(main_scene)
    Engine.Logging.toggle_debug(true)
end

function love.update(dt)
    engine.scene_manager:update(dt)

end

function love.draw()
    engine.scene_manager:draw()
end

