package utils
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;

	public class NearestNeighbourGrid extends Sprite
	{
		private const MAX_RETRIES:uint = 20;

		private var _inputPointArray:Array;
		private var _gridRectWidth:uint;
		private var _gridRectHeight:uint;

		private var _addedRectArray:Array;
		private var _outputPointArray:Array;

		private var _offsetPositionPointRangeX:uint;
		private var _offsetPositionPointRangeY:uint;

		// input array could be a Vector of type Point.
		public function NearestNeighbourGrid ()
		{
		}
		
		public function set gridRectWidth (p_gridRectWidth:uint):void
		{
			_gridRectWidth = p_gridRectWidth;
		}

		public function set gridRectHeight (p_gridRectHeight:uint):void
		{
			_gridRectHeight = p_gridRectHeight;
		}

		public function set randomOffsetPositionRangeX (p_randomOffsetPositionRangeX:uint):void
		{
			if (_offsetPositionPointRangeX < _gridRectWidth)
			{
				_offsetPositionPointRangeX = p_randomOffsetPositionRangeX;
			}
			else
			{
				_offsetPositionPointRangeX = _gridRectWidth;
			}
		}

		public function set randomOffsetPositionRangeY (p_randomOffsetPositionRangeY:uint):void
		{
			if (_offsetPositionPointRangeY < _gridRectHeight)
			{
				_offsetPositionPointRangeY = p_randomOffsetPositionRangeY;
			}
			else
			{
				_offsetPositionPointRangeY = _gridRectHeight;
			}
		}

		public function getPointArray (p_inputPointArray:Array):Array
		{
			_inputPointArray = p_inputPointArray;

			_addedRectArray = new Array ();
			_outputPointArray = new Array ();
			_offsetPositionPointRangeX = 0;

			var inputPointArrayLength:uint = _inputPointArray.length;

			for (var i:int = 0; i < inputPointArrayLength; ++i)
			{
				var inputPoint:Point = _inputPointArray[i] as Point;
				var inputPointRect:Rectangle = createGridRect (inputPoint.x, inputPoint.y);

				checkRectPosition (inputPointRect);
			}

			return _outputPointArray;
		}

		private function createGridRect (xPos:Number, yPos:Number):Rectangle
		{
			var rect:Rectangle = new Rectangle ();
			rect.width = _gridRectWidth;
			rect.height = _gridRectHeight;

			rect.x = xPos;
			rect.y = yPos;

			return rect;
		}

		private function checkRectPosition (rectToAdd:Rectangle):void
		{
			var collidingRectangle:Rectangle = getCollidingRectangle (rectToAdd);

			// if the rectToAdd doesn't collide with anything add its x & y to the output array, otherwise
			// try to reposition it around the rectangle with which it collides.
			if (collidingRectangle == null)
			{
				_outputPointArray.push (generatePoint (rectToAdd.x, rectToAdd.y));
				_addedRectArray.push (rectToAdd);
			}
			else
			{
				positionAround (collidingRectangle);
			}
		}

		private function generatePoint (originalPosX:Number, originalPosY:Number):Point
		{
			var randomOffsetX:int = Math.floor (Math.random () * _offsetPositionPointRangeX) + _offsetPositionPointRangeX;
			var randomOffsetY:int = Math.floor (Math.random () * _offsetPositionPointRangeY) + _offsetPositionPointRangeY;
			
			var point:Point = new Point (originalPosX + randomOffsetX, originalPosY + randomOffsetY);
			
			return point;
		}

		private function getCollidingRectangle (rectToCheck:Rectangle):Rectangle
		{
			// TODO : check if is in sea first.

			// check if the rectToCheck collides with any rect that has already been added and if so return the already added rect
			// so that it can be used as a basis to reposition the rectToCheck.
			for (var i:int = 0; i < _addedRectArray.length; i++)
			{
				var currentAddedRect:Rectangle = _addedRectArray[i] as Rectangle;
				var intersectingRect:Rectangle = currentAddedRect.intersection (rectToCheck);

				if (intersectingRect.width > 0 || intersectingRect.height > 0)
				{
					return currentAddedRect;
				}
			}

			return null;
		}

		private function positionAround (rect:Rectangle, range:int = 3):void
		{
			var startX:Number = rect.x - (Math.floor (range / 2) * rect.width);
			var startY:Number = rect.y - (Math.floor (range / 2) * rect.height);

			for (var i:int = 0; i < range; i++)
			{
				var xPos:Number = startX + (i * rect.width);
				var yPos:Number;

				var rectToAdd:Rectangle;

				var j:int = 0;

				if (i == 0 || i == range - 1)
				{
					for (j; j < range; j++)
					{
						yPos = startY + (j * rect.height);

						rectToAdd = new Rectangle (xPos, yPos, rect.width, rect.height);

						if (getCollidingRectangle (rectToAdd) == null)
						{
							_addedRectArray.push (rectToAdd);
							_outputPointArray.push (generatePoint (rectToAdd.x, rectToAdd.y));

							return;
						}
					}
				}
				else
				{
					for (j; j < range; j++)
					{
						if (j == 0 || j == range - 1)
						{
							yPos = startY + (j * rect.height);
							rectToAdd = new Rectangle (xPos, yPos, rect.width, rect.height);

							if (getCollidingRectangle (rectToAdd) == null)
							{
								_addedRectArray.push (rectToAdd);
								_outputPointArray.push (generatePoint (rectToAdd.x, rectToAdd.y));

								return;
							}
						}
					}
				}
			}

			// if the rect can't be placed push nan into the array so objects don't get skipped
			range < MAX_RETRIES ? positionAround (rect, range + 2) : _outputPointArray.push (new Point (NaN, NaN));
		}
	}
}
