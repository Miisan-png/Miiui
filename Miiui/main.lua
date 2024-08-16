
-- main.lua
local Miiui = require "Miiui/Miiui"

local showPanel = false
local panelScale = {value = 0}
local sliderValue = 50
local checkboxValue = false
local textInputValue = ""
local dropdownOptions = {"Option 1", "Option 2", "Option 3"}
local selectedDropdownIndex = 1

function love.load()
    love.window.setMode(800, 600)
end

function love.update(dt)
    Miiui.update(dt)
end

function love.draw()
    love.graphics.clear(0.1, 0.1, 0.1)
    
    Miiui.begin()

    -- Button to show panel
    if Miiui.button(50, 50, 200, 50, "Show Panel") then
        if not showPanel then
            showPanel = true
            Miiui.tween.create(panelScale, "value", {value = 1}, 0.3, "quadOut")
        end
    end

    -- Slider example
    sliderValue = Miiui.slider(50, 120, 300, sliderValue, 0, 100)
    Miiui.label(50, 150, "Slider value: " .. math.floor(sliderValue))

    -- Checkbox example
    checkboxValue = Miiui.checkbox(50, 180, checkboxValue, "Check me!")

    -- Text input example
    textInputValue = Miiui.textInput(50, 220, 200, 30, textInputValue, "Enter text...")

    -- Dropdown example
    selectedDropdownIndex = Miiui.dropdown(50, 270, 200, dropdownOptions, selectedDropdownIndex)
    Miiui.label(50, 310, "Selected: " .. dropdownOptions[selectedDropdownIndex])

    -- Animated panel
    if showPanel or panelScale.value > 0 then
        love.graphics.push()
        love.graphics.translate(400, 300)
        love.graphics.scale(panelScale.value, panelScale.value)
        Miiui.panel(-150, -100, 300, 200, function()
            Miiui.label(0, 20, "Animated Panel", {fontSize = 18, align = "center", width = 300})
            Miiui.label(20, 60, "This panel is animated!")
            if Miiui.button(75, 100, 150, 40, "Close") then
                showPanel = false
                Miiui.tween.create(panelScale, "value", {value = 0}, 0.3, "quadIn")
            end
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