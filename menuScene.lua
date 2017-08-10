local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local MID_X = display.contentCenterX
local MID_Y = display.contentCenterY
local buttonHeight = display.contentHeight / 10
local buttonGroup = display.newGroup()
buttonGroup.x = MID_X
buttonGroup.y = MID_Y - 20
local playButton
local playAIButton
local settingsButton
local exitButton

local function onPlay(event)
    composer.setVariable("threePlayer", false)
    composer.loadScene("gameScene",true)
    composer.gotoScene("gameScene","fade")
end

local function onThreePlayerPlay(event)
    composer.setVariable("threePlayer", true)
    composer.gotoScene("gameScene")
end

local function onSettings(event)
    composer.loadScene("settingsScene",true)
    composer.gotoScene("settingsScene","fade")
end

local function onExit(event)
    if system.getInfo("platformName")=="Android" then
        native.requestExit()
    else
        os.exit()
    end
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view
    sceneGroup:insert(buttonGroup)
    local gameTitle = display.newText(sceneGroup, "Dots!", MID_X, MID_Y / 2, native.systemFont, 40)
    local gameVersion = display.newText(sceneGroup, "v.0.1", MID_X + 60, (MID_Y / 2) + 11, native.systemFont, 12)
    playButton = widget.newButton(
        {
            x = 0,
            y = 0,
            onRelease = onPlay,
            label = "2 Player Game",
            labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
            font = native.systemFont,
            fontSize = 16,
            width = display.contentWidth / 2.6,
            height = buttonHeight,
            fillColor = {default={0.3, 0.6, 0.8}, over={0.4, 0.7, 0.9}},
            strokeColor = {default={0, 0.2, 0.4}, over={0.1, 0.4, 0.6}},
            strokeWidth = 1,
            shape = "roundedRect"
        }
    )
    buttonGroup:insert(playButton)

    playThreePlayerButton = widget.newButton(
        {
            x = 0,
            y = buttonHeight + 10,
            onRelease = onThreePlayerPlay,
            label = "3 Player Game",
            labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
            font = native.systemFont,
            fontSize = 16,
            width = display.contentWidth / 2.6,
            height = buttonHeight,
            fillColor = {default={0.3, 0.6, 0.8}, over={0.4, 0.7, 0.9}},
            strokeColor = {default={0, 0.2, 0.4}, over={0.1, 0.4, 0.6}},
            strokeWidth = 1,
            shape = "roundedRect"
        }
    )
    buttonGroup:insert(playThreePlayerButton)
    settingsButton = widget.newButton(
        {
            x = 0,
            y = buttonHeight * 2 + 20,
            onRelease = onSettings,
            label = "Settings",
            labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
            font = native.systemFont,
            fontSize = 16,
            width = display.contentWidth / 2.6,
            height = buttonHeight,
            fillColor = {default={0.3, 0.6, 0.8}, over={0.4, 0.7, 0.9}},
            strokeColor = {default={0, 0.2, 0.4}, over={0.1, 0.4, 0.6}},
            strokeWidth = 1,
            shape = "roundedRect"
        }
    )
    buttonGroup:insert(settingsButton)
    exitButton = widget.newButton(
        {
            x = 0,
            y = buttonHeight * 3 + 30,
            onRelease = onExit,
            label = "Exit",
            labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
            font = native.systemFont,
            fontSize = 16,
            width = display.contentWidth / 2.6,
            height = buttonHeight,
            fillColor = {default={0.3, 0.6, 0.8}, over={0.4, 0.7, 0.9}},
            strokeColor = {default={0, 0.2, 0.4}, over={0.1, 0.4, 0.6}},
            strokeWidth = 1,
            shape = "roundedRect"
        }
    )
    buttonGroup:insert(exitButton)
    local authorText = display.newText(sceneGroup, "by Josh Michielsen & Sandeep Kavala",
                                       0, (MID_Y * 2) - 8, native.systemFont, 12)
    authorText.anchorX = 0
end


-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase
end


-- hide()
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
end


-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
