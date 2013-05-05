--[[
	Filgrim Engine
	entity.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Prototype
Entity = {}					-- Entity object prototype

-- OO Methods =================================================================
function Entity:new(x, y, width, height)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, lastJumpVelocity = 0, lastJumpFrame = 0, active = true }
	setmetatable(object, { __index = Entity })
	game.addEntity(object)	-- Add ourselves to the global entity table.
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

-- Entity Methods =============================================================
function Entity:move(deltaX, deltaY)
	-- Does nothing
	return
end

function Entity:update(deltaTime)
	if not self.active then return end
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
