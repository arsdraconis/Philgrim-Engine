--[[
	Filgrim Engine
	map.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
Map = {}		-- Map object prototype

-- Functions
function Map:new(width, height, data, zIndex, scrollRateX, scrollRateY)
	-- Constructor
	local object = { width = width, height = height, data = data, zIndex = zIndex, scrollRate = { x = scrollRateX, y = scrollRateY } }
	setmetatable(object, { __index = Map } )
	return object
end

function Map:loadTiles(tilesetImagePath, tileSize)
	-- Loads the tileset from an image and breaks them up into individual quads.

	-- Create our tile data table.
	self.tiles = {}
	self.tiles.size = tileSize
	self.tiles.batch = nil

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

function Map:update(originX, originY, viewportWidth, viewportHeight)
	-- Updates the map's SpriteBatch based on our position in the world.
	-- TODO: Should this be merged into draw()?

	-- We don't care about actual pixel values in this function!
	viewportWidth  = viewportWidth  / self.tiles.size
	viewportHeight = viewportHeight / self.tiles.size + 1
	-- TODO: Taking out the + 1 adds an empty row at the bottom of the map.

	-- Create a SpriteBatch to store the tiles we're going to draw to screen.
	if not self.tiles.batch then
		self.tiles.batch = love.graphics.newSpriteBatch(self.tiles.tilesetImage, viewportWidth * viewportHeight)
	else
		-- If the thing already exists but the viewport dimensions have changed, recreate the batch.
	end

	-- This clamps our values so we don't scroll beyond the edges of the map.
	-- The - 1 at the end is necessary to keep the map from "bouncing" when you reach the end.
	originX = math.max( math.min(originX, self.tiles.size * (self.width  - viewportWidth ) - 1), 1)
	originY = math.max( math.min(originY, self.tiles.size * (self.height - viewportHeight) - 1), 1)

	-- This calculates the tile that's in the top right portion of the viewport. We use it to tell us what tiles to draw.
	local tileX = math.max( math.min( math.floor(originX / self.tiles.size) + 1, self.width  - viewportWidth ), 1)
	local tileY = math.max( math.min( math.floor(originY / self.tiles.size) + 1, self.height - viewportHeight), 1)

	-- TODO: Possible optimization: check if our position in the world has changed before doing all this.
	self.tiles.batch:clear()

	for y = 0, viewportHeight do
		for x = 0, viewportWidth do
			local currentTile = self.width * (tileY + y) + (tileX + x)

			if self.data[currentTile] then
				self.tiles.batch:addq( self.tiles[ self.data[currentTile] ], (x * self.tiles.size) - (originX % self.tiles.size), (y * self.tiles.size) - (originY % self.tiles.size) )
			end
		end
	end

end

function Map:draw()
	-- Merely draws the map.
	love.graphics.draw(self.tiles.batch)
end

function Map:getDimensions()
	return self.width, self.height
end

function Map:getTileSize()
	return self.tiles.size
end

function Map:getDimensionsInPixels()
	return self.width * self.tiles.size, self.height * self.tiles.size
end

function Map:getTile(x, y)
	--print("Map:getTile called with "..x..", "..y)
	return self.data[self.width * y + x]
end
