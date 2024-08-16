# Miiui: Lightweight Immediate Mode GUI for LÖVE2D

Miiui is a lightweight, efficient Immediate Mode GUI (IMGUI) made for love2d framework:))

## Features

-  Immediate Mode GUI**: Create efficient GUIs without complex state management
-  Customizable Themes**: Easily adjust colors and sizes to match your game's aesthetic
-  Animated Transitions**: Add smooth animations to enhance user experience
-  Responsive Layouts**: Automatically adjusts to different screen sizes

## Showcase
https://github.com/user-attachments/assets/7bf4434a-3891-4380-83bb-92dd920b27cf





## Installation

1. Download or clone the repo
2. Extract the files into your LÖVE2D project directory.
3. Require the library in your `main.lua`:

```lua
local Miiui = require "Miiui"
```

## Usage

Here's a simple example of how to use Miiui to create a button and a slider:

```lua
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
```



## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## Support

If you encounter any problems or have any questions, please open an issue.

Made with love by Mii
