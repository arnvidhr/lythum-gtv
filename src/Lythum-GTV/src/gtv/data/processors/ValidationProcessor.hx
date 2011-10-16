package gtv.data.processors;
import gtv.data.Family;
import gtv.data.GeneologyTree;
import gtv.data.GenTreeItem;
import gtv.data.Person;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class ValidationProcessor implements IProcessor
{

	public var wrongRecords:Array<GenTreeItem>;
	
	public function new() 
	{
		wrongRecords = new Array<GenTreeItem>();
	}
	
	public function process (p:GenTreeItem) {
		if (p != null) {
			if (!p.validate()) {
				wrongRecords[wrongRecords.length] = p;
			}
		}
	}
	
	
	public function wipeWrong (tree:GeneologyTree) {
		
		for (i in 0...wrongRecords.length) {
			
			var o:GenTreeItem = wrongRecords[i];
			
			if ( Std.is(o, Person)) {
				tree.persons.remove(cast(o, Person));
			}
			else if (Std.is(o, Family)) {
				tree.families.remove(cast(o, Family));
			}
			
		}
		
	}
}