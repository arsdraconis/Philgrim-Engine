--[[
	Filgrim Engine
	game.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
game = {}
game.cameras = {}
game.entities = {}

-- Accessors ==================================================================
function game.getCurrentMap()
	-- Returns the current map layer the player is on.
end

function game.getCurrentLevel()
	-- Returns the current level.
end

function game.getCurrentCamera()
	return game.currentCamera
end

-- Level Functions ============================================================
function game.loadLevel(level)
	-- Loads a level and switches to it.
end

-- Entity Functions ===========================================================
function game.addEntity(entity)
	table.insert(game.entities, entity)
end

function game.removeEntity(entity)
	local position = 0

	for _, currentEntity in ipairs(game.entities) do
		position = position + 1
		if game.entities[position] == entity then break end
	end

	table.remove(game.entities, position)
end

-- Camera Functions ===========================================================
function game.addCamera(camera)
	-- Pushes the camera onto the camera stack and makes it the current camera.
	if camera:type() ~= "camera" then error("game.addCamera was passed something that was "..camera:type().."!") end
	table.insert(game.cameras, camera)
end

function game.removeCamera(camera)
	if camera:type() ~= "camera" then error("game.removeCamera was passed something that was "..camera:type().."!") end

	local position = 0

	for _, currentEntity in ipairs(game.cameras) do
		position = position + 1
		if game.cameras[position] == camera then break end
	end

	table.remove(game.cameras, position)
end

function game.setCurrentCamera(camera)
	if camera:type() ~= "camera" then error("game.setMainCamera was passed something that was "..camera:type().."!") end

	local position = 0

	for _, currentEntity in ipairs(game.cameras) do
		position = position + 1
		if game.cameras[position] == camera then break end
	end

	game.currentCamera = game.cameras[position]
end

-- General Game Functions =====================================================
function game.init()
	-- Initializes basic game state.

	-- Set general LÖVE stuff.
	love.graphics.setBackgroundColor(127, 127, 127)	-- Should this be in Camera?

	-- General Game State
	game.paused = false
	game.showFPS = true
	game.currentLevel = nil

	-- Set up a default camera.
	local windowWidth, windowHeight = love.graphics.getMode()
	local defaultCamera = Camera:new(1, 1, util.makeSize(windowWidth, windowHeight), util.makePoint(0, 0), util.makePoint(120, 110), 2)
	game.addCamera(defaultCamera)
	game.setCurrentCamera(defaultCamera)
end
