--[[
	Filgrim Engine
	entity.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Prototype
Entity = {}					-- Entity object prototype
Entity.allEntities = {}		-- Class variable to hold all entities

-- OO Methods =================================================================
function Entity:new(x, y, width, height)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, lastJumpVelocity = 0, lastJumpFrame = 0, active = true }
	setmetatable(object, { __index = Entity })
	-- TODO: This has to be decoupled.
	-- Game should have an entity creation function that returns the new entity and adds it to its own table.
	table.insert(Entity.allEntities, object)
	return object
end

function Entity:type()
	-- Returns the type of object this is.
	return "entity"
end

-- Accessors ==================================================================
function Entity:setPosition(x, y)
	self.x, self.y = x, y
end

function Entity:getPosition()
	return self.x, self.y
end

function Entity:getDimensions()
	return self.width, self.height
end

-- Global Entity Methods ======================================================
-- TODO: These first two functions should not be in Entity.

function Entity:drawAll(x, y)
	-- Draws all the entities in the level. Pass in the camera's position in the world.
	for _, currentEntity in ipairs(Entity.allEntities) do
		currentEntity:draw(x, y)
	end
end

function Entity:updateAll(deltaTime)
	-- Updates all the entities in the level. Pass in the deltaTime value.
	for _, currentEntity in ipairs(Entity.allEntities) do
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
	-- TODO: Write me! Currently just draws a rectangle based on its position and size.
	if not self.active then return end
	love.graphics.rectangle("fill", self.x - x, self.y - y, self.width, self.height)
end
