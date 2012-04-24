package zip
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import model.Model;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipOutput;

	public class Zipper
	{
		static private var zipInput:File = new File();
		static private var zipOutput:File = new File();
		static private var zipFile:ZipOutput;
		
		static private var temp:File;
		
		static private var files:Array = new Array();
		
		static public function getFilesFromDirectory(directory:File):void
		{
			var fileList:Array = directory.getDirectoryListing();
			for(var i:uint = 0;i<fileList.length;i++)
			{
				var stream:FileStream = new FileStream();
				var f:File = fileList[i] as File;
				var path:String = temp.getRelativePath(f);
				if(f.isDirectory)
				{
					getFilesFromDirectory(f);
					continue;
				}
				stream.open(f,FileMode.READ);
				var fileData:ByteArray = new ByteArray();
				stream.readBytes(fileData);
				var file:Object = new Object();
				if(path)
					file.name = path;
				else
					file.name = f.name;
				file.data = fileData;
				files.push(file);
			}
		}
		
		static public function zipFolder(dir : File):void
		{
			temp = new File(dir.url);
			
			getFilesFromDirectory(dir)
			createZIP();
			save(dir);
		}
		
		static public function createZIP():void
		{
			zipFile = new ZipOutput();
			for(var i:uint = 0; i<files.length; i++)
			{
				var zipEntry:ZipEntry = new ZipEntry(files[i].name);
				zipFile.putNextEntry(zipEntry);
				zipFile.write(files[i].data);
				zipFile.closeEntry();
			}
			zipFile.finish();
		}
		
		static public function save(dir : File):void
		{
			dir = dir.resolvePath(Model.getInstance().projectTitle+".zip");
			if(!dir.exists)
			{
				var stream:FileStream = new FileStream();
				stream.open(dir,FileMode.WRITE);
				stream.writeBytes(zipFile.byteArray);
				stream.close();
			}
		}
	}
}