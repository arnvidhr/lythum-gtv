package gtv;
import flash.display.DisplayObjectContainer;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;
import gtv.geom.Orientation;
import gtv.geom.PointType;

import gtv.Settings;
import gtv.data.Family;
import gtv.data.Person;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Gui 
{
	public function new() 
	{
	}
	
	/**
	 * Simple line drawing
	 * @param	parentObject	Object to attach line shape
	 * @param	from			From coordinates
	 * @param	to				To Coordinates
	 * @param	color			Line color
	 * @param	lineSize		Line size (default = 1)
	 */
	public static function drawLine (
		parent:DisplayObjectContainer,
		from:Point,
		to:Point,
		color:UInt,
		lineSize:Float = 1) : Void
	{
		var s:Shape = new Shape();
		parent.addChild(s);
		
		s.graphics.lineStyle(
			lineSize, color);
			
		s.graphics.moveTo(
			from.x, from.y);
		
		s.graphics.lineTo(
			to.x, to.y);
	}
	
	/**
	 * Draws array of lines
	 * 
	 * @param	parent
	 * @param	coords
	 * @param	color
	 * @param	lineSize
	 */
	public static function drawLines(
		parent:DisplayObjectContainer,
		coords:Array<Point>,
		color:UInt,
		lineSize:Float = 1) : Void
	{
		if (coords != null) {
			
			var previousCoords:Point = coords[0];
			
			for (i in 1...coords.length) {
				drawLine(
					parent,
					previousCoords,
					coords[i],
					color,
					lineSize);
					
				previousCoords = coords[i];
			}
		}
	}

	/**
	 * Draw family and spouse relation
	 * 
	 * @param	settings	app settings
	 * @param	family		family object
	 * @param	spouse		spouse object
	 */
	public static function drawSpouseRelation (
		parent:DisplayObjectContainer,
		settings:Settings, 
		family:Family, 
		spouse:Person):Void 
	{
		if (settings.orientation == Orientation.Vertical) {
			
			var lines:Array<Point> = [
					family.getPoint(PointType.TopCenter),
					family.getPoint(PointType.TopMax),
					spouse.getPoint(PointType.BottomMax),
					spouse.getPoint(PointType.BottomCenter)
				];
			
			drawLines(
				parent,
				lines,
				settings.colorSpouse);
			
		}
		else {
			var lines:Array<Point> = [
					family.getPoint(PointType.LeftCenter),
					family.getPoint(PointType.LeftMax),
					spouse.getPoint(PointType.RightMax),
					spouse.getPoint(PointType.RightCenter)
				];
			
			drawLines(
				parent,
				lines,
				settings.colorSpouse);
		}
	}
	
	/**
	 * 
	 * @param	settings	app settings
	 * @param	family		family object
	 * @param	kid			kid object
	 */
	public static function  drawKidRelation (
		parent:DisplayObjectContainer,
		settings:Settings, 
		family:Family, 
		kid:Person) :Void 
	{
		if (settings.orientation == Orientation.Vertical) {
			
			var lines:Array<Point> = [
					family.getPoint(PointType.BottomCenter),
					family.getPoint(PointType.BottomMax),
					kid.getPoint(PointType.TopMax),
					kid.getPoint(PointType.TopCenter)
				];
			
			drawLines(
				parent,
				lines,
				settings.colorKids);
			
		}
		else {
			
			var lines:Array<Point> = [
					family.getPoint(PointType.RightCenter),
					family.getPoint(PointType.RightMax),
					kid.getPoint(PointType.LeftMax),
					kid.getPoint(PointType.LeftCenter)
				];
			
			drawLines(
				parent,
				lines,
				settings.colorKids);
			
		}
	}
	
}