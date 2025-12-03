local nodes = {
    Node = require("node.node"),
    Node2D = require("node.2d.node2d"),
    ScriptNode = require("node.scriptnode")
}

return {
    create_node = function(node_type, name, parent, ...)
        local node_class = nodes[node_type]
        if not node_class then
            error("create_node: unknown node type '" .. tostring(node_type) .. "'")
        end
        return node_class:new(name, false, parent, {}, ...)
    end
}