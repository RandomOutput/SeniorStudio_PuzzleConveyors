package
{
	import flash.display.MovieClip;
	
	public class PuzzleShape extends MovieClip
	{
		private var shapeType:Number = 0;
		
		public function PuzzleShape(_x, _y, _shapeType:Number)
		{
			this.x = _x;
			this.y = _y;
			
			switch(_shapeType) {
				case 0: //square
					this.gotoAndStop(0);
					break;
				default:
					trace("ERROR: non-recognized shape type [PuzzleShape -> PuzzleShape()]");
					break;
			}
		}
	}
}