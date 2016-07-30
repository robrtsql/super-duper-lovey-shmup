require 'util'
require 'assets'

Meteor = {}
Meteor.__index = Meteor

Meteor.sprite = assets:getImage("art/backgrounds/meteor-1.png")
Meteor.speed = 200
Meteor.y = -30

function Meteor.new(x)
    local self = {}
    setmetatable(self,Meteor)
    self.x = x
    return self
end

function Meteor:update(gamestate, dt, i)
    self.y = self.y + (self.speed * dt)
    if self.y > gamestate.height then
        table.remove(gamestate.meteors, i)
    end
end

function Meteor:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end
