require 'util'
require 'assets'
require 'player'
require 'shot'
require 'meteor'
local bump = require 'bump'

GameState = {}
GameState.__index = GameState
GameState.timer = 1
GameState.players = {}
GameState.shots = {}
GameState.meteors = {}
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
    self.timer = self.timer - dt
    if self.timer < 0 then
        local spawnmultiple = love.math.random(10)
        if spawnmultiple > 9 then
            table.insert(self.meteors, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        end
        if spawnmultiple > 8 then
            table.insert(self.meteors, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        end
        table.insert(self.meteors, Meteor.new(self, love.math.random(self.width - Meteor.w)))
        self.timer = 0.5
    end

    for i=table.getn(self.players),1,-1 do
        self.players[i]:update(dt, i)
    end
    for i=table.getn(self.shots),1,-1 do
        self.shots[i]:update(dt, i)
    end
    for i=table.getn(self.meteors),1,-1 do
        self.meteors[i]:update(dt, i)
    end
    for i=table.getn(self.fx),1,-1 do
        self.fx[i]:update(dt, i)
    end
end

function GameState:draw()
    love.graphics.draw(bg, 0, 0)
    for i=1, table.getn(self.players) do
        self.players[i]:draw()
    end
    for i=1, table.getn(self.shots) do
        self.shots[i]:draw()
    end
    for i=table.getn(self.meteors),1,-1 do
        self.meteors[i]:draw()
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
