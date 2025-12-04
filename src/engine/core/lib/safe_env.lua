local safe_env = {
    print = print,
    assert = assert,
    error = error,
    ipairs = ipairs,
    next = next,
    pairs = pairs,
    pcall = pcall,
    xpcall = xpcall,
    select = select,
    tonumber = tonumber,
    tostring = tostring,
    type = type,

    math = math,
    string = string,
    table = table,

    Engine = Engine,
}  

local function freeze(tbl, seen)
    if type(tbl) ~= "table" then
        return tbl
    end

    if seen[tbl] then
        return seen[tbl]
    end

    local proxy = {}
    seen[tbl] = proxy

    local mt = {
        __index = function(_, k)
            return freeze(tbl[k], seen)
        end,
        __newindex = function()
            error("attempt to modify a read-only table", 2)
        end,
        __metatable = false
    }

    return setmetatable(proxy, mt)
end

local function make_readonly_recursive(tbl)
    return freeze(tbl, {})
end

safe_env.math   = make_readonly_recursive(math)
safe_env.string = make_readonly_recursive(string)
safe_env.table  = make_readonly_recursive(table)
safe_env.Engine = make_readonly_recursive(Engine)
safe_env.love = love

local function get()
    return safe_env
end

return get