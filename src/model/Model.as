package model
{
	import assets.AssetsManager;
	import assets.HTMLTemplate;
	
	import events.SettingsEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayList;

	public class Model extends EventDispatcher
	{
		//Singleton
		private static var _instance : Model;

		public static function getInstance():Model
		{
			return _instance ? _instance : _instance = new Model();
		}
		
		private var _preventNotification : Boolean;
		
		//Files
		private var _files : ArrayList;
		
		//Settings
		private var _soVersion : String;
		private var _flashvars : ArrayList;

		private var _includeSO:Boolean;
		private var _html5Embed:Boolean;
		private var _isSingleFile : Boolean;
		private var _expressInstall:Boolean;

		private var _pageTitle : String;
		private var _projectTitle:String;
		
		private var _docTypes:ArrayList;
		private var _docType:DocType;
		
		private var _charsets:ArrayList;
		private var _charset:CharSet;
		
		private var _rfpvs : ArrayList;
		private var _rfpv:RequiredFlashPlayerVersion;
		
		//Appearance
		private var _backgroundColor : uint;
		private var _textColor : uint;
		
		private var _alternativeContent:String;
		
		private var _saveableProperties:Array;
		private var _preventNotificationCounter:Timer;

		public function Model()
		{
			_preventNotification = false;
			
			//Using an anynoumus source array
			_files = new ArrayList(new Array());	
			_flashvars = new ArrayList(new Array());
			
			_preventNotificationCounter = new Timer(1000,1);
			_preventNotificationCounter.addEventListener(TimerEvent.TIMER_COMPLETE, onPreventNotificationsTimerComplete);
			
			//Populate doctypes. THIS IS MESSY WHEN DONE HERE!!!
			_docTypes = new ArrayList(new Array());
			_docTypes.addItem(new DocType('XHTML 1.0 Strict', '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'));
			_docTypes.addItem(new DocType('XHTML 1.0 Transitional', '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'));
			_docTypes.addItem(new DocType('HTML 4.01 Strict', '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'));
			_docTypes.addItem(new DocType('HTML 4.01 Transitional', '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">'));
			
			_charsets = new ArrayList(new Array());
			_charsets.addItem(new CharSet('utf-8', 'utf-8'));
			_charsets.addItem(new CharSet('iso-8859-1', 'iso-8859-1'));
			
			
			_rfpv = new RequiredFlashPlayerVersion(0,0,0, true);
			
			_rfpvs = new ArrayList(new Array());
			_rfpvs.addItem(_rfpv);
			_rfpvs.addItem(new RequiredFlashPlayerVersion(10,3,0));
			_rfpvs.addItem(new RequiredFlashPlayerVersion(10,1,0));
			_rfpvs.addItem(new RequiredFlashPlayerVersion(10,0,0));
			_rfpvs.addItem(new RequiredFlashPlayerVersion(9,0,0));
			_rfpvs.addItem(new RequiredFlashPlayerVersion(8,0,0));
			
			
			//Default docType to XHTML 1.0 Strict
			_docType = _docTypes.getItemAt(0) as DocType;
			
			//Default charset to utf-8
			_charset = _charsets.getItemAt(0) as CharSet;
			
			_alternativeContent = AssetsManager.getAlternativeContent();
			
			//These properties will be parsed when saving default settings
			_saveableProperties = ['expressInstall', 'isSingleFile', 'html5Embed', 'includeSO', 'soVersion', 'docType', 'charset', 'rfpv', 'backgroundColor', 'textColor', 'alternativeContent'];
		}
		
		public function isEmpty():Boolean
		{
			return _files.length == 0; 
		}
		
		public function hasSWF():Boolean
		{
			for each (var fi : FileInfo in files.source)
			{
				if (fi.isSWF) return true;
			}
			
			return false;
		}
		
		[Bindable]
		public function get flashvars():ArrayList
		{
			return _flashvars;
		}
		
		public function set flashvars(value : ArrayList):void
		{
			_flashvars = value;
		}
		
		public function getHTML():String
		{
			return HTMLTemplate.getHTML();
		}
		
		public function getPreviewHTML():String
		{
			return HTMLTemplate.getPreviewHTML();
		}

		
		
		public function addFile(f:FileInfo):void
		{
			_files.addItem(f);
			
			notify();
		}
		
		public function removeFile(f:FileInfo):void
		{
			_files.removeItem(f);
			
			notify();
		}
		
		public function removeFileAt(index:int):void
		{
			_files.removeItemAt(index);
			
			notify();
		}
		
		
		//Bindables
		
		[Bindable]
		public function get charsets():ArrayList
		{
			return _charsets;
		}
		
		public function set charsets(value : ArrayList):void
		{
			_charsets = value;
		}
		
		[Bindable]
		public function get docTypes():ArrayList
		{
			return _docTypes;
		}
		
		public function set docTypes(value : ArrayList):void
		{
			_docTypes = value;
		}
		
		[Bindable]
		public function get files():ArrayList
		{
			if (_isSingleFile && _files.length > 0) 
			{
				return new ArrayList([_files.getItemAt(0)]);
			}

			return _files;
		}
		
		public function set files(a:ArrayList):void
		{
			_files = files;
			
			notify();
		}
		
		[Bindable]
		public function get includeSO():Boolean
		{
			return _includeSO;
		}

		public function set includeSO(value:Boolean):void
		{
			_includeSO = value;
			
			notify();
		}

		[Bindable]
		public function get alternativeContent():String
		{
			return _alternativeContent;
		}
		
		public function set alternativeContent(value:String):void
		{
			_alternativeContent = value;
			
			notify();
		}
		
		[Bindable]
		public function get docType():DocType
		{
			return _docType;
		}
		
		public function set docType(value : DocType):void
		{
			_docType = value;
			
			notify();
		}
		
		[Bindable]
		public function get charset():CharSet
		{
			return _charset;
		}
		
		public function set charset(value:CharSet):void
		{
			_charset = value;
			
			notify();
		}
		
		[Bindable]
		public function get projectTitle():String
		{
			return _projectTitle || "";
		}

		public function set projectTitle(value:String):void
		{
			_projectTitle = value;
			
			notify();
		}
		
		[Bindable]
		public function get pageTitle():String
		{
			return _pageTitle || "";
		}
		
		public function set pageTitle(value:String):void
		{
			_pageTitle = value;
			
			notify();
		}
		
		
		[Bindable]
		public function get isSingleFile():Boolean
		{
			return _isSingleFile;
		}
		
		public function set isSingleFile(value:Boolean):void
		{
			_isSingleFile = value;
			
			notify();
		}
		
		[Bindable]
		public function get rfpvs():ArrayList
		{
			return _rfpvs;
		}
		
		public function set rfpvs(value:ArrayList):void
		{
			_rfpvs = value;
			
			notify();
		}
		
		[Bindable]
		public function get rfpv():RequiredFlashPlayerVersion
		{
			return _rfpv;
		}
		
		public function set rfpv(value:RequiredFlashPlayerVersion):void
		{
			_rfpv = value;
			
			notify();
		}
		
		[Bindable]
		public function get html5Embed():Boolean
		{
			return _html5Embed;
		}
		
		public function set html5Embed(value:Boolean):void
		{
			_html5Embed = value;

			notify();
		}

		[Bindable]
		public function get expressInstall():Boolean
		{
			return _expressInstall;
		}

		public function set expressInstall(value:Boolean):void
		{
			_expressInstall = value;
			
			notify();
		}
		
		[Bindable]
		public function get backgroundColor():uint
		{
			return _backgroundColor || 0xffffff;
		}
		
		public function set backgroundColor(color : uint):void
		{
			_backgroundColor = color;
			
			notify();
		}
		
		[Bindable]
		public function get textColor():uint
		{
			return _textColor || 0x000000;
		}
		
		public function set textColor(color : uint):void
		{
			_textColor = color;
			
			notify();
		}
		
		[Bindable]
		public function get soVersion():String
		{
			return _soVersion || HTMLTemplate.SWF_OBJECT_2;
		}
		
		public function set soVersion(soVersion : String):void
		{
			_soVersion = soVersion;
			
			notify();
		}

		public function getToolTip(id : String):String
		{
			switch (id.toLowerCase())
			{
				case "html5_embedding":
					return "Use HTML5.";
				case "single_swf_embed":
					return "Provides CSS rules for embedding in fullscreen. First file in file list must be a SWF file.";
				case "include_swfobject":
					return "Check to include swfobject.js in the HTML <script> tag, thus creating one less file.";
				case "page_title":
					return "The title of the HTML page";
				case "express_install":
					return "Use Adobe Express Install to let users easily upgrade their Flash Player version.";
				default:
					return "";
			}
		}

		public function snapshot():String
		{
			var data : XML = new XML(<settings />);
			
			for each(var prop:String in _saveableProperties)
			{
				var setting : XML = new XML(<setting />);
				setting.field = prop;
				var thisprop : * = this[prop];
				if (thisprop is DocType) thisprop = thisprop.value;
				if (thisprop is CharSet) thisprop = thisprop.value;
				if (thisprop is RequiredFlashPlayerVersion) thisprop = thisprop.label;
				setting.value = thisprop;
				data.appendChild(setting)
			}
			return data.toXMLString();
		}

		public function loadSnapshot(xml:String):void
		{
			//Prevent multiple "simultaneously" view updates 
			_preventNotification = true;
			
			var data : XML = new XML(xml);

			expressInstall = (data.setting.(field == 'expressInstall').value.text()) == "true" ? true : false;
			includeSO = (data.setting.(field == 'includeSO').value.text()) == "true" ? true : false;
			soVersion = data.setting.(field == 'soVersion').value.text();
			isSingleFile = (data.setting.(field == 'isSingleFile').value.text()) == "true" ? true : false;
			html5Embed = (data.setting.(field == 'html5Embed').value.text()) == "true" ? true : false;
			
			docType = findDocType(data.setting.(field == 'docType').value.text());
			charset = findCharSet(data.setting.(field == 'expressInstall').value.text());
			
			//TODO implement saveable flash player version
			//rfpv = (data.setting.(field == 'expressInstall').value.text()) == "true" ? true : false;
			
			backgroundColor = data.setting.(field == 'backgroundColor').value.text();
			textColor = data.setting.(field == 'textColor').value.text();
			alternativeContent = data.setting.(field == 'alternativeContent').value.text();
			
			_preventNotification = false;
			
			notify();
		}
		
		//TODO implement doctype and charset 
		private function findDocType(value:String):DocType
		{
			for each (var dt : DocType in _docTypes)
			{	
				if (dt.value == value) 
				{
					return dt;
				}
			}
			
			return _docTypes.getItemAt(0) as DocType;
		}
		
		private function findCharSet(value:String):CharSet
		{
			for each (var cs : CharSet in _charsets)
				if (cs.value == value) 
					return cs;
			
			return _charsets.getItemAt(0) as CharSet;
		}
		
		public function notify():void
		{
			if (!_preventNotification) 
			{
				resetPreventNotificationCounter();			
				
				dispatchEvent(new SettingsEvent(SettingsEvent.SETTINGS_UPDATED));
			}
			else
			{
				trace("prevented render");
			}
		}

		private function resetPreventNotificationCounter():void
		{
			_preventNotification = true;
			_preventNotificationCounter.reset();
			_preventNotificationCounter.start();
		}

		private function onPreventNotificationsTimerComplete(event:TimerEvent):void
		{
			_preventNotification = false;
			trace("auto notify");
			dispatchEvent(new SettingsEvent(SettingsEvent.SETTINGS_UPDATED));
		}

	}
}