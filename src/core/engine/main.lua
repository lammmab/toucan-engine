local Engine = require("engine")
local Node2D = require("node.2d.node2d")
local Scene = require("scene_manager.scene")
local Shape2D = require("node.2d.shape2d")
local vector2 = require("math.vector2").Vector2

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
    root_node:on("TestEvent",function(data)
        print(data)
    end)

    shape = Shape2D:new("MyRectangle", false, root_node, {}, vector2:new(50,50), 0, "circle", vector2:new(100, 0), {1, 0, 0})
    local main_scene = Scene:new("Main", root_node)
    engine = Engine.new(main_scene)
end

function love.update(dt)
    engine.scene_manager:update(dt)
    elapsed = elapsed + dt

    if elapsed > 1 then
        print("Emitting")
        elapsed = 0
        root_node:emit("TestEvent","This is a test")
    end
end

function love.draw()
    engine.scene_manager:draw()
end
