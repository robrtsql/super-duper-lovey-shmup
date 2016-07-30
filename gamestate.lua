require 'util'
require 'assets'
require 'player'
require 'shot'

GameState = {}
GameState.__index = GameState

function GameState.new()
    local self = {}
    setmetatable(self,GameState)
    return self
end

function GameState:load()
    love.window.setMode(640, 480)
    bg = assets:getImage("art/backgrounds/1.png")
    player = Player.new()
    self.shots = {}
end

function GameState:update(dt)
    player:update(self, dt)
    for i=1, table.getn(self.shots) do
        self.shots[i]:update(self, dt)
    end
end

function GameState:draw()
    love.graphics.draw(bg, 0, 0)
    player:draw()
    for i=1, table.getn(self.shots) do
        self.shots[i]:draw()
    end
end

function GameState.keypressed(key, scancode, isrepeat)
    if not isrepeat then
        if key == "," then
            player:fire()
        end
    end
end
