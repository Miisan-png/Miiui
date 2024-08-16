local Miiui = require "Miiui"

local state = {
    showPanel = false,
    panelScale = {value = 0},
    sliderValue = 50,
    checkboxValue = false,
    textInputValue = "",
    dropdownOptions = {"Red", "Green", "Blue"},
    selectedDropdownIndex = 1,
    colorPreview = {1, 0, 0},
    counter = 0
}

function love.load()
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
end

function love.update(dt)
    Miiui.update(dt)
end

function love.draw()
    Miiui.begin()

    -- Left panel
    Miiui.panel(20, 20, 300, 560, function()
        Miiui.label(10, 10, "Miiui Widget Showcase", {fontSize = 20, align = "center", width = 280})

        -- Toggle button for side panel
        if Miiui.button(50, 50, 200, 40, state.showPanel and "Close Side Panel" or "Open Side Panel") then
            state.showPanel = not state.showPanel
            if state.showPanel then
                Miiui.tween.create(state.panelScale, "value", {value = 1}, 0.3, "quadOut")
            else
                Miiui.tween.create(state.panelScale, "value", {value = 0}, 0.3, "quadIn")
            end
        end

        -- Slider
        Miiui.label(50, 110, "Adjust Value:")
        state.sliderValue = Miiui.slider(50, 140, 200, state.sliderValue, 0, 100)
        Miiui.label(50, 170, "Value: " .. math.floor(state.sliderValue))

        -- Checkbox
        state.checkboxValue = Miiui.checkbox(50, 210, state.checkboxValue, "Enable Feature")

        -- Text input
        Miiui.label(50, 250, "Enter your name:")
        state.textInputValue = Miiui.textInput(50, 280, 200, 30, state.textInputValue, "Type here...")

        -- Dropdown
        Miiui.label(50, 330, "Select Color:")
        state.selectedDropdownIndex = Miiui.dropdown(50, 360, 200, state.dropdownOptions, state.selectedDropdownIndex)

        -- Color preview based on dropdown selection
        local colors = {{1,0,0}, {0,1,0}, {0,0,1}}
        state.colorPreview = colors[state.selectedDropdownIndex]
        love.graphics.setColor(state.colorPreview)
        love.graphics.rectangle("fill", 50, 410, 200, 40)

        -- Counter
        Miiui.label(50, 470, "Counter: " .. state.counter)
        if Miiui.button(50, 500, 90, 40, "-") then
            state.counter = state.counter - 1
        end
        if Miiui.button(160, 500, 90, 40, "+") then
            state.counter = state.counter + 1
        end
    end)

    -- Animated side panel
    if state.panelScale.value > 0 then
        love.graphics.push()
        love.graphics.translate(800, 0)
        love.graphics.scale(state.panelScale.value, 1)
        Miiui.panel(-250, 20, 230, 560, function()
            Miiui.label(0, 20, "Side Panel", {fontSize = 18, align = "center", width = 230})
            Miiui.label(20, 60, "This panel is animated!")
            
            -- Display state values
            Miiui.label(20, 100, "Slider: " .. math.floor(state.sliderValue))
            Miiui.label(20, 130, "Checkbox: " .. tostring(state.checkboxValue))
            Miiui.label(20, 160, "Text: " .. state.textInputValue)
            Miiui.label(20, 190, "Color: " .. state.dropdownOptions[state.selectedDropdownIndex])
            Miiui.label(20, 220, "Counter: " .. state.counter)
        end)
        love.graphics.pop()
    end

    Miiui.end_frame()
end

function love.keypressed(key)
    Miiui.keypressed(key)
end

function love.keyreleased(key)
    Miiui.keyreleased(key)
end

function love.textinput(text)
    Miiui.textinput(text)
end
