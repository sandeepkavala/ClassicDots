-----------------------------------------------------------------------------------------
--
-- gameScene.lua
--
-- This is the scene in which the game is played
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local currScene

-- load in dots
local dots = require( "dots" )

-- set the variables for buttons
local reloadGame
local mainMenu
local buttonHeight = display.contentHeight / 9

-- check if in 3 player mode
local threePlayer = composer.getVariable("threePlayer")

-- load in sounds
local clickSound = audio.loadSound("tapsound.wav")
local backGround = audio.loadStream("background.wav")

-- get display dimensions
local WIDTH = display.contentWidth
local HEIGHT = display.contentHeight

-- figure out size and location of grid
local SIZE = (math.min(HEIGHT, WIDTH))*0.9
local LOCATION = {x = (WIDTH - SIZE)/2, y = (HEIGHT - SIZE)/2}

-- set the number of lines in the grid
local LINES = composer.getVariable("lines")
local GAPS = LINES-1
local CELL_SIZE = SIZE/GAPS
local EDGE_SIZE = 6

-- -----------------------------------------------------------------------------------
-- user interface stuff
-- -----------------------------------------------------------------------------------

-- the grid of cells
local cells = {}
-- the horizontal edges
local horizontals = {}
-- the vertical edges
local verticals = {}
-- colours to use for cells
local colors = {
	red = {1.0, 0.0, 0.0},
	yellow = {1.0, 1.0, 0.0}
}

-- add additional player colour if 3 players
if threePlayer then
    colors.blue = { 0.0, 0.3, 1.0 }
end

-- will hold the text for each cells worth
local cellText = {}

-- colours to use for edges
local OPEN_EDGE_COLOR = {0.5, 0.5, 0.5}
local TAKEN_EDGE_COLOR = {0.0, 0.5, 1.0}
-- colour to use for vertices
local VERTEX_COLOR = {1.0, 1.0, 1.0}

-- forward references for text objects
local scoreText
local playerText

-- show the current score/player info
local function updateScores()
	scoreText.text = "red: " .. dots.players.red.score .. " | yellow: " .. dots.players.yellow.score
    -- add the blue player score if in 3 player mode
    if threePlayer then
        scoreText.text = scoreText.text .. " | blue: " .. dots.players.blue.score
    end
	playerText:setFillColor(unpack(colors[dots.currentPlayer]))
	playerText.text = dots.currentPlayer .. " to play"
end

local function updateCellScores()
    for i = 1, LINES-1 do
        for j = 1, LINES-1 do
            cellText[i][j].text = dots.cells[i][j].score
        end
    end
end

-- register an event listener for game updates
local function onUpdate( player, row, column )
	cells[row][column]:setFillColor(unpack(colors[player]))
	cells[row][column].alpha = 0.3
end

dots:addListener(onUpdate)

-- go to end screen at the end of the game, and reload game.
local function endOfGame()
	if dots:isOver() then
		composer.showOverlay("endScene",
			{
    			isModal = true,
    			effect = "fade",
    			time = 300,
    			params = dots.players
			}
        )
	end
end

local function resumeGame()
	timer.performWithDelay(500,reloadGame)
end
-- user interaction

-- reset the board/scores for the start of a game
local function newGame()
	for i = 1, LINES-1 do
		for j = 1, LINES-1 do
			cells[i][j].alpha = 0
		end
	end

	for i = 1, LINES do
		for j = 1, LINES-1 do
			horizontals[i][j]:setFillColor(unpack(OPEN_EDGE_COLOR))
			horizontals[i][j].owner = nil
		end
	end

	for j = 1, LINES do
		for i = 1, LINES-1 do
			verticals[j][i]:setFillColor(unpack(OPEN_EDGE_COLOR))
			verticals[j][i].owner = nil
		end
	end

	dots:newGame()

	updateScores()
    updateCellScores()
end

-- respond to clicks on horizontal edges
local function onTouchHorizontal(event)
	if event.phase == "ended" then
		local row = event.target.row
		local col = event.target.col
		if not horizontals[row][col].owner then
			horizontals[row][col].owner = dots.currentPlayer
			horizontals[row][col]:setFillColor(unpack(TAKEN_EDGE_COLOR))
			dots:doHorizontal(row, col)
			audio.play(clickSound)
			updateScores()
			endOfGame()
		end
		return true
	end
