require 'util'
require 'assets'

Shot = {}
Shot.__index = Shot

Shot.sprite = assets:getImage("art/shots/3.png")
Shot.speed = 350

function Shot.new(x, y)
    local self = {}
    setmetatable(self,Shot)
    self.x = x
    self.y = y
    return self
end

function Shot:update(gamestate, dt, i)
    self.y = self.y - (self.speed * dt)
    if self.y < 0 then
        table.remove(gamestate.shots, i)
    end
end

function Shot:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function Shot:fire()
    player.fire = true
end
