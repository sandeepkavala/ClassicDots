-----------------------------------------------------------------------------------------
--
-- endScene.lua
--
-- Displays a windows over the game when the game is over.
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local widget = require('widget')
local scene = composer.newScene()

local gameWinner
local winnerText
local fanfare
local bg
local MID_X = display.contentCenterX
local MID_Y = display.contentCenterY

local function onPlay(event)
 composer.hideOverlay( "fade", 300 )
end
-- create()

function scene:create(event)
	local sceneGroup = self.view

    local max = 0
    local isDraw = false
    local winner = {}

    for player, data in pairs(event.params) do
        for k, value in pairs(data) do
            print (k, value)
            if (value > max) then
                -- find the player with the highest score
                max = value
                -- dump the winner table if it is populated
                if (#winner) then
                    winner = {}
                end
                table.insert(winner, player)
                isDraw = false
            elseif (value == max) then
                -- if the current player has a score equal to the max then a draw is likely to occur
                -- still best to test if that is the case though, as there could be a situation where
                -- the highest score is 0!
                if (#winner) then
                    isDraw = true
                end
                -- insert into winners table
                table.insert(winner, player)
            elseif (value < max and not #winner) then
                -- it is possible for all players to have a negative score
                -- if all players have negative scores this will still assign a winner
                max = value
                table.insert(winner, player)
            end
        end
    end

    if (isDraw) then
        gameWinner = "Draw between "
        if (#winner == 3) then
            gameWinner = gameWinner .. "all 3 players!"
        else
            gameWinner = gameWinner .. winner[1] .. " and " .. winner[2]
        end
    else
        gameWinner = winner[1] .. "wins!"
    end

	fanfare = audio.loadSound("success.wav")
	audio.play(fanfare)
	bg = display.newRect(sceneGroup,0,0,2000,2000)
	bg:setFillColor(0,0,0)
	bg.alpha = 0.4
    local gameTitle = display.newText(sceneGroup, "Game Over!!", MID_X, 100, native.systemFont, 40, center)
    local winnerText = display.newText(sceneGroup, gameWinner, MID_X, MID_Y, native.systemFont, 40, center)

    timer.performWithDelay(3000,onPlay)

end
-- show()
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end

end
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object

    if ( phase == "will" ) then
        -- Call the "resumeGame()" function in the parent scene
        --parent:resumeGame()
    end
end

function scene:destroy( event )

    local sceneGroup = self.view
    audio.stop()
    audio.dispose(fanfare)
    fanfare = nil
    -- Code here runs prior to the removal of scene's view

end




-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener("destroy",scene)
scene:addEventListener( "hide", scene )
-- -----------------------------------------------------------------------------------

return scene
