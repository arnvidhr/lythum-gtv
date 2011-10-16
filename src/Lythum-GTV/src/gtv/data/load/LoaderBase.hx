package gtv.data.load;

import flash.display.MovieClip;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.EventDispatcher;
import flash.events.Event;
import gtv.data.GeneologyTree;

/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 * 
 * This class possible to implement diferent 
 * for any file format load
 */
class LoaderBase extends EventDispatcher
{
	public var urlLoader:		URLLoader;
    public var getting:			Bool;
	public var scene:			MovieClip;
	
	/**
	 * Parsed data will go here
	 */
	public var geneologyTree:	GeneologyTree;
    
    public function new(scene:MovieClip):Void
    {
        super();
		this.scene = scene;
        getting = false;
		
        init();
    }
    
	/**
	 * Init - runs from constructor
	 */
    public function init():Void
    {
        //add any functionality here!
    }
    
    /**
     * loadFile is used to load a file.
     * @param	file url/location
     */
    public function loadFile( file: String ):Void
    {
        getting                     = true;
        var urlRequest:URLRequest   = new URLRequest( file );
        urlLoader                   = new URLLoader();
        
        urlLoader.addEventListener( Event.COMPLETE, completeListener );
        urlLoader.load( urlRequest );
    }
    
    /**
     * called when the file is loaded
     * @param	e
     */
    public function completeListener( e: Event ):Void
    {
        getting = false;

        parse();
		
        // dispatches when everything done
        dispatchEvent( e );
    }
    
	/**
	 * Parse loaded data
	 */
    public function parse():Void
    {
		geneologyTree = new GeneologyTree();
        //trace('parsing!!');
    }
	
	/**
	 * Deploys all tree
	 */
	public function deploy():Void {
		if (geneologyTree.validate()) {
			geneologyTree.deploy();
			scene.draw();
		}
	}
}