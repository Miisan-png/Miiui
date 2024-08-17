-- MiiuiWidgets.lua
local MiiuiWidgets = {}

local Core
local Utils
local Theme

function MiiuiWidgets.init(core, utils)
    Core = core
    Utils = utils
    Theme = Core.getTheme()
end

function MiiuiWidgets.panel(x, y, w, h, content)
    love.graphics.push('all')
    love.graphics.setColor(Theme.colors.panel)
    love.graphics.rectangle("fill", x, y, w, h, 10, 10)
    love.graphics.setColor(Theme.colors.panelBorder)
    love.graphics.rectangle("line", x, y, w, h, 10, 10)
    
    love.graphics.translate(x, y)
    love.graphics.intersectScissor(x, y, w, h)
    
    local prevPanel = {x = Core.state.currentPanel.x, y = Core.state.currentPanel.y}
    Core.state.currentPanel = {x = x, y = y}
    
    content()
    
    Core.state.currentPanel = prevPanel
    
    love.graphics.pop()
end

function MiiuiWidgets.progressBar(x, y, w, h, value, options)
    options = options or {}
    local min = options.min or 0
    local max = options.max or 1
    local color = options.color or {0.2, 0.7, 0.2}
    local backgroundColor = options.backgroundColor or {0.2, 0.2, 0.2}
    local borderColor = options.borderColor or {0.5, 0.5, 0.5}
    local showPercentage = options.showPercentage or false
    local vertical = options.vertical or false
    local interactive = options.interactive or false

    value = math.max(min, math.min(max, value))

    local fillAmount = (value - min) / (max - min)

    if interactive then
        local mx, my = Core.state.mouseX - Core.state.currentPanel.x, Core.state.mouseY - Core.state.currentPanel.y
        if Utils.pointInRect(mx, my, x, y, w, h) then
            if Core.state.mousePressed then
                local newFillAmount
                if vertical then
                    newFillAmount = 1 - (my - y) / h
                else
                    newFillAmount = (mx - x) / w
                end
                value = min + newFillAmount * (max - min)
                value = math.max(min, math.min(max, value))
            end
        end
    end

    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle("fill", x, y, w, h)

    love.graphics.setColor(color)
    if vertical then
        local fillHeight = h * fillAmount
        love.graphics.rectangle("fill", x, y + h - fillHeight, w, fillHeight)
    else
        local fillWidth = w * fillAmount
        love.graphics.rectangle("fill", x, y, fillWidth, h)
    end

    love.graphics.setColor(borderColor)
    love.graphics.rectangle("line", x, y, w, h)

    if showPercentage then
        love.graphics.setColor(1, 1, 1)
        local percentage = math.floor(fillAmount * 100)
        love.graphics.printf(percentage .. "%", x, y + h/2 - 7, w, "center")
    end

    return value
end


function MiiuiWidgets.button(x, y, w, h, text)
    local itemId = "button" .. x .. y
    local clicked = false
    
    local mx, my = Core.state.mouseX - Core.state.currentPanel.x, Core.state.mouseY - Core.state.currentPanel.y
    local hovered = Utils.pointInRect(mx, my, x, y, w, h)
    
    if hovered then
        Core.state.hotItem = itemId
        if Core.state.activeItem == nil and Core.state.mousePressed then
            Core.state.activeItem = itemId
        end
    end
    
    local scale = Core.animate(itemId .. "_scale", hovered and 1.05 or 1, 0.1)
    
    love.graphics.push()
    love.graphics.translate(x + w/2, y + h/2)
    love.graphics.scale(scale, scale)
    
    if Core.state.hotItem == itemId then
        if Core.state.activeItem == itemId then
            love.graphics.setColor(Theme.colors.buttonActive)
        else
            love.graphics.setColor(Theme.colors.buttonHover)
        end
    else
        love.graphics.setColor(Theme.colors.button)
    end
    
    love.graphics.rectangle("fill", -w/2, -h/2, w, h, Theme.sizes.buttonRadius, Theme.sizes.buttonRadius)
    love.graphics.setColor(Theme.colors.panelBorder)
    love.graphics.rectangle("line", -w/2, -h/2, w, h, Theme.sizes.buttonRadius, Theme.sizes.buttonRadius)
    love.graphics.setColor(Theme.colors.text)
    love.graphics.printf(text, -w/2, -h/2 + h/2 - 10, w, "center")
    
    love.graphics.pop()
    
    if not Core.state.mousePressed and 
       Core.state.hotItem == itemId and 
       Core.state.activeItem == itemId then
        clicked = true
    end
    
    return clicked
end

