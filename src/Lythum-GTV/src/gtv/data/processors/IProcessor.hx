package gtv.data.processors;
import gtv.data.GenTreeItem;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

interface IProcessor 
{
	function process (p:GenTreeItem):Void;
}