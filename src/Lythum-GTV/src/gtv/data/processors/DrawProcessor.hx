package gtv.data.processors;
import gtv.data.GenTreeItem;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class DrawProcessor implements IProcessor
{

	var overrideDraw:Bool;
	
	public function new(overrideDraw:Bool) 
	{
		this.overrideDraw = overrideDraw;
	}
	
	public function process(p:GenTreeItem) {
		if (p != null) {
			p.draw(overrideDraw);
		}
	}
	
}