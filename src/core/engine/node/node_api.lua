local nodes = {
    node = require("node.node"),
    node2d = require("node.2d.node2d"),
    scriptnode = require("node.scriptnode")
}

return {
    NodeTypes = nodes,
    create_node = function(node_type, name, parent, ...)
        local node_class = nodes[node_type:lower()]
        if not node_class then
            error("create_node: unknown node type '" .. tostring(node_type) .. "'")
        end
        return node_class:new(name, false, parent, {}, ...)
    end
}