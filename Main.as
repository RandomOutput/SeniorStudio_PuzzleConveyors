package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class Main extends MovieClip
	{
		private const CONTROL_TYPE:String = "Mouse";
		
		private var innerConveyor:Conveyor;
		private var outerConveyor:Conveyor;
		
		private var lastInnerSpawn:Number;
		private var lastOuterSpawn:Number;
		
		private var dragList:Array;
		
		public function Main()
		{			
			initControls();
			
			innerConveyor = new Conveyor(210,1068, 186, 542, "clockwise");
			outerConveyor = new Conveyor(110,1168, 106, 622, "counterclockwise");
			
			lastInnerSpawn = getTimer();
			lastOuterSpawn = getTimer();
			
			dragList = new Array();
			
			this.addEventListener(Event.ENTER_FRAME, spawnInner);
			this.addEventListener(Event.ENTER_FRAME, spawnOuter);
			
			this.addEventListener(Event.ENTER_FRAME, tick);
			
		}
		
		private function initControls():void {
			if(CONTROL_TYPE == "Mouse") {
				
			} else if(CONTROL_TYPE == "TUIO_UDP") {
				
			}
		}
		
		private function tick(e:Event):void {
			innerConveyor.tick();
			outerConveyor.tick();
			//dragObjects();
		}
		
		private function spawnItem(conveyor:Conveyor) {
			//trace("conveyor.leftBound: " + conveyor.leftBound);
			//trace("conveyor.rightBound: " + conveyor.rightBound);
			
			var spawnType = Math.floor(Math.random()*3);
			//trace(spawnType);
			
			var newShape = new PuzzleShape(conveyor.leftBound, conveyor.topBound, spawnType);
			conveyor.items.push(newShape);
			stage.addChild(newShape);
			
			if(CONTROL_TYPE == "Mouse") {
				//trace("add mouse control");
				newShape.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownResponse);
			}
		}
		
		private function mouseDownResponse(e:MouseEvent) {
			trace("mouse down");
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpResponse);
			pullObject((e.target as MovieClip));
			dragList.push(e.target);
			e.target.startDrag();
		}
		
		private function mouseUpResponse(e:MouseEvent) {
			for(var i:int=0;i<dragList.length; i++) {
				trace();
				(dragList[i] as MovieClip).stopDrag();
			}
			
			dragList = new Array();
		}
		
		private function pullObject(target:MovieClip) {
			var foundObject = null;
			
			for(var i:int=0;i<innerConveyor.items.length;i++) {
				if(innerConveyor.items[i] == target.parent) {
					foundObject = innerConveyor.items.splice(i,1);
				}
			}
			
			if(foundObject == null) {
				for(var j:int=0;j<outerConveyor.items.length;j++) {
					if(outerConveyor.items[j] == target.parent) {
						foundObject = outerConveyor.items.splice(j,1);
					}
				}
			}
			
			if(foundObject == null) {
				trace("object not found");
			}
		}
		
		private function dragObjects():void {
			var mouseLoc:Point = new Point(stage.mouseX, stage.mouseY);
			stage.localToGlobal(mouseLoc);
			
			trace("mouse: " + mouseLoc.x + "," + mouseLoc.y);
			
			
			for(var i:int=0;i<dragList.length;i++) {
				dragList[i].x = mouseLoc.x;
				dragList[i].y = mouseLoc.y;
				trace("object: " + dragList[i].x + "," + dragList[i].y);
			}
		}
		
		private function spawnInner(e:Event) {
			if(innerConveyor.items.length < 18 && (getTimer() - lastInnerSpawn) > 500) {
				spawnItem(innerConveyor);
				lastInnerSpawn = getTimer();
			}
		}
		
		private function spawnOuter(e:Event) {
			if(outerConveyor.items.length < 24 && (getTimer() - lastOuterSpawn) > 500) {
				spawnItem(outerConveyor);
				lastOuterSpawn = getTimer();
			}
		}
	}
}