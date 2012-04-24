package model
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.ByteArray;
	
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	
	public class FileInfo extends EventDispatcher
	{
		private static var UNIQUE_ID:int = 0;
		
		private var _id : int;
		
		private var _imageUrl : String;
		
		private var _title : String;
		private var _description : String;
		private var _file : File;

		private var _width:String;		
		private var _height:String;
		
		private var _type : String;
		private var _fpversion : String;
		private var _loader:SWFLoader;
		
		public static var requiredFPVersion : int = 0;
		
		public function FileInfo()
		{
			_loader = new SWFLoader();
			_id = UNIQUE_ID++;
			_title = "";
		}

		public function get description():String
		{
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		public function get imageUrl():String
		{
			return _imageUrl;
		}

		public function set imageUrl(value:String):void
		{
			_imageUrl = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function get type():String
		{
			return _type;
		}

		public function get fpversion():String
		{
			return _fpversion;
		}

		public function set fpversion(value:String):void
		{
			_fpversion = value;
		}

		public function get file():File
		{
			return _file;
		}

		public function set file(value:File):void
		{
			_file = value;
			_file.addEventListener(Event.COMPLETE, loaded);
			_file.load();
		}

		private function loaded(event:Event):void
		{
			
			_file.data.position = 3;
			//var fpVersion : int = _file.data.readByte();
			fpversion = String(_file.data.readByte())+".0.0";
			//if (fpVersion > requiredFPVersion) requiredFPVersion = fpVersion; 			
			
			
			_file.data.position = 0;
			
			var context : LoaderContext =  new LoaderContext();
			context.allowLoadBytesCodeExecution = true;
			context.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);

			_loader.addEventListener(Event.COMPLETE, bytesLoaded);
			_loader.addEventListener(Event.INIT, bytesLoaded);
			_loader.addEventListener(FlexEvent.CREATION_COMPLETE, bytesLoaded);
			_loader.loaderContext = context;
			_loader.load(_file.data);
		}
		
		public function get isSWF():Boolean
		{
			return _file.extension == "swf";
		}

		private function bytesLoaded(event:Event):void
		{
			_loader.content.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderContentError);
			
			_width = String(_loader.content.loaderInfo.width);
			_height = String(_loader.content.loaderInfo.height);
			
			Model.getInstance().notify();
		}

		private function onLoaderContentError(event:Event):void
		{
			//tsk tsk tsk ...
		}

		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
			
			Model.getInstance().notify();
		}

		[Bindable]
		public function get width():String
		{
			return _width;
		}
		
		public function set width(value:String):void
		{
			_width = value;
			_loader.content.width = Number(value);
			
			Model.getInstance().notify();
		}
		
		[Bindable]
		public function get height():String
		{
			return _height;
		}
		
		public function set height(value:String):void
		{
			_height = value;
			_loader.content.height = Number(value);
			
			Model.getInstance().notify();
		}

	}
}