end

-- and vertical edges
local function onTouchVertical(event)
	if event.phase == "ended" then
		local row = event.target.row
		local col = event.target.col
		if not verticals[col][row].owner then
			verticals[col][row].owner = dots.currentPlayer
			verticals[col][row]:setFillColor(unpack(TAKEN_EDGE_COLOR))
			dots:doVertical(row, col)
			audio.play(clickSound)
			updateScores()
			endOfGame()
		end
		return true
	end
end

-- reload Game by quickly transitioning back to gameScene

local function onReloadGame(event)
	newGame()
    --composer.removeScene("gameScene")
	--composer.gotoScene( "cutScene" )
end


-- goto Main Menu
local function onMenu(event)
	composer.removeScene("gameScene")
    composer.gotoScene("menuScene")
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view

    -- Code here runs when the scene is first created but has not yet appeared on screen

	cells = {}
    cellText = {}
	for i = 1, LINES-1 do
		cells[i] = {}
        cellText[i] = {}
		local y = LOCATION.y + (i-1) * CELL_SIZE
		for j = 1, LINES-1 do
			local x = LOCATION.x + (j-1) * CELL_SIZE
			cells[i][j] = display.newRect(sceneGroup, x, y, CELL_SIZE, CELL_SIZE)
			cells[i][j].anchorX = 0
			cells[i][j].anchorY = 0
            cellText[i][j] = display.newText(sceneGroup, "", x + (CELL_SIZE/2), y + (CELL_SIZE/2), native.systemFont, 18)
		end
	end

	horizontals = {}
	for i = 1, LINES do
		horizontals[i] = {}
		local y = LOCATION.y + (i-1) * CELL_SIZE
		for j = 1, LINES-1 do
			local x = LOCATION.x + (j-1) * CELL_SIZE
			horizontals[i][j] = display.newRect(sceneGroup, x, y, CELL_SIZE, EDGE_SIZE)
			horizontals[i][j].anchorX = 0
			horizontals[i][j]:addEventListener( "touch", onTouchHorizontal )
			horizontals[i][j].row = i
			horizontals[i][j].col = j
		end
	end

	verticals = {}
	for j = 1, LINES do
		verticals[j] = {}
		local x = LOCATION.x + (j-1) * CELL_SIZE
		for i = 1, LINES-1 do
			local y = LOCATION.y + (i-1) * CELL_SIZE
			verticals[j][i] = display.newRect(sceneGroup, x, y, EDGE_SIZE, CELL_SIZE)
			verticals[j][i].anchorY = 0
			verticals[j][i]:addEventListener( "touch", onTouchVertical )
			verticals[j][i].row = i
			verticals[j][i].col = j
		end
	end

	-- and white dots

	for i = 1, LINES do
		local y = LOCATION.y + (i-1) * CELL_SIZE
		for j = 1, LINES do
			local x = LOCATION.x + (j-1) * CELL_SIZE
			local dot = display.newCircle(sceneGroup, x, y, EDGE_SIZE)
			dot:setFillColor(unpack(VERTEX_COLOR))
		end
	end

	-- and the score

	scoreText = display.newText(sceneGroup, "", 0, 0, native.systemfont, 24)
	scoreText.x = WIDTH/2
	scoreText.y = scoreText.height/2 + 10

	playerText = display.newText(sceneGroup, "", 0, 0, native.systemfont, 24)
	playerText.x = WIDTH/2
	playerText.y = scoreText.y + 24

	reloadGame = widget.newButton(
        {
            x = display.contentWidth/5 ,
            y = display.contentHeight - (buttonHeight / 2) - 10,
            onRelease = onReloadGame,
            label = "Restart",
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
    mainMenu = widget.newButton(
        {
            x = display.contentWidth - display.contentWidth / 5,
            y = display.contentHeight - (buttonHeight / 2) - 10,
            onRelease = onMenu,
            label = "Menu",
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

    sceneGroup:insert(reloadGame)
    sceneGroup:insert(mainMenu)
    currScene = composer.getSceneName( "current" )

	newGame()
	audio.play(backGround,{loops = -1,fadein = 1000})
end

-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view

    audio.stop()
    audio.dispose(clickSound)
    audio.dispose(backGround)
    clickSound = nil
    backGround = nil

end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
