package gtv.data;
import flash.events.MouseEvent;
import flash.text.TextField;

import gtv.Settings;
import gtv.data.GenTreeItem;
import gtv.data.processors.GenCollectProcessor;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class Family extends GenTreeItem
{
	// vars
	public var marriage:GenEvent;
	public var parents:Array<Person>;
	public var kids:Array<GenTreeItem>;
	
	public var wife:Person;
	public var husband:Person;
	
	public function new(settings:Settings) 
	{
		super(settings);
		parents = new Array<Person>();
		kids = new Array<GenTreeItem>();
		
		this.addChild(label);

	}
	
	override public function setHilight(h:Bool):Void 
	{
		super.setHilight(h);

		// parents
		for (i in 0...parents.length) {
			parents[i].hilight = h;
			parents[i].redraw(false);
		}
		
		// kids
		for (i in 0...kids.length) {
			kids[i].hilight = h;
			kids[i].redraw(false);
		}
	}
	
	override public function validate():Bool 
	{
		var retVal:Bool = super.validate();
		
		if (parents.length > 0 || kids.length > 0) {
			retVal = true;
		}
		
		return retVal;
	}
	
	/**
	 * Add parent
	 * @param	p
	 */
	public function addParent(p:Person) {
		if (p != null) {
			//trace(id +" addParent " + p.name);
			parents[parents.length] = p;
			
			p.families[p.families.length] = this;
			
			if (p.isFemale()) {
				wife = p;
			}
			else {
				husband = p;
			}
		}
	}
	
	/**
	 * Add kid
	 * @param	p
	 */
	public function addKid (p:Person) {
		if (p != null) {
			//trace(id + " addKid " + p.name);
			// add new kid
			kids[kids.length] = p;
			
			// assign family for kid where he born
			p.familyBorn = this;
		}
	}
	
	override public function calcPositionY(posY:Float):Bool 
	{
		var retVal:Bool = super.calcPositionY(posY);
		
		if (retVal) {
			
			for (i in 0...parents.length) {
				parents[i].calcPositionY(pos.y - 1);
			}
			
			for (i in 0...kids.length) {
				kids[i].calcPositionY(pos.y + 1);
			}
			
		}
		
		return retVal;

	}
	
	override public function calcPositionX(posX:Float):Float 
	{
		var index:Float = super.calcPositionX(posX);
		var someAssigned:Bool = false;
		
		// kids
		for (i in 0...kids.length) {
			if (!kids[i].posXCalculated) {
				
				if (someAssigned) {
					index++;
				}
				else {
					someAssigned = true;
				}
				
				index = kids[i].calcPositionX(index);
			}
		}
		
		// parents
		someAssigned = false;
		var familyIndex:Float = posX+1;
		for (i in 0...parents.length) {
			if (!parents[i].posXCalculated) {
				
				if (someAssigned) {
					familyIndex++;
				}
				else {
					someAssigned = true;
				}
				
				familyIndex = parents[i].calcPositionX(familyIndex);
				
			}
		}
		return (index > familyIndex? index : familyIndex);
	}
}