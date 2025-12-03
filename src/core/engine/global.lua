local seed = os.time() + os.clock() * 1000000 + math.random(0, 0xFFFF)
math.randomseed(seed)
for i = 1, 10 do math.random() end

local function random_hex(n)
    local s = ""
    for i = 1, n do
        s = s .. string.format("%x", math.random(0, 99))
    end
    return s
end

_G.class = function(name,base)
    local c = {}
    c.__index = c
    c.__name = name or error("Class must have a name.")

    if base then
        c.super = base
    end

    setmetatable(c, {__index = base})
    function c:new(...)
        local obj = setmetatable({}, c)
        if obj.init then obj:init(...) end
        return obj
    end
    return c
end
_G.typeof = function(obj)
    local t = type(obj)
    
    if t == "table" then
        local mt = getmetatable(obj)
        if mt and mt.__name then
            return mt.__name:lower()
        end
    end

    return t:lower()
end
_G.inherits = function(obj, class)
    local mt = getmetatable(obj)
    while mt do
        if mt == class then return true end
        mt = mt.super or mt.__index
    end
    return false
end
_G.generate_uuid = function ()
    return string.format("%s-%s-%s-%s-%s",
        random_hex(8),
        random_hex(4),
        random_hex(4),
        random_hex(4),
        random_hex(12)
    )
end
_G.get = function (table, key, default)
    if table[key] == nil then
        return default
    end
    return table[key]
end
_G.find_index = function (table, value)
    for i = 1, #table do
        if table[i] == value then
            return i
        end
    end
    return nil
end
_G.clamp = function (v,mi,ma)
    return math.max(mi, math.min(ma, v))
end