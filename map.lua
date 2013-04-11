--[[
	Filgrim Engine
	map.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
Map = {}

-- OO Methods =================================================================
function Map:new(width, height , zIndex, scrollRateX, scrollRateY, data)
	-- Constructor
	local object = { width = width, height = height, data = data, zIndex = zIndex, scrollRate = { x = scrollRateX, y = scrollRateY } }
	setmetatable(object, { __index = Map } )
	return object
end

-- Accessors ==================================================================
function Map:getDimensions()
	return self.width, self.height
end

function Map:getTileSize()
	return self.tileSize
end

function Map:getDimensionsInPixels()
	return self.width * self.tileSize, self.height * self.tileSize
end

function Map:getTile(x, y)
	-- Returns the tile at the specified map coordinate.
	return self.data[self.width * y + x]
end

-- Map Methods ================================================================
function Map:loadTiles(tilesetImagePath, tileSize)
	-- Loads the tileset from an image and breaks them up into individual quads.

	-- Create our tile data table.
	self.tiles = {}
	self.tileSize = tileSize
	self.tileBatch = nil

	-- Load the image file.
	self.tiles.tilesetImage = love.graphics.newImage(tilesetImagePath)
	assert(self.tiles.tilesetImage, "Could not load tileset: "..tilesetImagePath)

	-- This removes artifacts if we scale the image.
	self.tiles.tilesetImage:setFilter("nearest", "nearest")

	-- Calculate the dimensions of the tile set.
	local tileRows		= self.tiles.tilesetImage:getHeight() / tileSize
	local tileColumns	= self.tiles.tilesetImage:getWidth()  / tileSize
	local tileCount		= tileRows * tileColumns

	-- Create quads for each tile.
	local currentTile = 1

	for currentRow = 0, tileRows - 1 do
		for currentColumn = 0, tileColumns - 1 do
			self.tiles[currentTile] = love.graphics.newQuad(currentColumn * tileSize, currentRow * tileSize, tileSize, tileSize, self.tiles.tilesetImage:getWidth(), self.tiles.tilesetImage:getHeight() )
			currentTile = currentTile + 1
		end
	end

end

function Map:update(camera)
	-- This calculates what tiles we'll be drawing to the screen.
	-- It uses the values provided by the camera that gets passed in.

	-- First we need to get the necessary dimensions figured out.
	-- We use the camera's dimensions to calculate our viewport size in pixels, then find out how many tiles it will hold.
	local scale = camera:getScale()
	local cameraX, cameraY = camera:getPosition()
	local width, height = camera:getDimensions()

	local viewportWidth  = (width / scale)  / self.tileSize
	local viewportHeight = (height / scale) / self.tileSize

	-- Modify the camera values according to our scroll rate.
	cameraX = cameraX * self.scrollRate.x
	cameraY = cameraY * self.scrollRate.y

	-- Next, we need to calculate our origin tile (the tile in the top left of the viewport).
	-- The + 1 keeps the map from getting jumpy. Why?
	local originX = math.floor(cameraX / self.tileSize) + 1
	local originY = math.floor(cameraY / self.tileSize) + 1

	-- We can optimize our function here by comparing the current origin tile to the one that was used the last time we were called.
	-- If they're the same, return now.

	-- Then we're going to create a SpriteBatch if one does not already exist.
	-- If it does exist but the viewport dimensions have changed, we need to recalculate its dimensions.
	if not self.tileBatch then
		self.tileBatch = love.graphics.newSpriteBatch(self.tiles.tilesetImage, viewportWidth * viewportHeight)
	else
		-- TODO: If the thing already exists but the viewport dimensions have changed, recreate the batch.
	end

	-- Clear the tile batch.
	self.tileBatch:clear()

	-- Populate the tilebatch using the tiles currently on screen.
	for y = 0, viewportHeight + 1 do
		for x = 0, viewportWidth + 1 do
			local currentTile = self.width * (originY + y) + (originX + x)

			if self.data[currentTile] then
				self.tileBatch:addq( self.tiles[ self.data[currentTile] ], (x * self.tileSize) - (cameraX % self.tileSize), (y * self.tileSize) - (cameraY % self.tileSize) )
			end
		end
	end

end

function Map:draw(x, y)
	-- Merely draws the map.
	love.graphics.draw(self.tileBatch, x, y)
end
