local Assets = { _loaded = {} }

local loaders = {
    png  = function(path) return love.graphics.newImage(path) end,
    jpg  = function(path) return love.graphics.newImage(path) end,
    tga  = function(path) return love.graphics.newImage(path) end,
    wav  = function(path) return love.audio.newSource(path, "static") end,
    ogg  = function(path) return love.audio.newSource(path, "stream") end,
    mp3  = function(path) return love.audio.newSource(path, "stream") end,
    ttf  = function(path) return love.graphics.newFont(path, 20) end,
    json = function(path)
        local data = love.filesystem.read(path)
        return Engine.JSON.decode(data)
    end
}

function Assets.get(path)
    if Assets._loaded[path] then
        return Assets._loaded[path]
    end

    local ext = path:match("^.+%.(.+)$")
    local loader = loaders[ext]
    assert(loader, "No loader for file extension: " .. tostring(ext))
    
    local asset = loader(path)
    Assets._loaded[path] = asset
    return asset
end

function Assets.clear()
    Assets._loaded = {}
end

return {
    get_asset = Assets.get,
    clear_assets = Assets.clear
}