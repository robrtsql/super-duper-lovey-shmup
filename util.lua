function round(num)
    return math.floor(num + 0.5)
end

function clamp(val, min, max)
    if min > max then
        return nil
    elseif val > max then
        return max
    elseif val < min then
        return min
    else
        return val
    end
end
