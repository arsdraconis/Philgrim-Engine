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
-- TODO: Refactor these functions.
-- IDEA: Combine functions into one. Pass in a map parameter to get tileSize and call getTile().
-- FIXME: These should be in the Map object.
function Character:getIntersectingTiles(position, dimension, outTileList, tileSize)
	-- Returns the tiles the bounding box intersects with.
	local currentTile = nil
	local tileInList = false;

	-- TODO: So it turns out that - 1 is important. Find out why.
	for i = 0, dimension - 1 do
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

	-- Check for valid directionOfMovement
	assert(directionOfMovement == "up" or "down" or "left" or "right")

	-- Find the tile line we're going to start checking on.
	local currentLine = math.floor(edge / tileSize)
	local nextLineOffset = nil
	local collisionDetected = false
	local x, y = nil, nil

	if directionOfMovement == "up" or directionOfMovement == "left" then
		nextLineOffset =  -1
	elseif directionOfMovement == "down" or directionOfMovement == "right" then
		nextLineOffset = 1
	end

	repeat
		-- Loop through our tile list until we find the closest static obstacle.
		-- FIXME: We shouldn't have to loop forever, just for a set amount of tiles.
		for _, i in pairs(tileList) do
			if directionOfMovement == "left" or directionOfMovement == "right" then
				x, y = currentLine, i
			elseif directionOfMovement == "up" or directionOfMovement == "down" then
				x, y = i, currentLine
			end

			-- FIXME: The startLine < 1 is a hack to keep from looping infinitely if we try to jump under open air.
			-- TODO: Decouple the map access here.
			if game.foregroundMap:getTile(x, y) or currentLine < 1 then
				collisionDetected = true
			end
		end

		if not collisionDetected then currentLine = currentLine + nextLineOffset end
	until collisionDetected

	return (currentLine * tileSize - edge)
end

-- Character Movement Methods =================================================
function Character:move(deltaX, deltaY)
	-- Move the character through the world.

	local distanceX, distanceY = nil, nil
	-- TODO: Decouple map access.
	local tileSize = game.foregroundMap:getTileSize()
	local edge = nil;
	local tileList = {}

	-- To support slopes later on, we increment X first, then Y. If we implement slopes.
	-- TODO: Find out why this works. Adding tileSize to some of these things fixed it. What? I don't even-

	if deltaX > 0 then -- Moving right.
		self:getIntersectingTiles(self.y + tileSize, self.height, tileList, tileSize)
		edge = self.x + self.width
		distanceX = self:checkForCollision("right", edge + tileSize, tileList, tileSize)
		self.x = self.x + math.min(deltaX, distanceX)
	elseif deltaX < 0 then -- Moving left.
		self:getIntersectingTiles(self.y + tileSize, self.height, tileList, tileSize)
		edge = self.x
		distanceX = self:checkForCollision("left", edge, tileList, tileSize)
		self.x = self.x + math.max(deltaX, distanceX)
	end

	if deltaY > 0 then -- Moving down.
		self:getIntersectingTiles(self.x + tileSize, self.width, tileList, tileSize)
		edge = self.y + self.height
		distanceY = self:checkForCollision("down", edge + tileSize, tileList, tileSize)
		self.y = self.y + math.min(deltaY, distanceY)
	elseif deltaY < 0 then -- Moving up.
		self:getIntersectingTiles(self.x + tileSize, self.width, tileList, tileSize)
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
