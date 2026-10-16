local Components = {}

function Components.Position(x, y)
    return {x = x or 0, y = y or 0}
end

function Components.Movement(dx, dy)
    return {dx = dx or 0, dy = dy or 0}
end

function Components.Renderer(color, size)
    return {
        color = color or {1, 1, 1},
        size = size or 20
    }
end

return Components