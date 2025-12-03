local SceneManager = class("SceneManager")

-- soon:
-- dynamic persistent first scene

function SceneManager:init(scenes)
    self.scenes = scenes or {}
    self.current_scene = scenes[1] or nil
end

function SceneManager:add_scene(scene)
    if typeof(scene) ~= "scene" then
        error("Only Scene objects can be added to the SceneManager.")
    end
    table.insert(self.scenes, scene)
end

function SceneManager:set_current_scene(scene)
    if typeof(scene) ~= "scene" then
        error("Only Scene objects can be set as the current scene.")
    end
    self.current_scene = scene
end

function SceneManager:get_current_scene()
    return self.current_scene
end

function SceneManager:update(dt)
    if self.current_scene then
        self.current_scene:update(dt)
    else
        error("No current scene set in SceneManager.")
    end
end

function SceneManager:draw()
    if self.current_scene then
        self.current_scene:draw()
    else
        error("No current scene set in SceneManager.")
    end
end

return SceneManager