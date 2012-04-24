package events
{
	import flash.events.Event;
	import flash.filesystem.File;
	import model.FileInfo;
	
	public class FileEvent extends Event
	{
		public static const FILE_ACCEPTED : String = "FileEvent.FILE_ACCEPTED";
		public static const FILE_DELETED:String = "FileEvent.FILE_DELETED";
		public static const FILE_UPDATED:String = "fileUpdated";
		
		private var _file : FileInfo;
		
		public function FileEvent(type:String, file : FileInfo = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			_file = file;
		}


		public function get file():FileInfo
		{
			return _file;
		}

		public function set file(value:FileInfo):void
		{
			_file = value;
		}

	}
}