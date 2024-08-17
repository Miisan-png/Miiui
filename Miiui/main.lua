local Miiui = require "Miiui"

function love.load()
    love.window.setMode(800, 600)
end

function love.update(dt)
    Miiui.update(dt)
end

function love.draw()
    Miiui.begin()
    
    if Miiui.button(50, 50, 200, 40, "Click me!") then
        print("Button clicked!")
    end
    
    local sliderValue = Miiui.slider(50, 100, 200, 50, 0, 100)
    Miiui.label(50, 130, "Slider value: " .. math.floor(sliderValue))
    
    Miiui.end_frame()
end

function love.keypressed(key)
    Miiui.keypressed(key)
end

function love.textinput(text)
    Miiui.textinput(text)
end