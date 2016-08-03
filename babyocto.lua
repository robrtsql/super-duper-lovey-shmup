require 'util'
require 'assets'
require 'enemyshot'

BabyOcto = {}
BabyOcto.__index = BabyOcto

BabyOcto.sprite = assets:getImage("art/ships/10.png")
BabyOcto.speed = 100
BabyOcto.y = -25
BabyOcto.w = 27
BabyOcto.h = 25
BabyOcto.type = "babyocto"
BabyOcto.shottimer = 0.25

--flags
BabyOcto.will_destroy = false
BabyOcto.will_explode = false

function BabyOcto.new(gamestate, x)
    local self = {}
    setmetatable(self,BabyOcto)
    self.gamestate = gamestate
    self.x = x
    self.gamestate.world:add(self, self.x, self.y, self.w, self.h)
    return self
end

function BabyOcto:update(dt, i)
    local goalY = self.y + (self.speed * dt)

    local actualX, actualY, cols, len = self.gamestate.world:move(self, self.x,
        goalY, self.bump_filter)
    self.x = actualX
    self.y = actualY

    for i=1,len do
        local other = cols[i].other
        if other.type == "player" and not other.will_destroy then
            other:destroy()
            self.will_destroy = true
            self:explode()
            break
        end
    end

    self.shottimer = self.shottimer - dt
    if self.shottimer < 0 then
        table.insert(self.gamestate.bads,
            EnemyShot.new(self.gamestate, self.x, self.y))
        self.shottimer = (love.math.random(20) + 20) / 20
    end

    if self.y > self.gamestate.height then
        self.will_destroy = true
    end

    if self.will_explode then
        self:_explode()
    end

    if self.will_destroy then
        self:_destroy(i)
    end

    self.will_destroy = false
end

function BabyOcto:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function BabyOcto:explode()
    self.will_explode = true
    self.will_destroy = true
end

function BabyOcto:_explode()
    table.insert(self.gamestate.fx, Explosion.new(self.gamestate,
        self.x + 8, self.y + 4))
end

function BabyOcto:_destroy(i)
    table.remove(self.gamestate.bads, i)
    self.gamestate.world:remove(self)
end

function BabyOcto:bump_filter(other)
    return "cross"
end
