local Node = class("Node")
local Signals = require("lib.signals")

function Node:init(name, is_root_node, parent, children)
    self._is_node = true
    self._signals = Signals:new()
    self._children = children or {}

    self.name = name or "Node"
    self.is_root_node = is_root_node == true
    self.uuid = generate_uuid()

    if parent then
        self:set_parent(parent)
    elseif not self.is_root_node then
        error("Non-root nodes must have a parent node.")
    end

    self._signals:emit("_on_mount")

    self._funcs = {}
    self._script = nil
    self.script_path = ""
end

function Node:run_script_hook(name,...)
    if self._funcs[name] then
        self._funcs[name](self,...)
    end
end

function Node:run_script()
    if self._script then
        self._script()
    end
end

function Node:set_script(path)
    self.script_path = path
    local chunk_str = assert(love.filesystem.read(path))

    local env = setmetatable({}, { __index = function(_, k)
        return self[k] or _G[k]
    end })

    self._script = assert(load(chunk_str, "@"..path, "t", env))
    self._script()
    
    self._funcs = env
    self:run_script_hook("_on_mount")
end

function Node:set_parent(parent)
    print("Setting parent of node '" .. self.name .. "'")
    if self.parent and self.parent == parent then
        print("Node '" .. self.name .. "' already has the specified parent.")
        return
    end

    if self.is_root_node then
        error("Root nodes cannot have a parent.")
    end

    if parent then
        if not inherits(parent, Node) then
            error("Parent must be a node.")
        end
        
        self.parent = parent
        parent:add_child(self)
    end
end

function Node:get_parent()
    return self.parent
end

function Node:get_children()
    return self._children
end

function Node:add_child(child)
    if not inherits(child, Node) then
        error("Child must be a Node.")
    end
    table.insert(self._children, child)
end

function Node:add_children(children)
    for i=1,#children do
        local child = children[i]
        self:add_child(child)
    end
end

function Node:remove_child(child)
    if not inherits(child, Node) then
        error("Child must be a node.")
    end
    local index = find_index(self._children, child)
    if not index then
        print("Child not found in parent '" .. self.name .. "'")
        return
    end

    table.remove(self._children, index)
    child:set_parent(nil)
end

function Node:traverse_down_tree(cb)
    if cb(self) then return self end
    for i = 1, #self._children do
        local child = self._children[i]

        if cb(child) then
            return child
        end

        local found = child:traverse_down_tree(cb)
        if found then
            return found
        end
    end
    return nil
end

function Node:_update()
    -- override
end

return Node