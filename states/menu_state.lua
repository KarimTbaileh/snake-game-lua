local MenuState = {}

function MenuState:update(dt)
end

function MenuState:draw()
    love.graphics.setBackgroundColor(0.1, 0.1, 0.15)
    
    love.graphics.setColor(0.3, 0.9, 0.4)
    love.graphics.printf(" SNAKE GAME", 0, 200, 600, "center")
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Press SPACE to Start", 0, 300, 600, "center")
    love.graphics.printf("Press ESC to Quit", 0, 350, 600, "center")
end

function MenuState:keypressed(key)
    if key == "space" then
        return "playing"
    elseif key == "escape" then
        love.event.quit()
    end
end

return MenuState