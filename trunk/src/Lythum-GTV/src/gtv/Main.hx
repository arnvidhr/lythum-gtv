package gtv;

import flash.Lib;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.SampleDataEvent;
import flash.geom.Point;

import gtv.data.load.LoaderBase;
import gtv.impl.cj.CJLoader;
import gtv.impl.cj.CJSettings;
import gtv.MainScene;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Main 
{
    private var _loader:	LoaderBase;
	private var _settings: 	Settings;
	private var _scene:		MainScene;
	
	static function main() 
	{
		new Main();
	}
	
	public function new() {
		
		// init settings
		_settings = new CJSettings(
			flash.Lib.current.loaderInfo.parameters);
		
		// init main scene
		_scene = new MainScene(
			Lib.current, _settings);
			
		// add main scene to display
		Lib.current.addChild(_scene);
		
		// init loader
		_loader = new CJLoader(
			_scene, _settings);
			
		// load
		_loader.addEventListener(Event.COMPLETE, loaded);
		_loader.loadFile(_settings.url);
	}
	
	
	private function loaded( e: Event ):Void 
	{
		_loader.deploy();
	}
	
}