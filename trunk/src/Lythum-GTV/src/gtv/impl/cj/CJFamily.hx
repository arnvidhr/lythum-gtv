package gtv.impl.cj;
import flash.text.TextField;
import gtv.data.Family;
import gtv.Settings;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class CJFamily extends Family
{

	public function new(settings:Settings) 
	{
		super(settings);
	}
	
	override public function getColor():UInt 
	{
		if(hilight){
			return 0xFFFFFF;
		}
		else {
			return 0xCFCD8D;
		}
	}
	
		override public function draw(overrideDraw:Bool):Bool 
	{
		if (super.draw(overrideDraw)) {
			
			if(parents.length>0){
				label.text = (settings.debug?"(" + id + ")":"");
				label.x = 5;
				label.y = 5;
				label.width = this.width-10;
				label.height = this.height-10;
				label.wordWrap = true;
				
				
				// husband
				if (husband != null ) {
					label.text += husband.personName;
				}
				else {
					label.text += "***";
				}
				
				label.text += " ir ";
				
				// wife
				if (wife != null) {
					label.text += wife.personName;
				}
				else {
					label.text += "***";
				}
				
				if (marriage != null) {
					label.text += "\rs. " + marriage.date;
					
					if (marriage.place != null) {
						label.text += "\r" +marriage.place;
					}
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
			for (i in 0...kids.length) {
				if(kids[i].isCanDraw(true)){
					drawLineTo(kids[i], Family.colorKids, true);
					kids[i].drawLines();
				}
			}
		
			for (i in 0...parents.length) {
				if(parents[i].isCanDraw(true)){
					drawLineTo(parents[i], Family.colorSpouse, false);
					parents[i].drawLines();
				}
			}

		}
		
		return retVal;
	}
}