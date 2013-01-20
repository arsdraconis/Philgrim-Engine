--[[
	Mockup
	map.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.

	Basically, we create a 2D array to hold the map data, load the tileset image, then slice the image up
	into quads that we store in map.tiles. Every frame, we calculate the map tiles that will be on screen
	and stick them into tileBatch, which then gets drawn in drawMap(). This keeps us from drawing tiles
	that are offscreen although the entire map stays in memory.

	TODO: Implement multiple map layers. We could create a table to hold each layer.
	A layer would, in turn, be its own table and have something like the following
	attributes, in no particular order:
	1. Z index
	2. Parallax horizontal and vertical scroll rate (0 means fixed/won't scroll in that axis)
	3. map data
	4. Associated tile sets(?)
	5. Layer name
	6. width and height
	7. offset from origin (maybe just calculate this from the dimensions and scroll rate)
]]

-- Globals
map = {}

tileBatch = nil  -- This should probably be in the camera stuff.
tileSize = 16

-- Controls how many tiles we're drawing on the screen.
viewport = {}
viewport.width = 26
viewport.height = 20
-- The origin point on the map. Helps us find where to start getting tiles from.
viewport.origin = {}
viewport.origin.x = 1
viewport.origin.y = 1

-- Keeps track of the individual pixel increments as we move through the map.
currentX = 1
currentY = 1

function loadMap()
	-- Loads a map from a map file.

	-- We're not reading a file because MOCKUP! So we just set some variables here that a proper function should
	-- read from a file.
	map.width = 49
	map.height = 28
	map.data = { 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 234, 203, 203, 203, 203, 203, 203, 203, 203, 203, 203, 235, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 202, 203, 203, 204, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 170, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 251, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 208, 203, 203, 203, 203, 235, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, 165, 166, 167, nil, nil, nil, nil, nil, 165, 166, 167, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, nil, 165, 166, 167, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, nil, 181, 182, 183, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, nil, 197, 198, 199, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, nil, 213, 214, 215, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, nil, 229, 230, 231, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187 }
	map.tiles = {}

	-- Load the required tiles.
	if not loadTiles() then return false end

	-- Call updateMap() to initialize the tiles to draw, otherwise we'll draw nothing until the map moves.
	updateMap()

	return true
end

function loadTiles()
	-- Loads the tileset from an image and breaks them up into individual quads.
	-- Load the image file.
	local tilesetImage = love.graphics.newImage("Graphics/Tileset.png")
	if tilesetImage == nil then return false end

	-- Removes artifacts if we scale the image.
	tilesetImage:setFilter("nearest", "nearest")

	-- Calculate the dimensions of the tile set.
	local tileRows = tilesetImage:getHeight() / tileSize
	local tileColumns = tilesetImage:getWidth() / tileSize
	local tileCount = tileRows * tileColumns

	-- Create quads for each tile.
	local currentTile = 1		-- We start at 1 because a 0 in the map data means it is empty space.
	for currentRow = 0, tileRows - 1 do
		for currentColumn = 0, tileColumns - 1 do
			map.tiles[currentTile] = love.graphics.newQuad(currentColumn * tileSize, currentRow * tileSize, tileSize, tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
			currentTile = currentTile + 1
		end
	end

	-- Create a SpriteBatch to store the tiles we're going to draw to screen.
	tileBatch = love.graphics.newSpriteBatch(tilesetImage, viewport.width * viewport.height)
	return true
end

function updateMap()
	-- Updates the Sprite Batch based on our position in the world.
	tileBatch:clear()

	for y = 0, viewport.height - 1 do
		for x = 0, viewport.width - 1 do
			if map.data[(y * map.width) + (viewport.origin.y * map.width) + viewport.origin.x + x] then
				-- The scrolling magic happens on this next line.
				tileBatch:addq(map.tiles[map.data[(y * map.width) + (viewport.origin.y * map.width) + viewport.origin.x + x]], x * tileSize - (currentX % tileSize), y * tileSize - (currentY % tileSize))
			end
		end
	end
end

function moveMap(deltaX, deltaY)
	local oldMapX = viewport.origin.x
	local oldMapY = viewport.origin.y

	-- This clamps our values so we don't scroll beyond the edges of the map. The - 1 at the end is necessary to 
	-- fight this thing that happens where the map "bounces" when you reach the end.
	currentX = math.max(math.min(currentX + deltaX, tileSize * (map.width - viewport.width) - 1), 1)
	currentY = math.max(math.min(currentY + deltaY, tileSize * (map.height - viewport.height) - 1), 1)

	-- This calculates the tile that's in the top right portion of the viewport. We use it to tell us what tiles to draw.
	viewport.origin.x = math.max(math.min(1 + math.floor(currentX / tileSize), map.width - viewport.width), 1)
	viewport.origin.y = math.max(math.min(1 + math.floor(currentY / tileSize), map.height - viewport.height), 1)
end

function drawMap()
	-- Draws the map at 2x the tile size, to fit the entire window.
	love.graphics.push()
	love.graphics.scale(2)
	love.graphics.draw(tileBatch)
	love.graphics.pop()
end

