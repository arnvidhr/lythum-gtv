package gtv.data.processors;
import flash.geom.Point;
import gtv.data.GenTreeItem;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class PosCorrectionProcessor implements IProcessor
{
	public var correctionMode:Bool;
	public var lowest:Point;
	public var correction:Point;
	public var reqCorrectY:Bool;
	public var reqCorrectX:Bool;

	public function new() 
	{
		lowest = null;
		correctionMode = false;
	}
	
	public function process(p:GenTreeItem) {
		if (p != null) {
			
			if (!correctionMode) {
				collect(p);
			}
			else {
				correct(p);
			}
			
		}
	}
	
	function collect (p:GenTreeItem) {
		
		if (lowest == null) {
			lowest = new Point(
				p.pos.x,
				p.pos.y);
		}
		else {
			if (p.pos.y < lowest.y) {
				lowest.y = p.pos.y;
			}
		
			if (p.pos.x < lowest.x) {
				lowest.x = p.pos.x;
			}
		}
	}
	
	public function calcCorrection() {

		this.reqCorrectX = lowest.x < 0;
		this.reqCorrectY = lowest.y < 0;
		
		correction = new Point(
			0 - lowest.x,
			0 - lowest.y);
		
		correctionMode = true;
	}
	
	function correct (p:GenTreeItem) {
		
		if (reqCorrectX) {
			p.pos.x += correction.x;
		}
		
		if (reqCorrectY) {
			p.pos.y += correction.y;
		}
	}
}
