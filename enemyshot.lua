require 'util'
require 'assets'
require 'explosion'

EnemyShot = {}
EnemyShot.__index = EnemyShot

EnemyShot.sprite = assets:getImage("art/shots/13.png")
EnemyShot.speed = 350
EnemyShot.w = 12
EnemyShot.h = 17
EnemyShot.type = "enemyshot"

--flags
EnemyShot.will_destroy = false

function EnemyShot.new(gamestate, x, y)
    local self = {}
    setmetatable(self,EnemyShot)
    self.gamestate = gamestate
    self.x = x
    self.y = y
    self.gamestate.world:add(self, self.x, self.y, self.w, self.h)
    return self
end

function EnemyShot:update(dt, i)
    local goalY = self.y + (self.speed * dt)

    local actualX, actualY, cols, len = self.gamestate.world:move(self, self.x,
        goalY, self.bump_filter)
    self.x = actualX
    self.y = actualY

    for i=1,len do
        local other = cols[i].other
        if other.type == "player" then
            if not other.will_destroy then
                other:destroy()
                self.will_destroy = true
                break
            end
        end
    end

    if self.y > self.gamestate.height then
        self.will_destroy = true
    end

    if self.will_destroy then
        self:_destroy(i)
    end

    self.will_destroy = false
end

function EnemyShot:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function EnemyShot:fire()
    player.fire = true
end

function EnemyShot:_destroy(i)
    table.remove(self.gamestate.bads, i)
    self.gamestate.world:remove(self)
end

function EnemyShot:bump_filter(other)
    return "cross"
end
