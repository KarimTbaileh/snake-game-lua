local Events = {}
local listeners = {}

function Events:subscribe(event, callback)
    if not listeners[event] then
        listeners[event] = {}
    end
    table.insert(listeners[event], callback)
end

function Events:emit(event, data)
    if listeners[event] then
        for _, callback in ipairs(listeners[event]) do
            callback(data)
        end
    end
end

function Events:unsubscribe(event, callback)
    if listeners[event] then
        for i, cb in ipairs(listeners[event]) do
            if cb == callback then
                table.remove(listeners[event], i)
                break
            end
        end
    end
end

return Events