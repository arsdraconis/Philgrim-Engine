--[[
	Filgrim Engine
	main.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Modules
require("game")
require("camera")
require("map")
require("entity")
require("character")
require("player")

-- Here for experimentation.
debug = {}

function debug.createTestEntity()
	debug.testEntity = Player:new(100, 100, 48, 48)
end

-- Löve's General Callback Functions ==========================================
function love.load()
	print("Loading...")
	game.init()
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

	-- Update the map.
	-- FIXME: Having to get these values to pass them to the map seems like bad design to me.
	-- FIXME: This should be in a level update function anyway, it's just here for now while we dick around.
	local scale = game.currentCamera:getScale()
	local x, y = game.currentCamera:getPosition()
	local width, height = game.currentCamera:getDimensions()
	width = width / scale
	height = height / scale

	game.map:update(x, y, width, height)
end

function love.draw()
	-- Tell the camera to draw everything.
	game.currentCamera:draw()

	-- Draw any UI here.
	-- TODO: We don't have a UI. Yet.

	-- Draw any debug crap here.
	if game.showFPS then love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20) end
end
