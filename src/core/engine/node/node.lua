local Node = class("Node")

function Node:init(name, is_root_node, parent, children)
    self._is_node = true
    self._signals = {}
    self._children = children or {}

    self.name = name or "Node"
    self.is_root_node = is_root_node or false
    self.uuid = generate_uuid()

    if parent then
        self:set_parent(parent)
    elseif not self.is_root_node then
        error("Non-root nodes must have a parent node.")
    end

    self:emit("_on_mount")
end

function Node:emit(name,...)
    if not self._signals[name:lower()] then self._signals[name:lower()] = {} end
    local sigs = self._signals[name:lower()]
    if #sigs == 0 then print("No listeners for event " .. name:lower()) return end
    for i=1,#sigs do
        sigs[i](...)
    end
end

function Node:on(name,fn)
    if type(fn) ~= "function" then error("Argument passed to Node:on is not a function") end
    if not self._signals[name:lower()] then self._signals[name:lower()] = {} end
    table.insert(self._signals[name:lower()],fn)
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


-- TODO: Implement script attachment
-- 1. Load the script from the path
-- 2. Run the script in the Node environment
-- 3. Store callbacks to be called during the Node lifecycle
-- 4. Run init function if exists 
function Node:attach_script(path)
    
end

return Node