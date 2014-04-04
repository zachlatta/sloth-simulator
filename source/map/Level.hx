package map;

import entities.Character;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTile;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxSort;

class Level extends TiledMap
{
	private inline static var PATH_TILESETS = "maps/";

	public var backgroundGroup:FlxTypedGroup<FlxTilemapExt>;
	public var collisionGroup:FlxTypedGroup<FlxTilemapExt>;
	public var foregroundGroup:FlxTypedGroup<FlxTilemapExt>;

	public var characterGroup:FlxTypedGroup<Character>;

	private var bounds:FlxRect;

	public function new(level:Dynamic)
	{
		super(level);

		foregroundGroup = new FlxTypedGroup<FlxTilemapExt>();
		collisionGroup = new FlxTypedGroup<FlxTilemapExt>();
		backgroundGroup = new FlxTypedGroup<FlxTilemapExt>();

		characterGroup = new FlxTypedGroup<Character>();

		bounds = new FlxRect(0, 0, fullWidth, fullHeight);

		var tileset:TiledTileSet;
		var tilemap:FlxTilemapExt;
		var layer:TiledLayer;

		for (layer in layers)
		{
			if (layer.properties.contains("tileset"))
			{
				tileset = this.getTileSet(layer.properties.get("tileset"));
			}
			else
			{
				throw "Each layer needs a tileset property with the tileset name.";
			}

			if (tileset == null)
			{
				throw "The tileset is null";
			}

			tilemap = new FlxTilemapExt();
			tilemap.widthInTiles = layer.width;
			tilemap.heightInTiles = layer.height;

			tilemap.loadMap(
					layer.tileArray,
					PATH_TILESETS + tileset.imageSource,
					tileset.tileWidth,
					tileset.tileHeight,
					FlxTilemap.OFF,
					tileset.firstGID
			);

			tilemap.alpha = layer.opacity;

			if (layer.properties.contains("fg"))
			{
				foregroundGroup.add(tilemap);
			}
			else if (layer.properties.contains("bg"))
			{
				backgroundGroup.add(tilemap);
			}
			else
			{
				collisionGroup.add(tilemap);
			}
		}

		loadObjects();
	}

	public function loadObjects():Void {
		for (group in objectGroups) {
			for (object in group.objects) {
				loadObject(object, group);
			}
		}
	}

	public function loadObject(o:TiledObject, g:TiledObjectGroup) {
		var x:Int = o.x;
		var y:Int = o.y;

		switch (o.type.toLowerCase()) {
			case "player":
				var player:Character = new Character(o.name, x, y, "images/character/" + o.name + ".json");
				player.setBoundsMap(this.getBounds());
				player.controllable = true;
				FlxG.camera.follow(player);
				characterGroup.add(player);
		}
	}

	public function update():Void {
		updateCollisions();
		updateEventsOrder();
	}

	public function updateCollisions():Void {
		FlxG.collide(characterGroup, collisionGroup);
	}

	public function updateEventsOrder():Void {
		characterGroup.sort(FlxSort.byY);
	}

	public function getBounds():FlxRect
	{
		return bounds;
	}
}
