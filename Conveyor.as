package
{
	import flash.display.MovieClip;

	public class Conveyor
	{		
		public var leftBound:Number;
		public var rightBound:Number;
		public var topBound:Number;
		public var bottomBound:Number;
		
		private var moveDirection:String;
		private var speed:Number;
		
		public var items:Array;
		
		public function Conveyor(_leftBound:Number,_rightBound:Number,_topBound:Number,_bottomBound:Number, _moveDirection:String)
		{
			items = new Array();
			
			leftBound = _leftBound;
			rightBound = _rightBound;
			topBound = _topBound;
			bottomBound = _bottomBound;
			
			moveDirection = _moveDirection;
			speed = 10;
		}
		
		public function tick():void {
			for(var i=0;i<items.length;i++) {
				moveItem(items[i]);
			}
		}
		
		public function moveItem(item:PuzzleShape):void {
			//trace("START_MOVE");
			if(item.x == leftBound) {//if on left edge
				
				//trace("on left edge");
				
				if(moveDirection == "clockwise") { //move up
					//trace("clockwise move");
					if(item.y - speed >= topBound) {
						item.y -= speed;
					} else { item.y = topBound; }
				} else if(moveDirection == "counterclockwise") { //move down
					//trace("counterclockwise move");
					if(item.y + speed <= bottomBound) {
						item.y += speed;
					} else { item.y = bottomBound; }
				}
			} else if(item.x == rightBound) {//if on right edge
				
				//trace("on right edge");
				
				if(moveDirection == "clockwise") { //move down
					if(item.y + speed <= bottomBound) {
						item.y += speed;
					} else { item.y = bottomBound; }
				} else if(moveDirection == "counterclockwise") { //move up
					if(item.y - speed >= topBound) {
						item.y -= speed;
					} else { item.y = topBound; }
				}
			}
				
			if(item.y == topBound) {
				
				//trace("on top edge");
				
				if(moveDirection == "clockwise") { //move right
				//	trace("clockwise move");
					if(item.x + speed <= rightBound) {
						item.x += speed;
					} else { item.x = rightBound; }
				} else if(moveDirection == "counterclockwise") { //move left
				//	trace("counterclockwise move");
					if(item.x - speed >= leftBound) {
						item.x -= speed;
					} else { item.x = leftBound; }
				}
			} else if(item.y == bottomBound) {
				
				//trace("on bottom edge");
				
				if(moveDirection == "clockwise") { //move left
					if(item.x - speed >= leftBound) {
						item.x -= speed;
					} else { item.x = leftBound; }
				} else if(moveDirection == "counterclockwise") { //move right
					if(item.x + speed <= rightBound) {
						item.x += speed;
					} else { item.x = rightBound; }
				}
			}
		}
	}
}