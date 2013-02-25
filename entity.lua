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
	local object = { x = x, y = y, width = width, height = height, active = true }
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

	local currentCheck = nil
	local tileInCollection = false

	-- Find all horizontal rows we intersect with.
	for i = 0, self.height do
		currentCheck = math.floor((self.y + i) / tileSize)

		-- Check if we already added this tile to our collection.
		tileInCollection = false

		for _, value in pairs(tileList.horizontal) do
			if value == currentCheck then tileInCollection = true end
		end

		-- If the current tile is in our tileList, skip it. Otherwise add it.
		if not tileInCollection then
			table.insert(tileList.horizontal, currentCheck)
		end
	end

	-- Find all vertical rows we intersect with.
	for i = 0, self.width do
		currentCheck = math.floor((self.x + i) / tileSize)

		-- Check if we already added this tile to our collection.
		tileInCollection = false

		for _, value in pairs(tileList.vertical) do
			if value == currentCheck then tileInCollection = true end
		end

		-- If the current tile is in our tileList, skip it. Otherwise add it.
		if not tileInCollection then
			table.insert(tileList.vertical, currentCheck)
		end
	end

	-- 4. Scan along those lines of tiles and towards the direction of movement until you find the closest static
	--	obstacle. Then loop through every moving obstacle, and determine which is the closest obstacle that is
	--	actually on your path.
	local distanceX, distanceY = 0, 0
	local collisionDetected = false

	-- Calculate horizontal collisions here.
	if nextColumnOffset ~= 0 then
		local x = math.floor(horizontalEdge / tileSize)

		repeat
			for _, y in pairs(tileList.horizontal) do
				if game.map:getTile(x, y) then
					collisionDetected = true
					break
				end
			end

			if nextColumnOffset < 0 then
				distanceX = (x * tileSize) - horizontalEdge
			elseif nextColumnOffset > 0 then
				distanceX = (x * tileSize) - horizontalEdge - tileSize
			end
			x = x + nextColumnOffset
		until collisionDetected
	end

	-- FIXME: There's a bug here that causes Lua to crash.
	collisionDetected = false

	-- Calculate vertical collisions here.
	if nextRowOffset ~= 0 then
		local y = math.floor(verticalEdge / tileSize)

		repeat
			for _, x in pairs(tileList.vertical) do
				if game.map:getTile(x, y) then
					collisionDetected = true
					break
				end
			end

			if nextRowOffset < 0 then
				distanceY = (y * tileSize) - verticalEdge
			elseif nextRowOffset > 0 then
				distanceY = (y * tileSize) - verticalEdge - tileSize
			end
			y = y + nextRowOffset
		until collisionDetected
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
