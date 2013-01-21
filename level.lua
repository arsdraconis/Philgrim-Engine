--[[
	Mockup
	map.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.

	Basically, we create a 2D array to hold the map data, load the tileset image, then slice the image up
	into quads that we store in map.tiles. Every frame, we calculate the map tiles that will be on screen
	and stick them into map.drawing.batch, which then gets drawn in drawMap(). This keeps us from drawing tiles
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

function map.loadMap()
	-- Loads a map from a map file.
	-- We're not reading a file because MOCKUP! So we just set some variables here that a proper function should
	-- read from a file.
	map.width = 49
	map.height = 28
	map.data = { 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 234, 203, 203, 203, 203, 203, 203, 203, 203, 203, 203, 235, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 202, 203, 203, 204, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 170, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 251, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 208, 203, 203, 203, 203, 235, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, 165, 166, 167, nil, nil, nil, nil, nil, 165, 166, 167, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, nil, 165, 166, 167, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, nil, 181, 182, 183, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, nil, 197, 198, 199, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, nil, 213, 214, 215, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, nil, 229, 230, 231, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187 }

	-- For multiple map layers.
	map.zIndex = 1			-- Z position of map layer.
	map.scrollRate = {}		-- Used in parallax scrolling. Controls speed of x and y scroll speed.
	map.scrollRate.x = 1
	map.scrollRate.y = 1

	-- The following keeps track of what portion of the map to draw.
	map.drawing = {}
	map.drawing.batch = nil
	map.drawing.topLeftX = 1
	map.drawing.topLeftY = 1

	if not map.loadTiles() then return false end

	-- Call updateMap() to initialize the tiles to draw, otherwise we'll draw nothing until the map moves.
	updateMap()
	return true
end

function map.loadTiles()
	-- Loads the tileset from an image and breaks them up into individual quads.
	-- Load the image file.
	map.tiles = {}
	map.tileSize = 16
	local tilesetImage = love.graphics.newImage("Graphics/Tileset.png")
	if not tilesetImage then return false end

	-- Removes artifacts if we scale the image.
	tilesetImage:setFilter("nearest", "nearest")

	-- Calculate the dimensions of the tile set.
	local tileRows = tilesetImage:getHeight() / map.tileSize
	local tileColumns = tilesetImage:getWidth() / map.tileSize
	local tileCount = tileRows * tileColumns

	-- Create quads for each tile.
	local currentTile = 1
	for currentRow = 0, tileRows - 1 do
		for currentColumn = 0, tileColumns - 1 do
			map.tiles[currentTile] = love.graphics.newQuad(currentColumn * map.tileSize, currentRow * map.tileSize, map.tileSize, map.tileSize, tilesetImage:getWidth(), tilesetImage:getHeight())
			currentTile = currentTile + 1
		end
	end

	-- Create a SpriteBatch to store the tiles we're going to draw to screen.
	map.drawing.batch = love.graphics.newSpriteBatch(tilesetImage, game.viewport.width * game.viewport.height)
	return true
end

function updateMap(viewportWidth, viewportHeight)
	-- Updates the Sprite Batch based on our position in the world.
	-- Possible optimization: check if our position in the world has changed before doing all this.
	map.drawing.batch:clear()

	for y = 0, game.viewport.height - 1 do
		for x = 0, game.viewport.width - 1 do
			local currentTile = (y * map.width) + (map.drawing.topLeftY * map.width) + (map.drawing.topLeftX + x)

			if map.data[currentTile] then
				map.drawing.batch:addq( map.tiles[ map.data[currentTile] ], (x * map.tileSize) - (game.viewport.originX % map.tileSize), (y * map.tileSize) - (game.viewport.originY % map.tileSize) )
			end
		end
	end
end

function moveMap(deltaX, deltaY)
	-- This clamps our values so we don't scroll beyond the edges of the map. The - 1 at the end is necessary to 
	-- keep the map from "bouncing" when you reach the end.
	game.viewport.originX = math.max( math.min( game.viewport.originX + deltaX, map.tileSize * (map.width - game.viewport.width) - 1), 1)
	game.viewport.originY = math.max( math.min( game.viewport.originY + deltaY, map.tileSize * (map.height - game.viewport.height) - 1), 1)

	-- This calculates the tile that's in the top right portion of the viewport. We use it to tell us what tiles to draw.
	map.drawing.topLeftX  = math.max( math.min( 1 + math.floor(game.viewport.originX / map.tileSize), map.width - game.viewport.width), 1)
	map.drawing.topLeftY  = math.max( math.min( 1 + math.floor(game.viewport.originY / map.tileSize), map.height - game.viewport.height), 1)
end

function drawMap()
	-- Draws the map at 2x the tile size, to fit the entire window.
	love.graphics.push()
	love.graphics.scale(2)
	love.graphics.draw(map.drawing.batch)
	love.graphics.pop()
end

