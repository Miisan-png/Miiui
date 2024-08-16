local MiiuiTween = {}

local tweens = {}

local easing = {
    linear = function(t) return t end,
    quadIn = function(t) return t * t end,
    quadOut = function(t) return 1 - (1 - t) * (1 - t) end,
    quadInOut = function(t)
        if t < 0.5 then return 2 * t * t else return 1 - (-2 * t + 2)^2 / 2 end
    end,
}

local function lerp(a, b, t)
    if type(a) == "number" and type(b) == "number" then
        return a + (b - a) * t
    elseif type(a) == "table" and type(b) == "table" then
        local result = {}
        for k, v in pairs(a) do
            if b[k] then
                result[k] = lerp(v, b[k], t)
            else
                result[k] = v
            end
        end
        return result
    end
    return b
end

function MiiuiTween.create(object, properties, target, duration, easingType)
    if type(object) ~= "table" then
        print("Error: Invalid object for tween")
        return
    end

    local tween = {
        object = object,
        properties = type(properties) == "table" and properties or {properties},
        start = {},
        target = type(target) == "table" and target or {[properties] = target},
        duration = duration,
        easingFunc = easing[easingType] or easing.linear,
        time = 0,
        complete = false
    }

    for _, prop in ipairs(tween.properties) do
        if object[prop] == nil then
            print("Error: Invalid property '" .. prop .. "' for tween")
            return
        end
        tween.start[prop] = object[prop]
    end

    table.insert(tweens, tween)
    return tween
end

function MiiuiTween.update(dt)
    for i = #tweens, 1, -1 do
        local tween = tweens[i]
        if not tween.complete then
            tween.time = tween.time + dt
            local t = math.min(tween.time / tween.duration, 1)
            local easedT = tween.easingFunc(t)

            for _, prop in ipairs(tween.properties) do
                tween.object[prop] = lerp(tween.start[prop], tween.target[prop], easedT)
            end

            if t == 1 then
                tween.complete = true
            end
        else
            table.remove(tweens, i)
        end
    end
end

-- Shorthand functions for common transformations
function MiiuiTween.moveTo(object, x, y, duration, easingType)
    return MiiuiTween.create(object, {"x", "y"}, {x = x, y = y}, duration, easingType)
end

function MiiuiTween.scaleTo(object, sx, sy, duration, easingType)
    return MiiuiTween.create(object, {"scaleX", "scaleY"}, {scaleX = sx, scaleY = sy}, duration, easingType)
end

function MiiuiTween.rotateTo(object, angle, duration, easingType)
    return MiiuiTween.create(object, "rotation", angle, duration, easingType)
end

return MiiuiTween