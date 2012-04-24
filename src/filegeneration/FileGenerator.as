package filegeneration
{
	import assets.AssetsManager;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import model.FileInfo;
	import model.Model;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.events.CloseEvent;
	
	import zip.Zipper;

	public class FileGenerator
	{
		static private var _selectedDir:File;
		
		static private var _zipIt:Boolean;
		
		static public function startGeneration():void
		{
			/*if (Model.getInstance().projectTitle == "")
			{
				Alert.show("A project name must be entered!\nThis will be the name of the ouput folder.", "Error", Alert.OK);
			}
			else*/
			if (Model.getInstance().pageTitle == "") 
			{
				Alert.show("Document has no title, continue?", "Warning", Alert.OK|Alert.CANCEL, null, onTitleAlertClose);
			}
			else
			{
				//Asking for a zip eventually starts file generation (regardless of whether user chooses to zip or not)
				askForZip();
			}
		}
		
		static private function onTitleAlertClose(e:CloseEvent):void
		{
			if (e.detail == Alert.OK)
				askForZip();
			//startFileGeneration();
		}
		
		static private function createZip():void
		{
			Zipper.zipFolder(_selectedDir);
		}
		
		static private function onZipAlertClose(e:CloseEvent):void
		{
			startFileGeneration();
			
			//Important to generate zip after file generation is complete
			if (e.detail == Alert.YES)
				_zipIt = true;					
			else 
				_zipIt = false;
		}
		
		static private function askForZip():void
		{
			Alert.show("Generate .zip file containing all project files?", "ZIP File", Alert.YES|Alert.NO, null, onZipAlertClose);
		}
		
		static private function startFileGeneration():void
		{
			var f : File = new File();
			f.addEventListener(Event.SELECT, dirSelected);
			f.browseForDirectory("Choose a destination folder");
		}
		
		static private function dirSelected(event:Event):void
		{
			//_selectedDir = (event.target as File).resolvePath(Model.getInstance().projectTitle)
			_selectedDir = (event.target as File).resolvePath("flembedded");
			_selectedDir.createDirectory();
			
			var fs : FileStream = new FileStream();

			//Copy images and SWFs - do this first as it might fail
			try
			{
				for each (var f : FileInfo in Model.getInstance().files.source)
				{
					f.file.copyTo(_selectedDir.resolvePath((f.isSWF ? "data/swf/" : "data/img/") + f.file.name), true);
				}
			}
			catch (e:Error)
			{
				Alert.show(e.message, e.name);
				
				//If this error occurs dont create swfobject and HTML file, thus exit func
				return;
			}
			
			//Create the HTML file
			var HTMLFile : File = _selectedDir.resolvePath("index.html");
			fs.open(HTMLFile, FileMode.WRITE);
			fs.writeUTFBytes(Model.getInstance().getHTML());
			fs.close();	
			
			//Copy the SWFObject file, but only if we've not included the js in the html
			if (!Model.getInstance().includeSO)
			{
				var SWFObjectFile : File = _selectedDir.resolvePath("data/js/swfobject.js");
				fs.open(SWFObjectFile, FileMode.WRITE);
				fs.writeUTFBytes(AssetsManager.getSWFObject(Model.getInstance().soVersion));
				fs.close();
			}
			
			//Copy expressInstall.swf if expressInstall is enabled
			if (Model.getInstance().expressInstall)
			{
				var expressInstallFile : File = _selectedDir.resolvePath("data/swf/expressInstall.swf");
				fs.open(expressInstallFile, FileMode.WRITE);
				var ba : ByteArray = new AssetsManager.EXPRESS_INSTALL() as ByteArray;
				fs.writeBytes(ba);
				fs.close();
			}
			
			
			//Create the zip
			if (_zipIt) createZip();
			//TODO: Open the folder
		}
	}
}