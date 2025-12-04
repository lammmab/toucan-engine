local speed = 50
local current_dir = Engine.new_vec2(0,0)
local function choose_random_dir()
    local angle = math.random() * 2 * math.pi
    local x = math.cos(angle)
    local y = math.sin(angle)
    return Engine.new_vec2(x, y)
end

local normals = {
    left = Engine.new_vec2(1,0),
    right = Engine.new_vec2(-1,0),
    top = Engine.new_vec2(0,1),
    bottom = Engine.new_vec2(0,-1)
}

local function is_touching_edge(pos, size)
    local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()
    local touching = {
        left   = pos.x <= 0,
        right  = pos.x + size.x >= screenW,
        top    = pos.y <= 0,
        bottom = pos.y + size.y >= screenH
    }
    return touching
end

local function reflect(v,n)
    local normalized = n:normalized()
    local dot = v:dot(normalized)
    return v-normalized*(2*dot)
end

function _on_mount()
    current_dir = choose_random_dir()
end

function _update(dt)
    print(current_dir)
    self:set_position(self.position + Engine.new_vec2(
        current_dir.x * speed * dt, 
        current_dir.y * speed * dt
    ))
    local edge = is_touching_edge(self.position,self.size)
    if edge.left then
        current_dir = reflect(current_dir, normals.left)
        self.position.x = 0
    elseif edge.right then
        current_dir = reflect(current_dir, normals.right)
        self.position.x = love.graphics.getWidth() - self.size.x
    end

    if edge.top then
        current_dir = reflect(current_dir, normals.top)
        self.position.y = 0
    elseif edge.bottom then
        current_dir = reflect(current_dir, normals.bottom)
        self.position.y = love.graphics.getHeight() - self.size.y
    end
end