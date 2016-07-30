require 'util'
require 'assets'
require 'player'
require 'shot'
require 'meteor'

GameState = {}
GameState.__index = GameState
GameState.timer = 1
GameState.shots = {}
GameState.meteors = {}
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
    player = Player.new()
end

function GameState:update(dt)
    self.timer = self.timer - dt
    if self.timer < 0 then
        table.insert(self.meteors, Meteor.new(love.math.random(self.width)))
        self.timer = 1
    end

    player:update(self, dt)
    for i=table.getn(self.shots),1,-1 do
        self.shots[i]:update(self, dt, i)
    end
    for i=table.getn(self.meteors),1,-1 do
        self.meteors[i]:update(self, dt, i)
    end
end

function GameState:draw()
    love.graphics.draw(bg, 0, 0)
    player:draw()
    for i=1, table.getn(self.shots) do
        self.shots[i]:draw()
    end
    for i=table.getn(self.meteors),1,-1 do
        self.meteors[i]:draw()
    end
end

function GameState.keypressed(key, scancode, isrepeat)
    if not isrepeat then
        if key == "," then
            player:fire()
        end
    end
end
