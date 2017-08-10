local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local levelText
local currentLevel

local slider
local backButton
local MID_X = display.contentCenterX
local MID_Y = display.contentCenterY
local buttonHeight = display.contentHeight / 9


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function updateSlider()
    levelText.text = "Grid Size  "..curretLevel

end

local function sliderListener(event)
    curretLevel = 3 + math.round((event.value/100)*7)
    composer.setVariable("lines",curretLevel)
    updateSlider()
end

local function onBack(event)
    composer.gotoScene("menuScene","fade")
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    currentLevel = composer.getVariable("lines")
    levelText = display.newText(sceneGroup,"Grid Size   "..currentLevel, 0, 0, native.systemFont, 30)
    levelText.x = MID_X
    levelText.y = 100

    slider = widget.newSlider(
        {
            left = 50,
            top = 120,
            width = 200,
            value = 20,
            listener = sliderListener
        }
    )
    sceneGroup:insert(slider)

    backButton = widget.newButton(
        {
            x = MID_X,
            y = MID_Y+MID_Y/2,
            onRelease = onBack,
            label = "Exit",
            labelColor = {default = {0, 0, 0}, over = {0, 0, 0}},
            font = native.systemFont,
            fontSize = 18,
            width = display.contentWidth / 3,
            height = buttonHeight,
            fillColor = {default={0.3, 0.6, 0.8}, over={0.4, 0.7, 0.9}},
            strokeColor = {default={0, 0.2, 0.4}, over={0.1, 0.4, 0.6}},
            strokeWidth = 1,
            shape = "roundedRect"
        }
    )

    sceneGroup:insert(backButton)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
-- -----------------------------------------------------------------------------------

return scene
