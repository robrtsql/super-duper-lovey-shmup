require 'util'
require 'assets'
require 'shot'

Player = {}
Player.__index = Player

Player.sprite = assets:getImage("art/ships/2.png")
Player.fireSound = assets:getSound("sounds/2.wav")
Player.w = 38
Player.h = 34
Player.speed = 200

--flags
Player.firing = false

function Player.new(gamestate)
    local self = {}
    setmetatable(self,Player)
    self.x = gamestate.width / 2 - (self.w / 2)
    self.y = gamestate.height - (self.h * 2)
    self.gamestate = gamestate
    self.gamestate.world:add(self, self.x, self.y, self.w, self.h)
    return self
end

function Player:update(dt)
    local goalX = self.x
    local goalY = self.y
    if love.keyboard.isDown("w") then
        goalY = self.y - (self.speed * dt)
    elseif love.keyboard.isDown("s") then
        goalY = self.y + (self.speed * dt)
    end
    if love.keyboard.isDown("a") then
        goalX = self.x - (self.speed * dt)
    elseif love.keyboard.isDown("d") then
        goalX = self.x + (self.speed * dt)
    end

    local actualX, actualY, cols, len = self.gamestate.world:move(self, goalX,
        goalY, self.bump_filter)
    self.x = actualX
    self.y = actualY

    if self.firing then
        self:_fire()
    end

    self.firing = false
end

function Player:draw()
    love.graphics.draw(self.sprite, round(self.x), round(self.y))
end

function Player:fire()
    self.firing = true
end

function Player:_fire()
    self.fireSound:stop()
    self.fireSound:play()
    table.insert(self.gamestate.shots, Shot.new(self.gamestate, self.x + 3, self.y))
    table.insert(self.gamestate.shots, Shot.new(self.gamestate, self.x + 27, self.y))
end

function Player:bump_filter(other)
    return "cross"
end
