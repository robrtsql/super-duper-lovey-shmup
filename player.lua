require 'util'
require 'assets'
require 'shot'

Player = {}
Player.__index = Player

Player.sprite = assets:getImage("art/ships/2.png")
Player.x = 0
Player.y = 0
Player.speed = 200
Player.firing = false

function Player.new()
    local self = {}
    setmetatable(self,Player)
    return self
end

function Player:update(gamestate, dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - (self.speed * dt)
    elseif love.keyboard.isDown("s") then
        self.y = self.y + (self.speed * dt)
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - (self.speed * dt)
    elseif love.keyboard.isDown("d") then
        self.x = self.x + (self.speed * dt)
    end

    if self.firing then
        table.insert(gamestate.shots, Shot.new(self.x + 3, self.y))
        table.insert(gamestate.shots, Shot.new(self.x + 27, self.y))
    end

    self.firing = false
end

function Player:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function Player:fire()
    self.firing = true
end
