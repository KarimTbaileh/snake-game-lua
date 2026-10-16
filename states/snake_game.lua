local SnakeGame = {}
SnakeGame.__index = SnakeGame

local Events = require("events")

local GRID = 20
local CELL = 30
local STEP_TIME = 0.12
local READY_TIME = 3

function SnakeGame:new()
    local game = {
        snake = {},
        direction = {x = 1, y = 0},
        nextDirection = {x = 1, y = 0},
        food = {x = 15, y = 15},
        score = 0,
        gameOver = false,
        timer = 0,
        gridSize = GRID,
        cellSize = CELL,
        stepTime = STEP_TIME,
        ready = false,
        readyTimer = 0,
        readyTime = READY_TIME
    }
    setmetatable(game, SnakeGame)
    game:reset()
    return game
end

function SnakeGame:reset()
    self.snake = {
        {x = 10, y = 10},
        {x = 9,  y = 10},
        {x = 8,  y = 10}
    }
    self.direction = {x = 1, y = 0}
    self.nextDirection = {x = 1, y = 0}
    self.score = 0
    self.gameOver = false
    self.timer = 0
    self.ready = false
    self.readyTimer = 0
    self:spawnFood()
end

function SnakeGame:spawnFood()
    while true do
        local x = love.math.random(0, self.gridSize - 1)
        local y = love.math.random(0, self.gridSize - 1)
        
        local free = true
        for _, seg in ipairs(self.snake) do
            if seg.x == x and seg.y == y then
                free = false
                break
            end
        end
        
        if free then
            self.food = {x = x, y = y}
            return
        end
    end
end

function SnakeGame:move()
    self.direction = self.nextDirection
    
    local head = self.snake[1]
    local newHead = {
        x = head.x + self.direction.x,
        y = head.y + self.direction.y
    }
    
    if newHead.x < 0 or newHead.x >= self.gridSize or 
       newHead.y < 0 or newHead.y >= self.gridSize then
        self.gameOver = true
        Events:emit("game_over", {score = self.score})
        return
    end
    
    for _, seg in ipairs(self.snake) do
        if seg.x == newHead.x and seg.y == newHead.y then
            self.gameOver = true
            Events:emit("game_over", {score = self.score})
            return
        end
    end
    
    table.insert(self.snake, 1, newHead)
    
    if newHead.x == self.food.x and newHead.y == self.food.y then
        self.score = self.score + 1
        self:spawnFood()
        Events:emit("food_eaten", {score = self.score})
    else
        table.remove(self.snake)
    end
end

function SnakeGame:update(dt)
    if self.gameOver then return end
    
    if not self.ready then
        self.readyTimer = self.readyTimer + dt
        if self.readyTimer >= self.readyTime then
            self.ready = true
        end
        return
    end
    
    self.timer = self.timer + dt
    if self.timer >= self.stepTime then
        self.timer = self.timer - self.stepTime
        self:move()
    end
end

function SnakeGame:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.12)
    
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.rectangle("fill", 
        self.food.x * self.cellSize, 
        self.food.y * self.cellSize, 
        self.cellSize - 2, 
        self.cellSize - 2)
    
    for i, seg in ipairs(self.snake) do
        if i == 1 then
            love.graphics.setColor(0.5, 1, 0.6)
        else
            love.graphics.setColor(0.3, 0.8, 0.4)
        end
        love.graphics.rectangle("fill", 
            seg.x * self.cellSize, 
            seg.y * self.cellSize, 
            self.cellSize - 2, 
            self.cellSize - 2)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. self.score, 10, 10)
    
    if not self.ready then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 
            self.gridSize * self.cellSize, 
            self.gridSize * self.cellSize)
        
        love.graphics.setColor(1, 1, 1)
        local countdown = math.ceil(self.readyTime - self.readyTimer)
        love.graphics.printf(
            "Get Ready!\n" .. countdown,
            0, (self.gridSize * self.cellSize) / 2 - 40, 
            self.gridSize * self.cellSize, 
            "center"
        )
        return
    end
    
    if self.gameOver then
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 0, 0, 
            self.gridSize * self.cellSize, 
            self.gridSize * self.cellSize)
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(
            "GAME OVER\nScore: " .. self.score .. "\nPress SPACE to restart",
            0, (self.gridSize * self.cellSize) / 2 - 40, 
            self.gridSize * self.cellSize, 
            "center"
        )
    end
end

function SnakeGame:changeDirection(dx, dy)
    if self.direction.x + dx == 0 and self.direction.y + dy == 0 then
        return
    end
    self.nextDirection = {x = dx, y = dy}
end

function SnakeGame:keypressed(key)
    if self.gameOver then
        if key == "space" or key == "return" then
            self:reset()
        end
        return
    end
    
    if key == "up" or key == "w" then
        self:changeDirection(0, -1)
    elseif key == "down" or key == "s" then
        self:changeDirection(0, 1)
    elseif key == "left" or key == "a" then
        self:changeDirection(-1, 0)
    elseif key == "right" or key == "d" then
        self:changeDirection(1, 0)
    end
end

return SnakeGame