package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import map.Level;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _level:Level;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_level = new Level("maps/main.tmx");

		add(_level.backgroundGroup);
		add(_level.collisionGroup);
		add(_level.foregroundGroup);

		FlxG.camera.bounds = _level.getBounds();
		FlxG.worldBounds.copyFrom(_level.getBounds());

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		_level.update();

		super.update();
	}	
}
