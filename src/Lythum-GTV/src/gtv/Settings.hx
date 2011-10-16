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
	/**
	 * This feature make bigger font when scene is zoomed out
	 */
	public var enlargeFontOnZoomOut:Bool;
	
	// textFormat
	public var textFormat:TextFormat;
	
	// colors
	public var colorKids:UInt;
	public var colorSpouse:UInt;
	public var colorMainBack:UInt;

	// debug flag
	public var debug:Bool;
	
	// parameters
	private var _params:Dynamic<String>;

	public function new(params:Dynamic<String>) 
	{
		_params = params;
		initDefaults();
		init(params);
	}
	
	/**
	 * Init of default values 
	 * as can be no any parameters
	 */
	function initDefaults() {
		
		orientation = Orientation.Vertical;
		mainMargin = new Point(500, 500);
		movieSize = new Point(800, 600);
		cellSize = new Point(200, 100);
		url = "tree.xml";
		fontSize = 12;
		enlargeFontOnZoomOut = true;
		
		// textformat
		textFormat = new TextFormat();
		textFormat.size = fontSize;
		textFormat.font = "Arial";// "Times New Roman";
		textFormat.bold = true;
		
		// colors
		colorKids				= 0x000099;
		colorSpouse				= 0xFF3300;
		colorMainBack			= 0xffEEAA;
		
		// debug
		debug = false;
		
	}
	
	/**
	 * parameters parsing
	 * @param	params
	 */
	function init (params:Dynamic<String>) {
		// TODO: Parse command line
	}
	
}