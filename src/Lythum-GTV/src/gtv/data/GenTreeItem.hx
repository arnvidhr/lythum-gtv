package gtv.data;

import flash.display.GradientType;
import flash.display.MovieClip;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.ConvolutionFilter;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFormat;
import gtv.geom.Orientation;
import gtv.geom.PointType;
import gtv.Gui;

import gtv.Settings;
import gtv.data.processors.GenCollectProcessor;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

/**
 * It's just base class for implementation
 * Contains just core tree item stuff
 */
class GenTreeItem extends MovieClip
{
	static inline var vertFactor:Float = 2;
	static inline var horFactor:Float = 1;
	static inline var shadowFactor:Float = 2;
	
	public var id: String;
	public var settings:Settings;
	/**
	 * Position in matrix
	 * These coordinates will use draw method
	 */
	public var pos:Point;
	public var posXCalculated:Bool;
	public var posYCalculated:Bool;
	
	public var hilight:Bool;
	public var linesDrawn:Bool;
	
	public var label:TextField;

	public function new(settings:Settings) 
	{
		super();
		
		this.settings = settings;
		
		pos = new Point(0, 0);
		posXCalculated = false;
		posYCalculated = false;
		//
		hilight = false;
		linesDrawn = false;
		
		// if visible=true then object already drawn
		this.visible = false;
		
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		
		initLabels();

		buttonMode = true;
	}
	
	function initLabels():Void {
		
		label = new TextField();
		label.defaultTextFormat = settings.textFormat;
	}
	
	public function getWidth():Float {
		return settings.cellSize.x;
	}
	
	public function getHeight():Float {
		return settings.cellSize.y;
	}
	
	public function onMouseDown(e:MouseEvent) :Void{
		setHilight(true);
		redraw(false);
	}
	
	public function onMouseUp (e:MouseEvent):Void {
		setHilight(false);
		redraw(false);
	}
	
	public function getColor ():UInt {
		return 0xffffff;
	}
	
	public function isCanDraw(ignoreVisible:Bool):Bool {
		
		if (ignoreVisible) {
			return posYCalculated && posXCalculated;
		}
		else {
			return !visible && posYCalculated && posXCalculated;
		}
	}
	
	public function validate():Bool {
		return false;
	}
	
	/**
	 * Sets hilight to related objects
	 * @param	h
	 */
	public function setHilight(h:Bool):Void {
		this.hilight = h;
	}
	
	/**
	 * Recursive
	 * calculate matrix pos.y
	 * 
	 * returns true if position was set
	 */
	public function calcPositionY (posY:Float) :Bool {
		if (!posYCalculated) {
			posYCalculated = true;
			
			pos.y = posY;
			
			//trace(id + " " +name + this.toString() + " " + posY);
			return true;
		}
		return false;
	}

	/**
	 * Recursive
	 * calculate matrix pos.x
	 * 
	 * returns max position
	 * if already processed will return -1
	 */
	public function calcPositionX (posX:Float) : Float {

		if (!posXCalculated) {
			posXCalculated = true;
			
			// assign position
			pos.x = posX;
			
			// return position
			return pos.x;
		}
		else {
			return -1;
		}
	}

	public static function checkItemExist(
		array:Array<GenTreeItem>, 
		item:GenTreeItem) : Bool {
			
		for (i in 0...array.length) {
			if (array[i] == item) {
				return true;
			}
		}
		
		return false;
	}
	
	public function redraw (overrideDraw:Bool) {
		this.visible = false;
		draw(overrideDraw);
	}
	
	/**
	 * Main draw function
	 * @param	overrideDraw - true - object can override drawing
	 * @return	true - if some override drawing was done
	 */
	public function draw (overrideDraw:Bool) :Bool {
		
		if (isCanDraw(false)) {
			visible = true;
		
			// width x position + frame
			if(settings.orientation == Orientation.Vertical){
				this.x = settings.mainMargin.x + ((getWidth() + settings.cellMargin.x) * pos.x);
				this.y = settings.mainMargin.y + ((getHeight() + settings.cellMargin.y) * pos.y);
			}
			else {
				this.x = settings.mainMargin.x + ((getWidth() + settings.cellMargin.x) * pos.y);
				this.y = settings.mainMargin.y + ((getHeight() + settings.cellMargin.y) * pos.x);
			}
			
			if (!overrideDraw) {
				graphics.clear();
				graphics.beginFill(getColor());
				graphics.drawRect(0, 0, getWidth(), getHeight());
				graphics.endFill();
			}
			
			setShadow(shadowFactor, 48);
			
			return true;
		}
		
		return false;
	}
	
	/**
	 * Draws lines
	 * @return
	 */
	public function drawLines () :Bool {
		
		if (!linesDrawn) {
			linesDrawn = true;
			
			return true;
		}
		
		return false;
		
	}
	
	public function drawLineTo (to:GenTreeItem, color:UInt, isDown:Bool) :Void {
		
		var bottomOffset:Float = 20;
		var topOffset:Float = 5;
		
		Gui.drawLine(
			parent,
			// from
			new Point(
				this.x + (this.width / 2), 
				this.y + (isDown? this.height - bottomOffset: topOffset)),// (isDown? (y + height) - 20: y + 20));
			// to
			new Point(
				to.x + (to.width / 2),
				to.y + (isDown ? topOffset: to.height -bottomOffset)),
			color);
	}

	/**
	 * function will apply shadow filter
	 * @param	alpha 
	 * @param	angle - shadow angle
	 */
	public function setShadow (alpha:Float, angle:Float) {
		this.filters = [new DropShadowFilter(alpha, angle)];
	}
	
	// Points
	public function getPoint ( t:PointType ) {
		
		// calculated just X
		var retVal:Point = new Point(
			x + (width / 2), 
			y + (height / 2));
		
		switch(t) {
			
			// vertical points
			case PointType.TopCenter:
				retVal.y = y;
					
			case PointType.TopMax:
				retVal.y = y - (settings.cellMargin.y / 2);
					
			case PointType.BottomCenter:
				retVal.y = y + height;
			
			case PointType.BottomMax:
				retVal.y = y + height + (settings.cellMargin.y / 2);
				
			// horizontal points
			case PointType.LeftCenter:
				retVal.x = x;
			
			case PointType.LeftMax:
				retVal.x = x - (settings.cellMargin.x / 2);
			
			case PointType.RightCenter:
				retVal.x = x + width;
			
			case PointType.RightMax:
				retVal.x = x + width + (settings.cellMargin.x / 2);
		}
		
		// probably never will happen
		return retVal;
	}
	
}
