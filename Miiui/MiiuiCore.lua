-- MiiuiCore.lua
local MiiuiCore = {}
local MiiuiTween = require "MiiuiTween"

MiiuiCore.state = {
    mouseX = 0,
    mouseY = 0,
    mousePressed = false,
    hotItem = nil,
    activeItem = nil,
    time = 0,
    animations = {},
    currentPanel = {x = 0, y = 0},
    zIndex = 0,
    focusedItem = nil,
    keyboardInput = "",
    lastClickTime = 0,
    doubleClickThreshold = 0.3,
    keyStates = {}
}

local Utils
local Theme

function MiiuiCore.init(utils, theme)
    Utils = utils
    Theme = theme
end

function MiiuiCore.begin()
    MiiuiCore.state.mouseX, MiiuiCore.state.mouseY = love.mouse.getPosition()
    MiiuiCore.state.mousePressed = love.mouse.isDown(1)
    MiiuiCore.state.hotItem = nil
    MiiuiCore.state.time = love.timer.getTime()
    MiiuiCore.state.currentPanel = {x = 0, y = 0}
    MiiuiCore.state.zIndex = 0
    MiiuiCore.state.keyboardInput = ""
end

function MiiuiCore.end_frame()
    if not MiiuiCore.state.mousePressed then
        MiiuiCore.state.activeItem = nil
    elseif MiiuiCore.state.activeItem == nil then
        MiiuiCore.state.activeItem = "background"
    end
    MiiuiCore.state.keyboardInput = ""
end

function MiiuiCore.update(dt)
    MiiuiTween.update(dt)
    for k, v in pairs(MiiuiCore.state.animations) do
        local t = math.min(1, (MiiuiCore.state.time - v.startTime) / v.duration)
        v.current = Utils.lerp(v.start, v.target, t * t * (3 - 2 * t))
        if t == 1 then
            MiiuiCore.state.animations[k] = nil
        end
    end
end

function MiiuiCore.animate(key, target, duration)
    local anim = MiiuiCore.state.animations[key]
    if not anim then
        anim = {current = target, start = target, target = target, startTime = MiiuiCore.state.time, duration = duration}
    elseif anim.target ~= target then
        anim.start = anim.current
        anim.target = target
        anim.startTime = MiiuiCore.state.time
        anim.duration = duration
    end
    MiiuiCore.state.animations[key] = anim
    return anim.current
end

function MiiuiCore.setFocus(itemId)
    MiiuiCore.state.focusedItem = itemId
end

function MiiuiCore.isDoubleClick()
    local currentTime = love.timer.getTime()
    local isDouble = currentTime - MiiuiCore.state.lastClickTime < MiiuiCore.state.doubleClickThreshold
    MiiuiCore.state.lastClickTime = currentTime
    return isDouble
end

function MiiuiCore.textinput(text)
    MiiuiCore.state.keyboardInput = MiiuiCore.state.keyboardInput .. text
end

function MiiuiCore.keypressed(key)
    MiiuiCore.state.keyStates[key] = true
end

function MiiuiCore.keyreleased(key)
    MiiuiCore.state.keyStates[key] = nil
end

function MiiuiCore.isKeyPressed(key)
    return MiiuiCore.state.keyStates[key] ~= nil
end

function MiiuiCore.getTheme()
    return Theme
end

return MiiuiCore