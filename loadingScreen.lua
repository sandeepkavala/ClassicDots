-----------------------------------------------------------------------------------------
--
-- loadingScreen.lua
--
-- Displays a splash screen at the beginning of the game.
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require('widget')
local scene = composer.newScene()

local MID_X = display.contentCenterX
local MID_Y = display.contentCenterY

function scene:show( event )
    local sceneGroup = self.view

    local gameTitle = display.newText(sceneGroup, "Dots", MID_X, 100, native.systemFont, 40, center)

    spinnerOptions = {
        x = MID_X,
        y = MID_Y,
    }
    local spinner = widget.newSpinner(spinnerOptions)
    sceneGroup:insert(spinner)
    spinner:start()

    composer.loadScene("menuScene", true)
    composer.gotoScene("menuScene", "fade")
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
-- -----------------------------------------------------------------------------------

return scene
