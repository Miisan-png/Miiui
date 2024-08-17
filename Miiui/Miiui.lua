-- Miiui.lua
local MiiuiCore = require "MiiuiCore"
local MiiuiWidgets = require "MiiuiWidgets"
local MiiuiUtils = require "MiiuiUtils"
local MiiuiTheme = require "MiiuiTheme"
local MiiuiTween = require "MiiuiTween"

local Miiui = {}

-- Initialize core with utils and theme
MiiuiCore.init(MiiuiUtils, MiiuiTheme)

-- Initialize widgets with core and utils
MiiuiWidgets.init(MiiuiCore, MiiuiUtils)

-- Expose core functions
Miiui.begin = MiiuiCore.begin
Miiui.end_frame = MiiuiCore.end_frame
Miiui.update = MiiuiCore.update

-- Expose tween functions
Miiui.tween = {
    create = MiiuiTween.create,
    moveTo = MiiuiTween.moveTo,
    scaleTo = MiiuiTween.scaleTo,
    rotateTo = MiiuiTween.rotateTo
}

-- Expose widget functions
Miiui.keypressed = MiiuiCore.keypressed
Miiui.keyreleased = MiiuiCore.keyreleased
Miiui.textinput = MiiuiCore.textinput
Miiui.panel = MiiuiWidgets.panel
Miiui.button = MiiuiWidgets.button
Miiui.slider = MiiuiWidgets.slider
Miiui.checkbox = MiiuiWidgets.checkbox
Miiui.label = MiiuiWidgets.label
Miiui.textInput = MiiuiWidgets.textInput  
Miiui.progressBar = MiiuiWidgets.progressBar

return Miiui