local nodes = {
    node = require("node.node"),
    node2d = require("node.2d.node2d"),
    staticsprite2d = require("node.2d.staticsprite2d")
}

return {
    NodeTypes = nodes,
    create_node = function(node_type, name, parent, ...)
        local node_class = nodes[node_type:lower()]
        if not node_class then
            error("create_node: unknown node type '" .. tostring(node_type) .. "'")
        end
        return node_class:new(name, false, parent, {}, ...)
    end,
    get_node_by_id = function(scene, uuid)
        local node = scene.root_node:traverse_down_tree(function(n)
            return n.uuid == uuid
        end)
        return node
    end
}