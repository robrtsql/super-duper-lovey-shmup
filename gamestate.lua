require 'util'
require 'assets'
require 'player'
require 'shot'
require 'meteor'
require 'babyocto'
local bump = require 'bump'

GameState = {}
GameState.__index = GameState
GameState.meteortimer = 1
GameState.babyoctotimer = 1
GameState.players = {}
GameState.shots = {}
GameState.bads = {}
GameState.fx = {}
GameState.width = 640
GameState.height = 480

function GameState.new()
    local self = {}
    setmetatable(self,GameState)
    return self
end

function GameState:load()
    local mode = {}
    mode.vsync = true
    love.window.setMode(self.width, self.height, mode)
    bg = assets:getImage("art/backgrounds/1.png")
    self.world = bump.newWorld(32)
    table.insert(self.players, Player.new(self))
end

function GameState:update(dt)
    self:_update_spawn_meteors(dt)
    self:_update_spawn_babyoctos(dt)

    for i=table.getn(self.players),1,-1 do
        self.players[i]:update(dt, i)
    end
    for i=table.getn(self.shots),1,-1 do
        self.shots[i]:update(dt, i)
    end
    for i=table.getn(self.bads),1,-1 do
        self.bads[i]:update(dt, i)
    end
    for i=table.getn(self.fx),1,-1 do
        self.fx[i]:update(dt, i)
    end
end

function GameState:_update_spawn_meteors(dt)
    self.meteortimer = self.meteortimer - dt
    if self.meteortimer < 0 then
        local spawnmultiple = love.math.random(10)
        if spawnmultiple > 9 then
            table.insert(self.bads, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        end
        if spawnmultiple > 8 then
            table.insert(self.bads, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        end
        table.insert(self.bads, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        self.meteortimer = (love.math.random(4) + 4) / 10
    end
end

function GameState:_update_spawn_babyoctos(dt)
    self.babyoctotimer = self.babyoctotimer - dt
    if self.babyoctotimer < 0 then
        local spawnmultiple = love.math.random(10)
        if spawnmultiple > 9 then
            table.insert(self.bads, BabyOcto.new(self, love.math.random(self.width - BabyOcto.w)))
        end
        if spawnmultiple > 8 then
            table.insert(self.bads, BabyOcto.new(self, love.math.random(self.width - BabyOcto.w)))
        end
        table.insert(self.bads, BabyOcto.new(self, love.math.random(self.width - BabyOcto.w)))
        self.babyoctotimer = (love.math.random(4) + 4) / 10 
    end
end

function GameState:draw()
    love.graphics.draw(bg, 0, 0)
    for i=table.getn(self.players),1,-1 do
        self.players[i]:draw()
    end
    for i=table.getn(self.shots),1,-1 do
        self.shots[i]:draw()
    end
    for i=table.getn(self.bads),1,-1 do
        self.bads[i]:draw()
    end
    for i=table.getn(self.fx),1,-1 do
        self.fx[i]:draw()
    end
end

function GameState:keypressed(key, scancode, isrepeat)
    if not isrepeat then
        if key == "," then
            for i=1, table.getn(self.players) do
                self.players[i]:fire()
            end
        end
    end
end
