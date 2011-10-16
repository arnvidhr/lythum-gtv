package gtv;
import flash.geom.Point;
import flash.text.TextFormat;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

 enum Orientation {
	Vertical;
	Horizontal;
}

class Settings 
{
	public var orientation:Orientation;
	public var mainMargin:Point;
	public var movieSize:Point;
	public var cellSize:Point;
	public var url:String;
	public var fontSize:Int;
	
	// textFormat
	public var textFormat:TextFormat;
	
	public var debug:Bool;

	public function new(params:Dynamic<String>) 
	{
		orientation = Orientation.Vertical;
		mainMargin = new Point(500, 500);
		movieSize = new Point(800, 600);
		cellSize = new Point(200, 100);
		url = "tree.xml";
		fontSize = 12;
		
		// textformat
		textFormat = new TextFormat();
		textFormat.size = fontSize;
		textFormat.font = "Arial";// "Times New Roman";
		textFormat.bold = true;
		
		// debug
		debug = false;
		
		init(params);
	}
	
	function init (params:Dynamic<String>) {
		
	}
	
}