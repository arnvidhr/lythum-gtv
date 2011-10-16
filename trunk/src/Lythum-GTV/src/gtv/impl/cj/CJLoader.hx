package gtv.impl.cj;
import flash.display.MovieClip;
import flash.xml.XML;
import flash.xml.XMLList;
import gtv.data.load.LoaderBase;
import gtv.data.Family;
import gtv.data.GenEvent;
import gtv.data.Person;
import gtv.Settings;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class CJLoader extends LoaderBase
{
	/**
	 * XML TAGS
	 */
	// main tags
	static inline var GentTagRoot 			= "data";
	// persons
	static inline var GenTagPersons 		= "individuals";
	static inline var GenTagPerson 			= "indi";
	// family
	static inline var GenTagFamilies 		= "families";
	static inline var GenTagFamily 			= "fam";
	static inline var GenTagKids 			= "childs";
	static inline var GenTagKid 			= "chil";
	static inline var GenTagHusband			= "husb";
	static inline var GenTagWife			= "wife";

	// global
	static inline var GenTagId 				= "id";
	static inline var GenTagName 			= "name";
	static inline var GenTagGender 			= "gender";
	
	// events pairs, allways date and place
	static inline var GenTagEventDate		= "date";
	static inline var GenTagEventPlace		= "plac";
	
	// specific events
	static inline var GenTagEventBirth		= "birt";
	static inline var GenTagEventDeath		= "deat";
	static inline var GenTagEventMarriage	= "marr";
	
	// attributes
	public var settings:Settings;
	
	/**
	 * Attributes
	 */ 
	public var xml:             XML;

	public function new(
		scene:MovieClip, 
		settings:Settings) 
	{
		super(scene);
		
		this.settings = settings;
	}
	
	override public function parse():Void 
	{
		super.parse();
		
		xml = new XML( urlLoader.data );
		
		// parse
		var data:XML = this.xml;
		var persons:XMLList = data.individuals.child('*');
		var families:XMLList = data.families.child('*');
		
		// Persons load
		for (i in 0...persons.length()) {
			
			var p:Person = new CJPerson(settings);
			scene.addChild(p);
			
			// basic info
			p.id = persons[i].child(GenTagId).toString();
			p.personName = persons[i].child(GenTagName).toString();
			p.gender = persons[i].child(GenTagGender).toString();
			
			// events
			p.birth = parseEvent(persons[i].child(GenTagEventBirth));
			p.death = parseEvent(persons[i].child(GenTagEventDeath));
			
			geneologyTree.addPerson(p);
			//trace("loaded: " + p.name);
		}
		
		for (i in 0...families.length()) {
			//trace("Family Id: " + families[i].child("id"));
			
			var f:Family = new CJFamily(settings);
			scene.addChild(f);
			
			f.id = families[i].child(GenTagId).toString();
			
			// husband
			var husband:Person = geneologyTree.searchPerson(
				families[i].child(GenTagHusband).toString());
			if (husband != null ) {
				husband.gender = "M";
				f.addParent(husband);
			}
			
			// wife
			var wife:Person = geneologyTree.searchPerson(
					families[i].child(GenTagWife).toString());
			if (wife != null) {
				wife.gender = "F";
				f.addParent(wife);
			}
			
			
			// marriage date
			f.marriage = parseEvent(
				families[i].child(GenTagEventMarriage));
				
			// kids
			var kids:XMLList = families[i].child(GenTagKids).child("*");
			for (k in 0...kids.length()) {

				var kidId:String = kids[k].toString();
				//trace("kid: "+ kidId);
				f.addKid(geneologyTree.searchPerson(kidId));
			}
			
			//trace("kidIndex=" + kidIndex);
			geneologyTree.addFamily(f);
		}
		
	}
	
	/**
	 * As any event has nested Xml attribute with date and place
	 * So this method parse it and returns as GenEvent object
	 * 
	 * @param	XMLList
	 * @return 	Initialized GenEvent object
	 */
	function parseEvent(list:XMLList):GenEvent {
		
		if (list.length() > 0) {
			return new GenEvent(
				list.child(GenTagEventDate).toString(),
				list.child(GenTagEventPlace).toString());
		}
		else {
			//trace("** list: " + list);
		}
		
		return null;
	}
	
}