--[[
	Filgrim Engine
	entity.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Class
Entity = {}					-- Entity object prototype
Entity.allEntities = {}		-- Class variable to hold all entities

-- Functions
function Entity:new(x, y, width, height)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, lastJumpVelocity = 0, lastJumpFrame = 0, active = true }
	setmetatable(object, { __index = Entity })
	table.insert(Entity.allEntities, object)
	return object
end

function Entity:drawAll(x, y)
	-- Draws all the entities in the level. Pass in the camera's position in the world.
	for index, currentEntity in ipairs(Entity.allEntities) do
		currentEntity:draw(x, y)
	end
end

function Entity:updateAll(deltaTime)
	-- Updates all the entities in the level. Pass in the deltaTime value.
	for index, currentEntity in ipairs(Entity.allEntities) do
		currentEntity:update(deltaTime)
	end
end


function Entity:update(deltaTime)
	-- TODO: Write me!

	-- Check and apply gravity here.
	self:move(0, 4)
end

function Entity:draw(x, y)
	-- Draws the entity but skips inactive ones. Pass in the camera's position in the world.
	-- TODO: Write me! Currently just draws a square based on its position and size.
	if not self.active then return end
end

function Entity:move(deltaX, deltaY)
	-- Move the entity through the world.

	-- 1. Decompose movement into X and Y axes, step one at a time. If you’re planning on implementing slopes
	--	afterwards, step X first, then Y. Otherwise, the order shouldn’t matter much. Then, for each axis:
	-- 2. Get the coordinate of the forward-facing edge, e.g., if walking left, the x coordinate of the left of
	--	the bounding box. If walking right, x coordinate of right side. If up, y coordinate of top, etc.
	local horizontalEdge, verticalEdge = nil, nil
	local nextRowOffset, nextColumnOffset = nil, nil
	local tileSize = game.map:getTileSize()

	if deltaX > 0 then -- Moving right.
		horizontalEdge = self.x + self.width
		nextColumnOffset = 1
	elseif deltaX < 0 then -- Moving left.
		horizontalEdge = self.x
		nextColumnOffset = -1
	else 
		nextColumnOffset = 0
	end

	if deltaY > 0 then -- Moving down.
		verticalEdge = self.y + self.height
		nextRowOffset = 1
	elseif deltaY < 0 then -- Moving up.
		verticalEdge = self.y
		nextRowOffset = -1
	else
		nextRowOffset = 0
	end

	-- 3. Figure which lines of tiles the bounding box intersects with – this will give you a minimum and maximum
	--	tile value on the OPPOSITE axis. For example, if we’re walking left, perhaps the player intersects with
	--	horizontal rows 32, 33 and 34 (that is, tiles with y = 32 * TS, y = 33 * TS, and y = 34 * TS, where TS = tile size).
	local tileList = {}
	tileList.horizontal = {}
	tileList.vertical = {}

	local findTiles = function (dimension, position, tileList, tileSize)
		local currentCheck = nil
		local tileInCollection = false

		-- Find all horizontal rows we intersect with.
		for i = 0, dimension do
			currentCheck = math.floor((position + i) / tileSize)

			-- Check if we already added this tile to our collection.
			tileInCollection = false

			for _, value in pairs(tileList) do
				if value == currentCheck then tileInCollection = true end
			end

			-- If the current tile is in our tileList, skip it. Otherwise add it.
			if not tileInCollection then
				table.insert(tileList, currentCheck)
			end
		end
	end

	findTiles(self.height, self.y, tileList.horizontal, tileSize)
	findTiles(self.width, self.x, tileList.vertical, tileSize)

	-- 4. Scan along those lines of tiles and towards the direction of movement until you find the closest static
	--	obstacle. Then loop through every moving obstacle, and determine which is the closest obstacle that is
	--	actually on your path.

	-- This is the code to calculate our collisions.
	local calculateCollision = function (columnOffset, axisToCheck, tileList, edge, tileSize)
		local collisionDetected = false
		local distance = nil
		local currentOffset = math.floor(edge / tileSize)

		repeat
			for _, i in pairs(tileList) do
				if axisToCheck == "x" then
					if game.map:getTile(currentOffset, i) or currentOffset < 1 then
						collisionDetected = true
						break
					end
				elseif axisToCheck == "y" then
					if game.map:getTile(i, currentOffset) or currentOffset < 1 then
						collisionDetected = true
						break
					end
				end
			end

			if columnOffset < 0 then
				distance = (currentOffset * tileSize) - edge
			elseif columnOffset > 0 then
				distance = (currentOffset * tileSize) - edge - tileSize
			end
			currentOffset = currentOffset + columnOffset
		until collisionDetected

		return distance
	end

	local distanceX, distanceY = nil, nil
	if nextColumnOffset ~= 0 then
		distanceX = calculateCollision(nextColumnOffset, "x", tileList.horizontal, horizontalEdge, tileSize)
	end
	if nextRowOffset ~= 0 then
		distanceY = calculateCollision(nextRowOffset, "y", tileList.vertical, verticalEdge, tileSize)
	end

	-- 5. The total movement of the player along that direction is then the minimum between the distance to closest
	--	obstacle, and the amount that you wanted to move in the first place.
	if nextColumnOffset < 0 then
		self.x = self.x + math.max(deltaX, distanceX)
	elseif nextColumnOffset > 0 then
		self.x = self.x + math.min(deltaX, distanceX)
	end

	if nextRowOffset < 0 then
		self.y = self.y + math.max(deltaY, distanceY)
	elseif nextRowOffset > 0 then
		self.y = self.y + math.min(deltaY, distanceY)
	end

end

function Entity:jump(deltaTime)
	-- Lua has no static variables, so we keep track of our previous jump velocity via the Player object.
	self.lastJumpVelocity = 0
	return -4
end

function Entity:setPosition(x, y)
	self.x, self.y = x, y
end

function Entity:getPosition()
	return self.x, self.y
end

function Entity:type()
	-- Returns the type of object this is.
	return "entity"
end
