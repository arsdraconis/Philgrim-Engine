# Design Notes

## General Notes and Ideas
* We shouldn't have camera rendering everything, that's not it's job. It should just store graphics stuff and accessors for modifying it. We can pass the camera around when we do need to render something.
* A decent object oriented system would be nice. Not sure how to go about it, however. In the mean time, I'll hack inheritance into the damn thing.
* We need a generalized collision detection function in Map that Character can call during move(). Right now it's all in Character, which is ugly.
* Right now map scrolling parameters are floats. Why no make them ints, then divide 1 with them in Map:update().

## Problems
1.	Do we really need a type identification system for objects? Should we just rely on Lua to choke when something's not the right type?
2.	To render the map correctly, we need to add 1 to the viewport dimensions in Map:update(). Is this my fuck up? YES. See map notes below.
3.	I need to decouple code. I must research this.
4.	Collision detection resulted in having to add tileSize to a bunch of parameters passed in Character:move(). FIXED, sort of. This was due to the above, #2.
5.	How are we going to keep track of levels? There should be constants, perhaps in a level table in a file that lists all level names as strings and their source file.
6.	How are we going to store, set up, and configure the different entities in a level?
7. Background map layer does not render completely. Why? I want to say this is due to #2 as well.

## Game Table Notes
Add accessors to the game table to get stuff like the current map, level, camera, etc.

The game table should contain the global entity table. Either that or the Level object. Basically, it should track all general game state.

The camera system can support multiple cameras by setting some as "active" and rendering them ourselves. This would not be easy if we want cameras active in multiple parts of the level.

## Map Notes
The map data is a 1D array. Assuming you want the coordinate (x, y), find the tile using this:

	mapWidth * y + x + 1

FIXED: Map coordinates are zero indexed with the origin point at the top left. This means the tile at the top left of the world is coordinate (0,0).

Access to map data is abstracted away in `Map:getTile(x, y)`.

Tilesets are loaded separately to allow us to swap out tilesets without changing map data. The tileset image gets sliced into quads and stored in a tiles table.

Every frame, we calculate the map tiles that will be on screen and stick them into tiles.batch, which then gets drawn in drawMap(). This keeps us from drawing offscreen tiles while keeping the whole map in memory.

We need to find a way to take Z indexes into account while drawing maps.

##Entity Notes
The base entity class will serve as a root object for all entities. It will define prototypes and primitive methods common to all entities.

To subclass Entity, create a constructor like this:

function MyEntity:new(x, y, width, height, args...)
	local object = Entity:new(x, y, width, height)
	object.args = args
	return object
end

Since the Entity constructor sets the metatable to Entity, any functions not implimented in MyEntity would be looked up in Entity. To subclass MyEntity, the new subclass's metatable needs to be set to MyEntity.