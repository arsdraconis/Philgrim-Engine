--[[
	Filgrim Engine
	game.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
game = {}
game.cameras = {}

-- Camera Functions ===========================================================
function game.cameras.push(camera)
	-- Pushes the camera onto the camera stack and makes it the current camera.
	if camera:type() == "camera" then
		table.insert(game.cameras, camera)
		game.currentCamera = game.cameras[ #game.cameras ]
	else
		error("game.pushCamera was passed something that was "..camera:type().."!")
	end
end

function game.cameras.pop()
	-- Pops the last camera off the stack and makes the next one the current camera.
	table.remove(game.cameras)
	game.currentCamera = game.cameras[ #game.cameras ]
end

-- General Game Functions =====================================================
function game.init()
	-- Set general LÖVE stuff.
	love.graphics.setBackgroundColor(127, 127, 127)	-- Should this be in Camera?

	-- General Game State
	game.paused = false
	game.showFPS = true
	game.currentLevel = nil

	-- Set up our map.
	local rawMap = { 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 234, 203, 203, 203, 203, 203, 203, 203, 203, 203, 203, 235, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 202, 203, 203, 204, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 170, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 251, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 208, 203, 203, 203, 203, 235, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, 165, 166, 167, nil, nil, nil, nil, nil, 165, 166, 167, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, nil, 165, 166, 167, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, nil, 181, 182, 183, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, nil, 197, 198, 199, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, nil, 213, 214, 215, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, nil, 229, 230, 231, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187 }
	game.map = Map:new(49, 28, rawMap, 1, 1, 1)
	assert(game.map)
	game.map:loadTiles("Graphics/Tileset.png", 16)

	-- Set up a default camera.
	local windowWidth, windowHeight = love.graphics.getMode()
	local defaultCamera = Camera:new(1, 1, windowWidth, windowHeight, 2)
	game.cameras.push(defaultCamera)
end
