package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class Main extends MovieClip
	{
		private const CONTROL_TYPE:String = "Mouse";
		
		private var innerConveyor:Conveyor;
		private var outerConveyor:Conveyor;
		
		private var lastInnerSpawn:Number;
		private var lastOuterSpawn:Number;
		
		private var dragList:Array;
		
		private var player1Score:int;
		private var player2Score:int;
		private var player3Score:int;
		private var player4Score:int;
		
		//random shit for visuals
		private var dZone:DeadZone = new DeadZone();
		
		private var player1Box:TextField = new TextField();
		private var player2Box:TextField = new TextField();
		private var player3Box:TextField = new TextField();
		private var player4Box:TextField = new TextField();
		
		public function Main()
		{			
			initControls();
			
			innerConveyor = new Conveyor(210,1068, 186, 542, "clockwise");
			outerConveyor = new Conveyor(110,1168, 106, 622, "counterclockwise");
			
			lastInnerSpawn = getTimer();
			lastOuterSpawn = getTimer();
			
			dragList = new Array();
			
			player1Score = 0;
			player2Score = 0;
			player3Score = 0;
			player4Score = 0;
			
			dZone.x = 640.95;
			dZone.y = 158.00;
			stage.addChild(dZone);
			
			this.addEventListener(Event.ENTER_FRAME, spawnInner);
			this.addEventListener(Event.ENTER_FRAME, spawnOuter);
			
			this.addEventListener(Event.ENTER_FRAME, tick);
			this.addEventListener(Event.ENTER_FRAME, checkCollision);
			
			player1Box.x = 500;
			player1Box.y = 100;
			player1Box.text = "Player1: " + player1Score;
			stage.addChild(player1Box);
			
			player2Box.x = 600;
			player2Box.y = 100;
			player2Box.text = "Player2: " + player2Score;
			stage.addChild(player2Box);
			
			player3Box.x = 500;
			player3Box.y = 150;
			player3Box.text = "Player3: " + player3Score;
			stage.addChild(player3Box);
			
			player4Box.x = 600;
			player4Box.y = 150;
			player4Box.text = "Player4: " + player4Score;
			stage.addChild(player4Box);
			
		}
		
		private function initControls():void {
			if(CONTROL_TYPE == "Mouse") {
				
			} else if(CONTROL_TYPE == "TUIO_UDP") {
				
			}
		}
		
		private function tick(e:Event):void {
			innerConveyor.tick();
			outerConveyor.tick();
		}
		
		private function checkCollision(e:Event) {
			for(var i:int=0;i<dragList.length;i++) {
				for(var j:int=0;j<puzzle001.numChildren;j++) {
					if(puzzle001.getChildAt(j) is MovieClip) {
						if((dragList[i] as MovieClip).hitTestObject((puzzle001.getChildAt(j) as MovieClip))) {
							if(((dragList[i] as PuzzleShape).shapeType == 0 && puzzle001.getChildAt(j) is squareGoal) ||
								((dragList[i] as PuzzleShape).shapeType == 1 && puzzle001.getChildAt(j) is circleGoal) ||
								((dragList[i] as PuzzleShape).shapeType == 2 && puzzle001.getChildAt(j) is triGoal)) {
								var puzzPoint:Point = new Point(puzzle001.getChildAt(j).x, puzzle001.getChildAt(j).y);
								var target = dragList[i];
								trace("drag list target: " + dragList);
								trace(puzzle001.getChildAt(j));
								stage.localToGlobal(puzzPoint);
								
								for(var k:int=0;k<dragList.length; k++) {
									(dragList[k] as MovieClip).stopDrag();
								}
								
								dragList = new Array();
								trace("puzzleX: " + puzzPoint.x);
								trace("puzzleY: " + puzzPoint.y);
								target.x = puzzPoint.x + puzzle001.x;
								target.y = puzzPoint.y + puzzle001.y;
								
								if((target as PuzzleShape).controllingPlayer == 1) {
									player1Score++;
								} else if((target as PuzzleShape).controllingPlayer == 2) {
									player2Score++;
								} else if((target as PuzzleShape).controllingPlayer == 3) {
									player3Score++;
								} else if((target as PuzzleShape).controllingPlayer == 4) {
									player4Score++;
								}
								
								player1Box.text = "Player1: " + player1Score;
								player2Box.text = "Player2: " + player2Score;
								player3Box.text = "Player3: " + player3Score;
								player4Box.text = "Player4: " + player4Score;
								
								break;
							}
						}
					}
				}
			}
		}
		
		private function spawnItem(conveyor:Conveyor) {
			
			var spawnType = Math.floor(Math.random()*3);
			
			var newShape:PuzzleShape = new PuzzleShape(spawnType);
			newShape.x = conveyor.leftBound;
			newShape.y = conveyor.topBound;
			conveyor.items.push(newShape);
			stage.addChild(newShape);
			
			stage.setChildIndex(dZone, stage.numChildren-1);
			stage.setChildIndex(player1Box, stage.numChildren-1);
			stage.setChildIndex(player2Box, stage.numChildren-1);
			stage.setChildIndex(player3Box, stage.numChildren-1);
			stage.setChildIndex(player4Box, stage.numChildren-1);
			
			if(CONTROL_TYPE == "Mouse") {
				newShape.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownResponse);
			}
		}
		
		private function mouseDownResponse(e:MouseEvent) {
			if(zoneA.hitTestPoint(e.target.parent.x, e.target.parent.y)) {
				(e.target.parent as PuzzleShape).controllingPlayer = 1;
			} else if(zoneB.hitTestPoint(e.target.parent.x, e.target.parent.y)) {
				(e.target.parent as PuzzleShape).controllingPlayer = 2;
			} else if(zoneC.hitTestPoint(e.target.parent.x, e.target.parent.y)) {
				(e.target.parent as PuzzleShape).controllingPlayer = 3;
			} else if(zoneD.hitTestPoint(e.target.parent.x, e.target.parent.y)) {
				(e.target.parent as PuzzleShape).controllingPlayer = 4;
			} else { return; }
			//trace("mouse down");
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpResponse);
			//trace("pull object: " + e.target);
			//trace("pull object parent: " + e.target.parent);
			pullObject((e.target.parent as MovieClip));
			dragList.push(e.target.parent);
			
			
			
			e.target.parent.startDrag();
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
				if(innerConveyor.items[i] == target) {
					foundObject = innerConveyor.items.splice(i,1);
				}
			}
			
			if(foundObject == null) {
				for(var j:int=0;j<outerConveyor.items.length;j++) {
					if(outerConveyor.items[j] == target) {
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
			} else if(outerConveyor.items.length >= 18) {
				this.removeEventListener(Event.ENTER_FRAME, spawnInner);
			}
		}
		
		private function spawnOuter(e:Event) {
			if(outerConveyor.items.length < 24 && (getTimer() - lastOuterSpawn) > 500) {
				spawnItem(outerConveyor);
				lastOuterSpawn = getTimer();
			} else if(outerConveyor.items.length >= 24) {
				this.removeEventListener(Event.ENTER_FRAME, spawnOuter);
			}
		}
	}
}