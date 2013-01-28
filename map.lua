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
Map = {}		-- A table to hold our class methods.

-- Functions
function Map:new(width, height, data, zIndex, scrollRateX, scrollRateY)
	-- Constructor
	local object = { width = width, height = height, data = data, zIndex = zIndex, scrollRate = { x = scrollRateX, y = scrollRateY } }
	setmetatable(object, { __index = Map })
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
	if not self.tiles.tilesetImage then error("Could not load tileset: "..tilesetImagePath) end

	-- Removes artifacts if we scale the image.
	self.tiles.tilesetImage:setFilter("nearest", "nearest")

	-- Calculate the dimensions of the tile set.
	local tileRows = self.tiles.tilesetImage:getHeight() / tileSize
	local tileColumns = self.tiles.tilesetImage:getWidth() / tileSize
	local tileCount = tileRows * tileColumns


	-- Create quads for each tile.
	local currentTile = 1
	for currentRow = 0, tileRows - 1 do
		for currentColumn = 0, tileColumns - 1 do
			self.tiles[currentTile] = love.graphics.newQuad(currentColumn * tileSize, currentRow * tileSize, tileSize, tileSize, self.tiles.tilesetImage:getWidth(), self.tiles.tilesetImage:getHeight())
			currentTile = currentTile + 1
		end
	end

end

function Map:update(originX, originY, viewportWidth, viewportHeight)
	-- Updates the Sprite Batch based on our position in the world.
	-- TODO: Will this work?
	-- TODO: Should this be combined with the drawing?

	-- Create a SpriteBatch to store the tiles we're going to draw to screen.
	if not self.tiles.batch then
		self.tiles.batch = love.graphics.newSpriteBatch(self.tiles.tilesetImage, (viewportWidth / self.tiles.size + 1) * (viewportHeight / self.tiles.size + 1))
	else
		-- If the thing already exists but the viewport dimensions have changed, recreate the batch.
	end

	viewportWidth = viewportWidth / self.tiles.size
	viewportHeight = viewportHeight / self.tiles.size

	-- This clamps our values so we don't scroll beyond the edges of the map. The - 1 at the end is necessary to 
	-- keep the map from "bouncing" when you reach the end.
	originX = math.max( math.min(originX, self.tiles.size * (self.width  - viewportWidth ) - 1), 1)
	originY = math.max( math.min(originY, self.tiles.size * (self.height - viewportHeight) - 1), 1)

	-- print("Modified origin point: "..originX..", "..originY)

	-- This calculates the tile that's in the top right portion of the viewport. We use it to tell us what tiles to draw.
	local tileX = math.max( math.min( math.floor(originX / self.tiles.size) + 1, self.width  - viewportWidth ), 1)
	local tileY = math.max( math.min( math.floor(originY / self.tiles.size) + 1, self.height - viewportHeight), 1)

	-- Possible optimization: check if our position in the world has changed before doing all this.
	self.tiles.batch:clear()

	for y = 0, viewportHeight do
		for x = 0, viewportWidth do
			local currentTile = (y * self.width) + (tileY * self.width) + (tileX + x)

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
