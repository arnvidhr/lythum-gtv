package gtv.data;

import flash.display.NativeMenuItem;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import gtv.Settings;
import gtv.data.GenTreeItem;
import gtv.data.GenTreeItemPosStatus;
import gtv.data.processors.GenCollectProcessor;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Person extends GenTreeItem
{
	// vars
	public var gender:String;
	public var birth:GenEvent;
	public var death:GenEvent;
	public var personName:String;
	
	public var familyBorn:Family;
	public var families:Array<Family>;
	
	public function new(settings:Settings) 
	{
		super(settings);
		
		gender = null;
		birth = null;
		death = null;
		familyBorn = null;

		this.addChild(label);
		
		families = new Array<Family>();
	}
	
	public function isFemale () {
		if (gender == "F") {
			return true;
		}
		else {
			return false;
		}
	}
	
	/**
	 * Method set hilight
	 * @param	state
	 */
	override public function setHilight (h:Bool): Void {
		
		super.setHilight(h);
		
		// family born - hilight
		if (familyBorn != null) {
			familyBorn.hilight = h;
			familyBorn.redraw(false);
		}
		
		// families created - hilight
		for (i in 0...families.length) {
			families[i].hilight = h;
			families[i].redraw(false);

			// spouses - hilight
			if (isFemale()) {
				if (families[i].husband != null) {
				
					families[i].husband.hilight = h;
					families[i].husband.redraw(false);
				}
			}
			else {
				if (families[i].wife != null) {
				
					families[i].wife.hilight = h;
					families[i].wife.redraw(false);
				}
			}
		}
	}
	
	override public function validate():Bool 
	{
		var retVal:Bool = super.validate();
		
		if (families.length > 0 || familyBorn != null) {
			retVal = true;
		}
		
		return retVal;
	}
	
	override public function calcPositionY(posY:Float):Bool 
	{
		var retVal:Bool = super.calcPositionY(posY);
		
		if (retVal) {
			for (i in 0...families.length) {
				families[i].calcPositionY(pos.y + 1);
			}
			
			if (familyBorn != null) {
				familyBorn.calcPositionY(pos.y - 1);
			}
		}
		return retVal;
	}

	override public function calcPositionX(posX:Float):Float 
	{
		var index:Float = super.calcPositionX(posX);
		var someAssigned:Bool = false;

		
		for (i in 0...families.length) {
			if (!families[i].posXCalculated) {
				
				if (someAssigned) {
					index++;
				}
				else {
					someAssigned = true;
				}

				index = families[i].calcPositionX(index);
			}
		}
		
		return index;
	}
}