# Design Notes

## General Notes and Ideas
* A decent object oriented system would be nice. Not sure how to go about it, however. In the mean time, I'll hack inheritance into the damn thing.
* We need a generalized collision detection function in Map that Character can call during `move()`. Right now it's all in Character, which is ugly. Note: This shouldn't be in map.
* Right now map scrolling parameters are floats. Why no make them ints, then divide 1 with them in `Map:update()`.
* Need to investigate state machines to implement character behavior.
* The camera system can support multiple cameras by setting some as "active" and rendering them ourselves. This would not be easy if we want cameras active in multiple parts of the level.


## Problems & Issues
1.	Do we really need a type identification system for objects? Should we just rely on Lua to choke when something's not the right type?
2.	Collision detection resulted in having to subtract tileSize from a bunch of parameters in `Character:move()`. This may be due to a problem in the actual collision detection code.
3.	How are we going to keep track of levels? There should be constants, perhaps in a level table in a file that lists all level names as strings and their source file.
4.	How are we going to store, set up, and configure the different entities in a level?
5. We need to find a way to take Z indexes into account while drawing maps.

## Infrastructure

### Overview
The engine is composed of the following objects. 

* Game - Not an object per se, just a table used to hold game state (like a reference to the current level) and general associated functions (to, say, draw the pause menu).
* Camera - Stores information about what to draw and how to draw it.
* Map - A single map layer and its associated tile data.
* Entity - The base object for stuff in a level. This is dumb stuff that doesn't do much but needs to `update()` and `draw()` each frame, like items, scenery, triggers.
* Character - Derives from Entity. This is basic movement stuff for all movable entities. This should have a basic state machine framework we can add on to to customize behavior.
* Player - Derives from Character. Used for player state, movement, etc.
* Enemy - Derives from Character. Used for enemies in a level, keeping track of state and associated data. 
* Level - Stores methods designed to set up a level and keep track of its state. 

### The Game Table
The game table tracks all basic game state. It also contains helper functions designed to initialize the game, load levels, draw UI, etc.

### Camera
The camera doesn't do much. It's just used to set graphics state and keep track of where to draw. It gets passed around to drawable objects and they use it to figure out how/where to draw themselves.

### Levels
Level objects are subclassed to implement levels. Here, they can define their own state and methods. Each level is stored in its own file which gets accessed by Game through `loadLevel()`.

### Map
The map data is a 1D array. Assuming you want the coordinate (x, y), find the tile using this:

	mapWidth * y + x + 1

However, access to map data is abstracted away in `Map:getTile(x, y)`. Use this method instead.

Map coordinates are zero indexed with the origin point at the top left. This means the tile at the top left of the world is coordinate (0, 0).

#### Tilesets
Tilesets are loaded separately to allow us to swap out tilesets without changing map data. The tileset image gets sliced into quads and stored in a tiles table.

Every frame, we calculate the map tiles that will be on screen and stick them into tiles.batch, which then gets drawn in `Map:draw()`. This keeps us from drawing offscreen tiles while keeping the whole map in memory.

### Entities
The base entity class will serve as a root object for all entities. It will define abstract and primitive methods common to all entities with basic behavior for stuff that doesn't really move.

To subclass Entity, create a constructor like this:

	function MyEntity:new(x, y, width, height, args...)
		local object = Entity:new(x, y, width, height)
		object.args = args
		return object
	end

Since the Entity constructor sets the metatable to Entity, any functions not implimented in MyEntity would be looked up in Entity. To subclass from MyEntity, the new subclass's metatable needs to be set to MyEntity.