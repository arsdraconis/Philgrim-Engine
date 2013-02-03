--[[
	Filgrim Engine
	entity.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
Entity = {}		-- Entity object prototype
Entity.allEntities = {}

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

function Entity:update(deltaTime)
	-- TODO: Write me!
end

function Entity:draw(x, y)
	-- Draws the entity but skips inactive ones. Pass in the camera's position in the world.
	-- TODO: Write me! Currently just draws a square based on its position and size.
	if not self.active then return end
	love.graphics.rectangle("fill", self.x - x, self.y - y, self.width, self.height)
end

function Entity:move(deltaX, deltaY)
	self.x, self.y = self.x + deltaX, self.y + deltaY
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
