package gtv.data;
import flash.geom.Point;
import gtv.data.processors.GenCollectProcessor;
import gtv.data.processors.ValidationProcessor;

import gtv.data.processors.IProcessor;
import gtv.data.processors.DrawProcessor;
import gtv.data.processors.PosCorrectionProcessor;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class GeneologyTree 
{
	public var persons: Array<Person>;
	public var families: Array<Family>;
	public var generations: Dynamic;

	public function new() 
	{
		persons = new Array<Person>();
		families = new Array<Family>();
		
		generations = new Array<Array<GenTreeItem>>();
	}

	public function searchPerson (id:String):Person {
		
		for (i in 0...persons.length) {
			if (persons[i].id == id) {
				return persons[i];
			}
		}
		return null;
	}
	
	public function searchFamily (id:String):Family {
		
		for (i in 0...families.length) {
			if (families[i].id == id) {
				return families[i];
			}
		}
		return null;
	}
	
	/**
	 * validate loaded xml
	 * @return true - ok
	 */
	public function validate ():Bool {
		
		var retVal:Bool = true;
		
		if (persons.length < 1) {
			retVal = false;
			trace("* ERROR * 0 persons loaded!");
		}
		
		var validator:ValidationProcessor = new ValidationProcessor();
		processAll(validator);
		
		if (validator.wrongRecords.length > 0) {
			//retVal = false;

			if (validator.wrongRecords.length > 0) {
				// dump all wrong
				for (i in 0...validator.wrongRecords.length) {
					validator.wrongRecords[i].traceYourself();
				}
				trace("* WARNING * found " + validator.wrongRecords.length +" unrelated records, they was wiped, end of they dump.");
			}
			
			validator.wipeWrong(this);
		}
		
		return retVal;
	}
	
	public function addPerson (p:Person) {
		if (p != null) {
			persons[persons.length] = p;
		}
	}
	
	public function addFamily(f:Family) {
		if (f != null) {
			families[families.length] = f;
		}
	}
	

	/**
	 * Deployment of tree
	 * 
	 */
	public function deploy() {
		calcPosY();
		calcPosX();
		drawAll();
		
		this.persons[0].drawLines();
	}
	
	
	function calcPosX () {
		
		var genCollector:GenCollectProcessor = new GenCollectProcessor();
		
		// collect items by generation
		processAll(genCollector);
		
		// correct items possitions
		genCollector.correctPositions();
		
		//processAll(new FakeXCalcProcessor());
	}
	
	function calcPosY () {
		persons[0].calcPositionY(0);
		
		correctPositions();
	}
	
	function correctPositions () {
		
		var proc:PosCorrectionProcessor = new PosCorrectionProcessor();
		processAll(proc);
		proc.calcCorrection();
		processAll(proc);
		
	}
	
	function drawAll () {
		processAll(new DrawProcessor(false));
	}
	
	public function processAll (p:IProcessor) {
		processPersons(p);
		processFamilies(p);
	}

	public function processPersons(p:IProcessor) {

		if (p != null) {
			
			for (i in 0...persons.length) {
				p.process(persons[i]);
			}
			
		}
	}
	
	public function processFamilies(p:IProcessor) {

		if (p != null) {
			
			for (i in 0...families.length) {
				p.process(families[i]);
			}
			
		}
	}


}