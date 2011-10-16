package gtv.data.processors;
import gtv.data.GenTreeItem;
import gtv.data.GenTreeItemPosStatus;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class GenCollectProcessor implements IProcessor
{
	public var srcGenerations:Array<Array<GenTreeItem>>;
	public var dstGenerations:Array<Array<GenTreeItem>>;

	public function new() 
	{
		srcGenerations = new Array<Array<GenTreeItem>>();
		dstGenerations = new Array<Array<GenTreeItem>>();
		
	}
	
	public function process(p:GenTreeItem) {
		if (p != null) {
			
			var gen:Int = cast(p.pos.y, Int);
			
			if (srcGenerations[gen] == null) {
				srcGenerations[gen] = new Array<GenTreeItem>();
			}
			
			srcGenerations[gen][srcGenerations[gen].length] = p;
		}
	}

	/**
	 * Get max x from array
	 */
	function getMaxX(array:Array<Array<GenTreeItem>>) {
		
		var retVal:Float = 0;
		
		for ( gen in 0...array.length) {
			
			if (array[gen].length > retVal) {
				retVal = array[gen].length;
			}
		}
		
		return retVal;
	}
	
	/**
	 * Bet kaip sudestytu kartoje elementu perrinkimas 
	 */
	public function correctPositions() {
		
		var index:Float = 0;

		// X calc
		for ( gen in 0...srcGenerations.length) {
			for (i in 0...srcGenerations[gen].length) {
				if (!srcGenerations[gen][i].posXCalculated) {
					srcGenerations[gen][i].calcPositionX(index);
					
					index += 10;
				}
			}
		}
/*
		// perdestymas
		for ( gen in 0...srcGenerations.length) {
			while (srcGenerations[gen].length > 0 ) {
				srcGenerations[gen][0].collect(getMaxX());
			}
		}
*/		
/*
		// poziciju priskyrimas pagal perdestyta tvarka masyve
		for ( gen in 0...dstGenerations.length) {
			for ( item in 0...dstGenerations[gen].length) {
				dstGenerations[gen][item].pos.x = item;
			}
		}
*/
/*		
		// correct from bottom
		for ( item in 0...dstGenerations[dstGenerations.length - 1].length) {
			dstGenerations[dstGenerations.length - 1][item].correct(this);
		}
*/		
	}
}