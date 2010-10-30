package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class Main extends MovieClip
	{
		private var innerConveyor:Conveyor;
		private var outerConveyor:Conveyor;
		
		public function Main()
		{
			innerConveyor = new Conveyor(110,1168, 106, 622, "clockwise");
			outerConveyor = new Conveyor(110,1168, 106, 622, "clockwise");
			
			spawnItem(innerConveyor);
			
			this.addEventListener(Event.ENTER_FRAME, tick);
		}
		
		private function tick(e:Event):void {
			innerConveyor.tick();
			outerConveyor.tick();
		}
		
		private function spawnItem(conveyor:Conveyor) {
			trace("conveyor.leftBound: " + conveyor.leftBound);
			trace("conveyor.rightBound: " + conveyor.rightBound);
			
			var newShape = new PuzzleShape(conveyor.leftBound, conveyor.topBound, 0);
			conveyor.items.push(newShape);
			stage.addChild(newShape);
		}
	}
}