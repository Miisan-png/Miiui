local Miiui = require "Miiui"

local state = {
    showSidePanel = false,
    panelScale = {value = 0},
    sliderValue = 50,
    checkboxValue = false,
    textInputValue = "",
    colorPreview = {1, 0, 0},
    counter = 0,
    health = 75,
    mana = 60,
    experiencePoints = 340
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

    -- Main panel
    Miiui.panel(20, 20, 300, 560, function()
        Miiui.label(10, 10, "Miiui Widget Showcase", {fontSize = 20, align = "center", width = 280})

        -- Toggle button for side panel
        if Miiui.button(50, 50, 200, 40, state.showSidePanel and "Close Side Panel" or "Open Side Panel") then
            state.showSidePanel = not state.showSidePanel
            if state.showSidePanel then
                Miiui.tween.create(state.panelScale, "value", {value = 1}, 0.3, "quadOut")
            else
                Miiui.tween.create(state.panelScale, "value", {value = 0}, 0.3, "quadIn")
            end
        end

        -- Interactive Health Progress Bar
        Miiui.label(50, 110, "Health:")
        state.health = Miiui.progressBar(50, 130, 200, 30, state.health, {
            min = 0,
            max = 100,
            color = {0.8, 0.2, 0.2},
            showPercentage = true,
            interactive = true
        })

        -- Interactive Mana Progress Bar
        Miiui.label(50, 180, "Mana:")
        state.mana = Miiui.progressBar(50, 200, 200, 30, state.mana, {
            min = 0,
            max = 100,
            color = {0.2, 0.2, 0.8},
            showPercentage = true,
            interactive = true
        })

        -- Checkbox
        state.checkboxValue = Miiui.checkbox(50, 250, state.checkboxValue, "Enable Feature")

        -- Text input
        Miiui.label(50, 290, "Enter your name:")
        state.textInputValue = Miiui.textInput(50, 320, 200, 30, state.textInputValue, "Type here...")

        -- Counter
        Miiui.label(50, 370, "Counter: " .. state.counter)
        if Miiui.button(50, 400, 90, 40, "-") then
            state.counter = state.counter - 1
        end
        if Miiui.button(160, 400, 90, 40, "+") then
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
            Miiui.label(20, 100, "Health: " .. math.floor(state.health))
            Miiui.label(20, 130, "Mana: " .. math.floor(state.mana))
            Miiui.label(20, 160, "Checkbox: " .. tostring(state.checkboxValue))
            Miiui.label(20, 190, "Text: " .. state.textInputValue)
            Miiui.label(20, 220, "Counter: " .. state.counter)

            -- Interactive vertical progress bar for XP
            Miiui.label(20, 260, "XP:")
            state.experiencePoints = Miiui.progressBar(20, 290, 30, 200, state.experiencePoints, {
                min = 0,
                max = 1000,
                color = {0.2, 0.8, 0.2},
                vertical = true,
                showPercentage = true,
                interactive = true
            })
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