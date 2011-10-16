package gtv.data;

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
	static inline var frameSize:Float = 50;
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
		
		buttonMode = true;
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		
		initLabels();
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
				this.x = settings.mainMargin.x + (getWidth() * pos.x + (pos.x * frameSize * horFactor));
				this.y = settings.mainMargin.y +(getHeight() * pos.y + (pos.y * frameSize * vertFactor));
			}
			else {
				this.x = settings.mainMargin.x + (getWidth() * pos.y + (pos.y * frameSize * horFactor));
				this.y = settings.mainMargin.y + (getHeight() * pos.x + (pos.x * frameSize * vertFactor));
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
	
	public function setShadow (alpha:Float, angle:Float) {
		this.filters = [new DropShadowFilter(alpha, angle)];
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
	
	public function drawLineTo (to:MovieClip, color:UInt, isDown:Bool) :Void {
		
		var bottomOffset:Float = 20;
		var topOffset:Float = 5;
		
		var sprite:Shape = new Shape();
		sprite.graphics.lineStyle(1, color);
		
		sprite.graphics.moveTo(
			this.x + (this.width / 2), 
			this.y + (isDown? this.height - bottomOffset: topOffset));// (isDown? (y + height) - 20: y + 20));
			
		sprite.graphics.lineTo(
			to.x + (to.width / 2),
			to.y + (isDown ? topOffset: to.height -bottomOffset));
			
		sprite.graphics.endFill();
		
		parent.addChild(sprite);
	}
}
