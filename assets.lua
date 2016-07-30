assets = {}

function assets:getImage(assetName)
    local asset = self[asset]
    if asset == nil then
        asset = love.graphics.newImage(assetName)
        self[assetName] = asset
    end
    return asset
end

function assets:getSound(assetName)
    local asset = self[asset]
    if asset == nil then
        asset = love.audio.newSource(assetName)
        self[assetName] = asset
    end
    return asset
end
