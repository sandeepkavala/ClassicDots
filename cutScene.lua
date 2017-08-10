-----------------------------------------------------------------------------------------
--
-- cutScene.lua
--
-- Displays a splash screen at the beginning of the game.
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

function scene:show( event )
    local sceneGroup = self.view
    composer.loadScene("gameScene", true)
    composer.gotoScene("gameScene", "fade")
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "show", scene )
-- -----------------------------------------------------------------------------------

return scene
