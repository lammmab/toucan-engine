local Node = require("node.node")
local Vector2 = require("math.vector2")
local NodeConverter = {}

local function vec2_to_string(vec2)
    if typeof(vec2) ~= "vector2" then
        error("Attempt to encode non-vector2 object")
    end
    return string.format("vec2(%s,%s)", tostring(vec2.x), tostring(vec2.y))
end

local function string_to_vec2(str)
    if type(str) ~= "string" then
        error("Attempt to decode non-string object!")
    end

    local x, y = str:match("^vec2%(([^,]+),([^,]+)%)$")
    x, y = tonumber(x), tonumber(y)

    if not x or not y then
        error("Invalid string passed to string_to_vec2")
    end

    return Vector2:new(x, y)
end

local function is_vec2_string(str)
    if type(str) ~= "string" then
        return false
    end

    return str:match("^vec2%(([^,]+),([^,]+)%)$") ~= nil
end

local function decode(tbl)
    local expected_type = tbl["node_type"]
    local node_class = Engine.NodeTypes[expected_type:lower()]

    local node = node_class:new(tbl["name"], tbl["is_root_node"], tbl["parent"], {})

    for k, v in pairs(tbl) do
        if node[k] == nil then
            print("Key " .. k .. " not found in node: " .. expected_type .. ", skipping")
            goto continue
        end

        if is_vec2_string(v) then
            node[k] = string_to_vec2(v)
        elseif v == "true" then
            node[k] = true
        elseif v == "false" then
            node[k] = false
        elseif tonumber(v) ~= nil then
            node[k] = tonumber(v)
        elseif type(v) == "string" then
            node[k] = v
        end

        ::continue::
    end

    return node
end

function NodeConverter.encode_node(node)
    if not inherits(node, Node) then
        error("Attempt to encode a non-node object!")
    end

    local encoded = {}
    encoded["node_type"] = typeof(node)

    for k, v in pairs(node) do
        if type(v) == "function"
        or k == "children"
        or k == "is_node"
        or k == "_signals" then
            goto continue
        end

        local v_type = typeof(v)

        if v_type == "vector2" then
            encoded[k] = vec2_to_string(v)
        elseif v_type == "string"
        or v_type == "boolean" then
            encoded[k] = tostring(v)
        elseif v_type == "number" then
            encoded[k] = tostring(v)
        elseif inherits(v, Node) then
            encoded[k] = v.uuid
        end

        ::continue::
    end

    return encoded
end

function NodeConverter.decode_node(node_obj)
    return decode(node_obj)
end

return NodeConverter