package gtv;
import flash.geom.Point;
import flash.text.TextFormat;
import gtv.geom.Orientation;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Settings 
{
	public var orientation:Orientation;		// gen tree orientation
	public var mainMargin:Point;			// scene margin
	public var movieSize:Point;				// non-fullscreen size of flash app	
	public var cellSize:Point;				// any 1 cell size
	public var cellMargin:Point;			// cell margin
	public var url:String;					// url
	public var enlargeFontOnZoomOut:Bool;	// This feature make bigger font when scene is zoomed out
	
	// TextField
	public var textFormat:TextFormat;		// Default text label format
	public var fontSize:Int;				// font size for regular label
	
	// colors
	public var colorKids:UInt;				// Kids lines color
	public var colorSpouse:UInt;			// Spouses lines color
	public var colorMainBack:UInt;			// Main background color

	// debug
	public var debug:Bool;					// true - debug info on
	
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
		cellMargin = new Point(48, 128);
		fontSize = 12;
		url = "tree.xml";
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