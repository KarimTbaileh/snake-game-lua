
local Input = require("input")
local Events = require("events")
local HighScore = require("highscore")
local MenuState = require("states.menu_state")
local GamePlayState = require("states.game_state")

local gameState
local input
local menuState
local playState

function love.load()
    love.window.setMode(600, 600)
    love.window.setTitle("Snake Game")
    
    menuState = MenuState
    playState = GamePlayState:new()
    
    gameState = {
        current = "menu",
        states = {
            menu = menuState,
            playing = playState
        }
    }
    
    input = Input:new()
    
    input:bind("space", function()
        if gameState.current == "menu" then
            gameState.current = "playing"
            print("Switched to: playing")
        elseif gameState.current == "playing" then
            local game = playState.game
            if game.gameOver then
                game:reset()
            end
        end
    end)
    
    input:bind("escape", function()
        if gameState.current == "playing" then
            gameState.current = "menu"
            print("Switched to: menu")
        else
            love.event.quit()
        end
    end)
    
    input:bind("up", function()
        if gameState.current == "playing" then
            playState.game:changeDirection(0, -1)
        end
    end)
    
    input:bind("down", function()
        if gameState.current == "playing" then
            playState.game:changeDirection(0, 1)
        end
    end)
    
    input:bind("left", function()
        if gameState.current == "playing" then
            playState.game:changeDirection(-1, 0)
        end
    end)
    
    input:bind("right", function()
        if gameState.current == "playing" then
            playState.game:changeDirection(1, 0)
        end
    end)
    
    Events:subscribe("food_eaten", function(data)
        print("Food eaten! Score: " .. data.score)
    end)
    
    Events:subscribe("game_over", function(data)
        print("Game Over! Final score: " .. data.score)
        local highScore = HighScore:load()
        if data.score > highScore then
            HighScore:save(data.score)
            print("New high score: " .. data.score)
        end
    end)
    
    print("=== Game Loaded ===")
end

function love.update(dt)
    if gameState.current == "menu" then
        if menuState.update then menuState:update(dt) end
    elseif gameState.current == "playing" then
        playState:update(dt)
    end
end

function love.draw()
    if gameState.current == "menu" then
        menuState:draw()
    elseif gameState.current == "playing" then
        playState:draw()
    end
end

function love.keypressed(key)
    input:handleKey(key)
end