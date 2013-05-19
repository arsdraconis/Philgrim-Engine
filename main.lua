--[[
	Filgrim Engine
	main.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Modules
require("utilities")
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
	local camera = game.getCurrentCamera()
	-- Don't do anything if we're paused.
	if game.paused then return end

	-- Updates all the entities in the level. Pass in the deltaTime value.
	for _, currentEntity in ipairs(game.entities) do
		currentEntity:update(dt)
	end

	-- Update camera position.
	camera:trackEntity(debug.testEntity)

	-- Update the map.
	for _, currentMap in ipairs(game.maps) do
		currentMap:update(camera)
	end
end

function love.draw()
	-- Store the current graphics state.
	love.graphics.push()

	-- Scale the view.
	love.graphics.scale(game.currentCamera:getScale())

	-- Draw the map layers, from back to front.
	-- TODO: This needs to take the map z order into account. And what about entities?
	for _, currentMap in ipairs(game.maps) do
		currentMap:draw(game.currentCamera)
	end

	for _, currentEntity in ipairs(game.entities) do
		currentEntity:draw(game.currentCamera)
	end

	-- Restore the previous graphics state.
	love.graphics.pop()

	-- Draw any UI here.
	game.drawUI()

	-- Draw any debug crap here.
	if game.showFPS then love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20) end
end
