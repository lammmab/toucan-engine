local Node = require("node.node")
local ScriptNode = class("ScriptNode", Node)

function ScriptNode:init(parent, path)
    if not inherits(parent, Node) then
        error("Parent must be a node.")
    end
    ScriptNode.super.init(self, "ScriptNode", false, parent, {})
    self.path = path or nil
end

return ScriptNode