require 'util'
require 'assets'

Meteor = {}
Meteor.__index = Meteor

Meteor.sprite = assets:getImage("art/backgrounds/meteor-1.png")
Meteor.speed = 200
Meteor.y = -30
Meteor.w = 42
Meteor.h = 39
Meteor.type = "meteor"

--flags
Meteor.will_destroy = false
Meteor.will_explode = false

function Meteor.new(gamestate, x)
    local self = {}
    setmetatable(self,Meteor)
    self.gamestate = gamestate
    self.x = x
    self.gamestate.world:add(self, self.x, self.y, self.w, self.h)
    return self
end

function Meteor:update(dt, i)
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

function Meteor:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function Meteor:explode()
    self.will_explode = true
    self.will_destroy = true
end

function Meteor:_explode()
    table.insert(self.gamestate.fx, Explosion.new(self.gamestate,
        self.x + 8, self.y + 4))
end

function Meteor:_destroy(i)
    table.remove(self.gamestate.meteors, i)
    self.gamestate.world:remove(self)
end

function Meteor:bump_filter(other)
    return "cross"
end
