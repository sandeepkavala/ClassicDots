-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Starter for the Dots project
-- Existing code works but needs to be enhanced
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )

composer.setVariable("lines",5)
composer.setVariable("threePlayer", false)

-- Code to initialize the app can go here

-- Now load the opening scene

-- Assumes that "questionScene.lua" exists and is configured as a Composer scene
composer.gotoScene( "loadingScreen" )
