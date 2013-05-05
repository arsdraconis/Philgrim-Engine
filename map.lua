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
	local object = { width = width, height = height, data = data, zIndex = zIndex, scrollRate = { x = scrollRateX, y = scrollRateY }, lastUpdate = {} }
	setmetatable(object, { __index = Map } )
	return object
end

-- Accessors ==================================================================
function Map:getTileSize()
	return self.tileSize
end

function Map:getDimensions()
	return self.width, self.height
end

function Map:getDimensionsInPixels()
	return self.width * self.tileSize, self.height * self.tileSize
end

function Map:getTile(x, y)
	return self.data[self.width * y + x]
end

function Map:getTileInPixels(x, y)
	-- TODO: Finish me. Am I even needed?
	return nil
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
	-- Calculate our viewport dimensions.
	local scale = camera:getScale()
	local width, height = camera:getDimensions()
	local viewportWidth  = math.ceil(width / scale  / self.tileSize)
	local viewportHeight = math.ceil(height / scale / self.tileSize)

	-- Adjust our drawing position according to our scroll rate.
	local cameraX, cameraY = camera:getPosition()
	cameraX = cameraX * self.scrollRate.x
	cameraY = cameraY * self.scrollRate.y

	-- Next, we need to calculate our origin tile (the tile in the top left of the viewport).
	-- TODO: The + 1 keeps the map from screwing up. Why?
	local originX = math.floor(cameraX / self.tileSize) + 1
	local originY = math.floor(cameraY / self.tileSize) + 1

	-- We can optimize our function here by comparing the current camera
	-- position to the one that was used the last time we were called.
	if cameraX == self.lastUpdate.cameraX and cameraY == self.lastUpdate.cameraY then return end

	-- We lazily create a SpriteBatch here if one does not already exist.
	if self.tileBatch == nil then
		self.tileBatch = love.graphics.newSpriteBatch(self.tiles.tilesetImage, viewportWidth * viewportHeight)
	elseif self.lastUpdate.viewportWidth ~= viewportWidth or self.lastUpdate.viewportHeight ~= viewportHeight then
		-- If the thing already exists but the viewport dimensions have changed, recreate the batch.
		self.tileBatch = love.graphics.newSpriteBatch(self.tiles.tilesetImage, viewportWidth * viewportHeight)
	end

	-- Store updated data.
	self.lastUpdate.scale = scale
	self.lastUpdate.viewportWidth = viewportWidth
	self.lastUpdate.viewportHeight = viewportHeight
	self.lastUpdate.cameraX = cameraX
	self.lastUpdate.cameraY = cameraY
	self.lastUpdate.originX = originX
	self.lastUpdate.originY = originY

	-- Clear the tile batch.
	self.tileBatch:clear()

	-- Populate the tilebatch using the tiles currently on screen.
	for y = 0, viewportHeight do
		for x = 0, viewportWidth do
			local currentPosition = self.width * (originY + y) + (originX + x)
			local currentTile = self.data[currentPosition]

			if currentTile then
				self.tileBatch:addq(self.tiles[currentTile], (x * self.tileSize) - (cameraX % self.tileSize), (y * self.tileSize) - (cameraY % self.tileSize) )
			end
		end
	end

end

function Map:draw(x, y)
	love.graphics.draw(self.tileBatch, x, y)
end
