package gtv.data;
import flash.display.NativeMenuItem;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;
import gtv.data.GenTreeItemPosStatus;
import gtv.data.processors.GenCollectProcessor;
import gtv.Settings;

import gtv.data.GenTreeItem;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Person extends GenTreeItem
{
	// const
	
	// vars
	public var gender:String;
	public var birth:GenEvent;
	public var death:GenEvent;
	public var personName:String;
	
	public var familyBorn:Family;
	public var families:Array<GenTreeItem>;
	
	public function new(settings:Settings) 
	{
		super(settings);
		
		gender = null;
		birth = null;
		death = null;
		familyBorn = null;

		this.addChild(label);
		
		families = new Array<GenTreeItem>();
	}
	
	public function isFemale () {
		if (gender == "F") {
			return true;
		}
		else {
			return false;
		}
	}
	
	override public function onMouseDown(e:MouseEvent):Void 
	{
		super.onMouseDown(e);
		
		if (familyBorn != null) {
			familyBorn.hilight = true;
			familyBorn.redraw(false);
		}
		
		for (i in 0...families.length) {
			families[i].hilight = true;
			families[i].redraw(false);

			// sutuoktiniai
			if (isFemale()) {
				if (families[i].husband != null) {
				
					families[i].husband.hilight = true;
					families[i].husband.redraw(false);
				}
			}
			else {
				if (families[i].wife != null) {
				
					families[i].wife.hilight = true;
					families[i].wife.redraw(false);
				}
			}
			
		}
	}
	
	override public function onMouseUp(e:MouseEvent):Void 
	{
		super.onMouseUp(e);

		if (familyBorn != null) {
			familyBorn.hilight = false;
			familyBorn.redraw(false);
		}
		
		for (i in 0...families.length) {
			families[i].hilight = false;
			families[i].redraw(false);

			// sutuoktiniai
			if (isFemale()) {
				if (families[i].husband != null) {
				
					families[i].husband.hilight = false;
					families[i].husband.redraw(false);
				}
			}
			else {
				if (families[i].wife != null) {
				
					families[i].wife.hilight = false;
					families[i].wife.redraw(false);
				}
			}
		}
	}
	
	override public function getColor():UInt 
	{
		var retVal:UInt;
		
		if (isFemale()) {
			retVal = 0xD588C7;
		}
		else {
			
			retVal = 0x72ABEB;
		}
		
		if (hilight) {
			retVal = 0xFFFFFF;
		}
		
		return retVal;
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

	override public function collect(gcp:GenCollectProcessor):Bool 
	{
		var retVal:Bool = super.collect(gcp);
		
		if (retVal) {
			
			for (i in 0...families.length) {
				families[i].collect(gcp);
			}
			
			if (familyBorn != null) {
				familyBorn.collect(gcp);
			}
		}
		
		return retVal;
	}

	
	override public function draw(overrideDraw:Bool):Bool 
	{
		if (super.draw(true)) {
			
			if(!overrideDraw){ 
				graphics.beginFill(getColor());
			}

			if (isFemale()) {
				graphics.drawRoundRect(0, 0, getWidth(), getHeight(),30, 30);
			}
			else {
				graphics.drawRect(0, 0, getWidth(), getHeight());
			}
			graphics.endFill();
					
			label.text = personName;
			label.x = 5;
			label.y = 5;
			label.width = width - 10;
			label.height = height - 10;
			label.wordWrap = true;
			
					
			// debug
			if (settings.debug && familyBorn != null) {
				label.text += " (" + familyBorn.id + ")";
			}
					
			if (birth != null) {
				label.text += "\rg. " + birth.date;
						
				if (birth.place != null) {
					label.text += "\r" +birth.place;
				}
			}
						
			if (death != null) {
				label.text += "\rm. " + death.date;

				if (death.place != null) {
					label.text += "\r" + death.place;
				}
			}
			
			return true;
		}
		
		return false;
	}
	
	override public function drawLines():Bool
	{
		var retVal:Bool = super.drawLines();
		
		if (retVal) {
			if (familyBorn != null) {
				if(familyBorn.isCanDraw(true)){
					drawLineTo(familyBorn, Family.colorKids, false);
					familyBorn.drawLines();
				}
			}
			
			for (i in 0...families.length) {
				if(families[i].isCanDraw(true)){
					drawLineTo(families[i], Family.colorSpouse, true);
					families[i].drawLines();
				}
			}
		}
		
		return retVal;
	}

}