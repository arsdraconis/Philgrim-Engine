--[[
	Filgrim Engine
	main.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Modules
require("philgrim_debug")
require("game")
require("camera")
require("map")
require("entity")
require("character")
require("player")

-- Löve's General Callback Functions ==========================================
function love.load(arg)
  --if arg[#arg] == "-debug" then require("mobdebug").start() end
	print("Loading...")
	game.init()

	-- Set up our map and test entity.
	-- TODO: Remove for release.
	debug.createDebugMap()
	debug.createTestEntity()
end

function love.focus(f)
	if not f then
		game.paused = true
		print(love.graphics.getCaption().." lost focus!")
	else
		game.paused = false
		print(love.graphics.getCaption().." gained focus!")
	end
end

function love.quit()
	print("Quitting...")
end

-- Love's Game Loop Callbacks =================================================
function love.update(dt)
	-- Don't do anything if we're paused.
	if game.paused then return end

	-- Update entities.
	-- Any entity that responds to user input should implement its behavior in its own update() method.
	Entity:updateAll(dt)

	-- Move the camera.
	game.currentCamera:trackEntity(debug.testEntity)

	-- Update the map.
	for _, currentMap in ipairs(game.maps) do
		currentMap:update(game.currentCamera)
	end
	-- FIXME: This is here while we dick around, but the map update function should take care of this.
end

function love.draw()
	-- Tell the camera to draw everything.
	game.currentCamera:draw()

	-- Draw any UI here.

	-- Draw any debug crap here.
	if game.showFPS then love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20) end
end
