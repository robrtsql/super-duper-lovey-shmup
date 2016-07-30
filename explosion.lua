require 'util'
require 'assets'
local anim8 = require 'anim8'

Explosion = {}
Explosion.__index = Explosion

Explosion.sheet = assets:getImage("art/effects/fx-3.png")
Explosion.grid = anim8.newGrid(30, 30, 180, 30)
Explosion.anim = anim8.newAnimation(Explosion.grid('1-5',1), 0.1, "pauseAtEnd")
Explosion.timer = 0.5
Explosion.sound = assets:getSound("sounds/explode.wav")

function Explosion.new(gamestate, x, y)
    local self = {}
    setmetatable(self,Explosion)
    self.gamestate = gamestate
    self.x = x
    self.y = y
    self.anim = self.anim:clone()
    Explosion.sound:stop()
    Explosion.sound:play()
    return self
end

function Explosion:update(dt, i)
    self.anim:update(dt)

    self.timer = self.timer - dt

    if self.timer < 0 then
        self:_destroy(i)
    end
end

function Explosion:draw()
    self.anim:draw(self.sheet, round(self.x), round(self.y))
end

function Explosion:_destroy(i)
    table.remove(self.gamestate.fx, i)
end
