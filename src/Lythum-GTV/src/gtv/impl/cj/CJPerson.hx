package gtv.impl.cj;
import gtv.data.Person;
import gtv.Gui;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class CJPerson extends Person
{
	public function new(settings:Settings) 
	{
		super(settings);
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
				
				if (familyBorn.isCanDraw(true)) {
					
					//	drawLineTo(familyBorn, settings.colorKids, false);
					
					Gui.drawKidRelation(
						parent,
						settings,
						familyBorn,
						this);
					
				
					familyBorn.drawLines();
				}
			}
			
			for (i in 0...families.length) {
				if (families[i].isCanDraw(true)) {
					
					Gui.drawSpouseRelation(
						parent,
						settings,
						families[i],
						this);

					//drawLineTo(families[i], settings.colorSpouse, true);

					families[i].drawLines();
				}
			}
		}
		
		return retVal;
	}
}