function MiiuiWidgets.slider(x, y, w, value, min, max)
    local itemId = "slider" .. x .. y
    local changed = false
    local h = Theme.sizes.sliderHeight
    
    local mx, my = Core.state.mouseX - Core.state.currentPanel.x, Core.state.mouseY - Core.state.currentPanel.y
    if Utils.pointInRect(mx, my, x, y - Theme.sizes.sliderHandleRadius, w, h + Theme.sizes.sliderHandleRadius * 2) then
        Core.state.hotItem = itemId
        if Core.state.activeItem == nil and Core.state.mousePressed then
            Core.state.activeItem = itemId
        end
    end
    
    if Core.state.activeItem == itemId then
        local mousePos = (mx - x) / w
        value = min + (max - min) * mousePos
        value = math.max(min, math.min(max, value))
        changed = true
    end
    
    love.graphics.setColor(Theme.colors.slider)
    love.graphics.rectangle("fill", x, y, w, h, Theme.sizes.sliderRadius, Theme.sizes.sliderRadius)
    
    local handleX = x + (value - min) / (max - min) * w
    if Core.state.hotItem == itemId then
        love.graphics.setColor(Theme.colors.sliderHandleHover)
    else
        love.graphics.setColor(Theme.colors.sliderHandle)
    end
    love.graphics.circle("fill", handleX, y + h/2, Theme.sizes.sliderHandleRadius)
    love.graphics.setColor(Theme.colors.panelBorder)
    love.graphics.circle("line", handleX, y + h/2, Theme.sizes.sliderHandleRadius)
    
    return value, changed
end

function MiiuiWidgets.checkbox(x, y, checked, text)
    local itemId = "checkbox" .. x .. y
    local size = Theme.sizes.checkboxSize
    local changed = false
    
    local mx, my = Core.state.mouseX - Core.state.currentPanel.x, Core.state.mouseY - Core.state.currentPanel.y
    if Utils.pointInRect(mx, my, x, y, size, size) then
        Core.state.hotItem = itemId
        if Core.state.activeItem == nil and Core.state.mousePressed then
            Core.state.activeItem = itemId
        end
    end
    
    love.graphics.setColor(Theme.colors.checkbox)
    love.graphics.rectangle("fill", x, y, size, size, Theme.sizes.checkboxRadius, Theme.sizes.checkboxRadius)
    love.graphics.setColor(Theme.colors.panelBorder)
    love.graphics.rectangle("line", x, y, size, size, Theme.sizes.checkboxRadius, Theme.sizes.checkboxRadius)
    
    if checked then
        love.graphics.setColor(Theme.colors.checkboxChecked)
        love.graphics.rectangle("fill", x + 4, y + 4, size - 8, size - 8, Theme.sizes.checkboxRadius - 1, Theme.sizes.checkboxRadius - 1)
    end
    
    love.graphics.setColor(Theme.colors.text)
    love.graphics.print(text, x + size + 10, y + size/2 - 7)
    
    if not Core.state.mousePressed and 
       Core.state.hotItem == itemId and 
       Core.state.activeItem == itemId then
        checked = not checked
        changed = true
    end
    
    return checked, changed
end

function MiiuiWidgets.label(x, y, text, options)
    options = options or {}
    local fontSize = options.fontSize or 14
    local color = options.color or Theme.colors.text
    local align = options.align or "left"
    local width = options.width or love.graphics.getWidth()

    love.graphics.setColor(color)
    love.graphics.setFont(love.graphics.newFont(fontSize))
    love.graphics.printf(text, x, y, width, align)
end

function MiiuiWidgets.textInput(x, y, w, h, value, placeholder)
    local itemId = "textInput" .. x .. y
    local changed = false
    
    if Utils.pointInRect(Core.state.mouseX, Core.state.mouseY, x, y, w, h) and Core.state.mousePressed then
        Core.setFocus(itemId)
    end
    
    if Core.state.focusedItem == itemId then
        value = value .. Core.state.keyboardInput
        if Core.isKeyPressed("backspace") then
            value = value:sub(1, -2)
        end
        changed = true
    end
    
    love.graphics.setColor(Theme.colors.textInput)
    love.graphics.rectangle("fill", x, y, w, h, Theme.sizes.textInputRadius)
    love.graphics.setColor(Theme.colors.text)
    love.graphics.printf(value ~= "" and value or placeholder, x + 5, y + 5, w - 10, "left")
    
    if Core.state.focusedItem == itemId then
        love.graphics.setColor(Theme.colors.textInputFocus)
        love.graphics.rectangle("line", x, y, w, h, Theme.sizes.textInputRadius)
    end
    
    return value, changed
end

return MiiuiWidgets