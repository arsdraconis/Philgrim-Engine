--[[
	Filgrim Engine
	entity.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Class
Character = {}					-- Entity object prototype
Character.mt = setmetatable(Character, { __index = Entity })	-- Derive from Entity.

-- OO Methods =================================================================
function Character:new(x, y, width, height)
	-- Constructor
	local object = Entity:new(x, y, width, height)
	setmetatable(object, { __index = Character })
	return object
end

function Character:type()
	-- Returns the type of object this is.
	return "character"
end

-- Collision Detection Methods ================================================
function Character:getIntersectingTiles(position, dimension, outTileList, tileSize)
	-- Returns the tiles the bounding box intersects with.
	local currentTile = nil
	local tileInList = false;

	for i = 0, dimension do
		-- Calculate the current tile.
		currentTile = math.floor((position + i) / tileSize)

		-- Check if we already added this tile to our collection.
		for _, value in pairs(outTileList) do
			if value == currentTile then tileInList = true end
		end

		-- If not, add it.
		if not tileInList then table.insert(outTileList, currentTile) end
		tileInList = false
	end
end

function Character:checkForCollision(directionOfMovement, edge, tileList, tileSize)
	-- Returns the minimum amount the Character can move in directionOfMovement
	local distance = nil
	
	-- Check for valid directionOfMovement
	assert(directionOfMovement == "up" or "down" or "left" or "right")

	-- Find the tile line we're going to start checking on.
	local tileLine = math.floor(edge / tileSize)
	local firstTileLine = tileLine
	local collisionDetected = false
	local x, y = nil, nil

	repeat
		-- Loop through our tile list until we find the closest static obstacle.
		-- FIXME: We shouldn't have to loop forever, just for a set amount of tiles.
		for _, i in pairs(tileList) do
			if directionOfMovement == "left" or directionOfMovement == "right" then
				x, y = tileLine, i
			elseif directionOfMovement == "up" or directionOfMovement == "down" then
				x, y = i, tileLine
			end
			
			-- FIXME: The tileLine < 1 is a hack to keep from looping infinitely if we try to jump.
			if game.map:getTile(x, y) or tileLine < 1 then
				collisionDetected = true
				break
			end
		end

		-- Change the tile line to check on for the next loop.
		if directionOfMovement == "up" or directionOfMovement == "left" then
			tileLine = tileLine - 1
		elseif directionOfMovement == "down" or directionOfMovement == "right" then
			tileLine = tileLine + 1
		end
	until collisionDetected

	if directionOfMovement == "up" or directionOfMovement == "left" then
		distance = (tileLine * tileSize) - edge
	elseif directionOfMovement == "down" or directionOfMovement == "right" then
		distance = (tileLine * tileSize) - edge - tileSize
	end


	return distance
end

-- Character Movement Methods =================================================
function Character:move(deltaX, deltaY)
	-- Move the entity through the world.

	local distanceX, distanceY = nil, nil
	local tileSize = game.map:getTileSize()
	local edge = nil;
	local tileList = {}

	-- To support slopes later on, we increment X first, then Y.

	if deltaX > 0 then -- Moving right.
		self:getIntersectingTiles(self.y, self.height, tileList, tileSize)
		edge = self.x + self.width
		distanceX = self:checkForCollision("right", edge, tileList, tileSize)
		self.x = self.x + math.min(deltaX, distanceX)
	elseif deltaX < 0 then -- Moving left.
		self:getIntersectingTiles(self.y, self.height, tileList, tileSize)
		edge = self.x
		distanceX = self:checkForCollision("left", edge, tileList, tileSize)
		self.x = self.x + math.max(deltaX, distanceX)
	end

	if deltaY > 0 then -- Moving down.
		self:getIntersectingTiles(self.x, self.width, tileList, tileSize)
		edge = self.y + self.height
		distanceY = self:checkForCollision("down", edge, tileList, tileSize)
		self.y = self.y + math.min(deltaY, distanceY)
	elseif deltaY < 0 then -- Moving up.
		self:getIntersectingTiles(self.x, self.width, tileList, tileSize)
		edge = self.y
		distanceY = self:checkForCollision("up", edge, tileList, tileSize)
		self.y = self.y + math.max(deltaY, distanceY)
	end
end

function Character:jump(deltaTime)
	-- Lua has no static variables, so we keep track of our previous jump velocity via the Player object.
	self.lastJumpVelocity = 0
	return -4
end
