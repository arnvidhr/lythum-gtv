package gtv;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.Point;
import flash.display.StageDisplayState; 
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard; 
import gtv.data.GenTreeItem;



/**
 * ...
 * @author Arvydas Grigonis (C) www.lythum.lt
 */

class MainScene  extends MovieClip
{
	var scene:MovieClip;
	public static inline var zoomFactor:Float = .1;	// wheel delta precentage for scaling
	public static inline var zoomMin:Float = 0.05;
	public static inline var zoomMax:Float = 1.5;

	var zoom:Float;
	var settings:Settings;
	var normalSize:Point;


	public function new(scene:MovieClip, settings:Settings) 
	{
		super();
		
		this.scene = scene;
		this.settings = settings;
		zoom = 1;
		
		//  zoom
		scene.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		
		// drag
		scene.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		scene.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		scene.addEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
		
		// toogling fullscreen
		scene.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	public function draw() {
		
		setShadow(5, 48);
		
		graphics.beginFill(settings.colorMainBack);
		
		graphics.drawRect(
			0, 0, 
			width + (settings.mainMargin.x * 2), 
			height + (settings.mainMargin.y * 2));
			
		drawCopyright();
				
		graphics.endFill();
		
		// init normal size
		normalSize = new Point(
			this.width, this.height);

		// let's zoom out a bit
		zoomOut( -8);

		// 
		this.x = this.y = 0;
	}

	/**
	 * (C)
	 */
	public function drawCopyright() {

		var cpLabel:TextField = new TextField();
		cpLabel.text = "(C) 2011 www.lythum.lt, Written By Arvydas Grigonis";
		this.addChild(cpLabel);
		cpLabel.autoSize = TextFieldAutoSize.LEFT;
		cpLabel.x = 10;
		cpLabel.y = 10;
		cpLabel.filters = [ new  GlowFilter(0xccbbaa, 1.0, 3, 3, 3, 3, false, false), 
							new DropShadowFilter(5, 25)];
	}

	function processDelta(delta:Float) {
		return delta * zoomFactor;
	}
	
	public function zoomIn (delta:Float) {
		
		zoom += processDelta(delta);
		if (zoom > zoomMax) {
			zoom = zoomMax;
		}
		setScaling();
	}
	
	public function zoomOut(delta:Float) {
		zoom += processDelta(delta);
		if (zoom < zoomMin) {
			zoom = zoomMin;
		}
		
		setScaling();
	}
	
	function setScaling () {
		
		this.scaleX = this.scaleY = zoom;
		
		if(settings.enlargeFontOnZoomOut){
		
			// fix font on zoomout
			if (width < normalSize.x) {
				settings.textFormat.size = settings.fontSize * (normalSize.x / width);
			}
			else {
				settings.textFormat.size = settings.fontSize;
			}
			
			// reset fonts sizes on all scene childs
			for (i in 0...this.numChildren) {
				
				if(Std.is(this.getChildAt(i), GenTreeItem)){
					var item:GenTreeItem = cast(this.getChildAt(i), GenTreeItem);
					
					item.label.defaultTextFormat = settings.textFormat;
					item.label.setTextFormat(settings.textFormat);
				}
			}
			
			//trace(settings.textFormat.size);
		}
	}
	
	public function setShadow (alpha:Float, angle:Float) {
		this.filters = [new DropShadowFilter(alpha, angle)];
	}
	
	/**
	 * 
	 * @param	events
	 */
	public function onWheel (event:MouseEvent)
    {
        //trace ("wheel, delta=" + event.delta + ", zoom=" + s.zoom);
		// backing up geom data before scaling
		var startRelPos:Point = new Point(
			(width - mouseX) / (width / 100),
			(height - mouseY) / (height / 100));
		
		var startMouse:Point = new Point(mouseX, mouseY);
		var startSize:Point = new Point(this.width, this.height);
		
		if (event.delta > 0) {
			zoomIn(event.delta/10);
		}
		else {
			zoomOut(event.delta/10);
		}
		
		// fixing center
		var endMouse:Point = new Point(mouseX, mouseY);
		var endSize:Point = new Point(width, height);
		
		// http://stackoverflow.com/questions/7172586/set-zoom-on-mouse-click-target-to-center-of-stage
		this.x = scene.mouseX - (startMouse.x * scaleX);
		this.y = scene.mouseY - (startMouse.y * scaleY);
		
		//trace("scene: " + this.scene.mouseX + " x " + this.scene.mouseY + ", local: " + this.mouseX + " x " + this.mouseY);
    }
	
	/**
	 * DRAG
	 * @param	event
	 */
	public function onMouseDown (e:MouseEvent) {
		//this.startDrag(true);
		this.startDrag (false);
	}

	public function onMouseUp (e:MouseEvent) {
		this.stopDrag ();
		//trace(this.x + " x " + this.y);
	}
	
	function onKeyUp (e:KeyboardEvent) {
		switch( e.keyCode ) 
		{ 
			case Keyboard.F11:  //<- Press F11 to enter "fullscreen" 
				toggleFullScreen();
        } 
	}
	
	function toggleFullScreen () {
		if (stage.displayState == StageDisplayState.FULL_SCREEN) {
			stage.displayState = StageDisplayState.NORMAL; 
		}
		else {
			stage.displayState = StageDisplayState.FULL_SCREEN; 
		}
		
	}
	
}