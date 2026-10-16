local SnakeGame = require("states.snake_game")

local GameState = {}
GameState.__index = GameState

function GameState:new()
    local state = {
        game = SnakeGame:new()
    }
    return setmetatable(state, GameState)
end

function GameState:update(dt)
    self.game:update(dt)
end

function GameState:draw()
    self.game:draw()
end

function GameState:keypressed(key)
    if key == "escape" then
        return "menu"
    end
    self.game:keypressed(key)
end

return GameState