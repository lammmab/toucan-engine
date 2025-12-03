local Color = class("Color")
local MIN_COLOR = 0
local MAX_COLOR = 255

local MIN_ALPHA = 0
local MAX_ALPHA = 1

local function clamp_color_value(v)
    return clamp(v,MIN_COLOR,MAX_COLOR)
end

local function clamp_alpha_value(v)
    return clamp(v,MIN_ALPHA,MAX_ALPHA)
end

function Color:init(r,g,b,a)
    self.r = clamp_color_value(r)
    self.g = clamp_color_value(g)
    self.b = clamp_color_value(b)
    self.a = clamp_alpha_value(a or 1)
end

function Color:copy()
    return Color:new(self.r,self.g,self.b,self.a)
end

function Color.__tostring()
    return string.format("Color(%f, %f, %f, %f)", self.r, self.g, self.b, self.a)
end

function Color.__add(a,b)
    return Color:new(
        clamp_color_value(a.r+b.r),
        clamp_color_value(a.g+b.g),
        clamp_color_value(a.b+b.b),
        clamp_alpha_value(a.a+b.a)
    )
end

function Color.__sub(a,b)
    return Color:new(
        clamp_color_value(a.r-b.r),
        clamp_color_value(a.g-b.g),
        clamp_color_value(a.b-b.b),
        clamp_alpha_value(a.a-b.a)
    )
end

function Color.from_hex(hex,alpha)
    hex = hex:gsub("#","")
    return Color:new(
        tonumber("0x" .. hex:sub(1,2)), 
        tonumber("0x" .. hex:sub(3,4)), 
        tonumber("0x" .. hex:sub(5,6)), 
        alpha
    )
end

function Color.__mul(a, b)
    if type(a) == "number" then
        return Color:new(
            clamp_color_value(a * b.r),
            clamp_color_value(a * b.g),
            clamp_color_value(a * b.b),
            clamp_alpha_value(a * b.a)
        )
    elseif type(b) == "number" then
        return Color:new(
            clamp_color_value(a.r * b),
            clamp_color_value(a.g * b),
            clamp_color_value(a.b * b),
            clamp_alpha_value(a.a * b)
        )
    else
        error("Multiplication only supports Color * number or number * Color")
    end
end

function Color:to_love()
    return self.r / 255, self.g / 255, self.b / 255, self.a
end

return {
    Color = Color,
    new_color3 = function(r,g,b,a) return Color:new(r,g,b,a) end,
    color3_from_hex = function(hex,alpha) return Color.from_hex(hex,alpha) end
}