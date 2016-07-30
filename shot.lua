require 'util'
require 'assets'
require 'explosion'

Shot = {}
Shot.__index = Shot

Shot.sprite = assets:getImage("art/shots/3.png")
Shot.speed = 350
Shot.w = 8
Shot.h = 17
Shot.type = "shot"

--flags
Shot.will_destroy = false

function Shot.new(gamestate, x, y)
    local self = {}
    setmetatable(self,Shot)
    self.gamestate = gamestate
    self.x = x
    self.y = y
    self.gamestate.world:add(self, self.x, self.y, self.w, self.h)
    return self
end

function Shot:update(dt, i)
    local goalY = self.y - (self.speed * dt)

    local actualX, actualY, cols, len = self.gamestate.world:move(self, self.x,
        goalY, self.bump_filter)
    self.x = actualX
    self.y = actualY

    for i=1,len do
        local other = cols[i].other
        if other.type == "meteor" and not other.will_destroy then
            other:explode()
            self.will_destroy = true
            break
        end
    end

    if self.y < 0 then
        self.will_destroy = true
    end

    if self.will_destroy then
        self:_destroy(i)
    end

    self.will_destroy = false
end

function Shot:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function Shot:fire()
    player.fire = true
end

function Shot:_destroy(i)
    table.remove(self.gamestate.shots, i)
    self.gamestate.world:remove(self)
end

function Shot:bump_filter(other)
    return "cross"
end
