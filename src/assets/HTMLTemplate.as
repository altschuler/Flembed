package assets
{
	import model.FileInfo;
	import model.Flashvar;
	import model.Model;

	public class HTMLTemplate
	{
		public static const SWF_OBJECT_1_5 : String = "SWF_OBJECT_1_5";
		public static const SWF_OBJECT_2 : String = "SWF_OBJECT_2";
		
		public static function getHTML():String
		{
			var s : String = AssetsManager.getHTMLTemplate(AssetsManager.HTML_DYNAMIC);
			
			//Create flashvars
			var hasFlashvars : Boolean = Model.getInstance().flashvars ? Boolean(Model.getInstance().flashvars.length) : false;
			var fvString : String = "";
			if (hasFlashvars)
			{
				fvString += indent(3) + "var flashvars = {\n";
				for each (var fv : Flashvar in Model.getInstance().flashvars.source)
				{
					fvString += indent(3) + fv.name + ":'" + fv.value + "',\n";
				}
				
				fvString += indent(2) + "};";
				
			}
			s = s.replace(/#FLASHVARS#/, fvString);
			s = s.replace(/#SWFOBJECT_INCLUDE#/, scriptinclude());
			
			var embeds : String = new String();
			var divs : String = new String();
			for each (var fi : FileInfo in Model.getInstance().files.source)
			{
				if (fi.isSWF)
					embeds += indent(3) + js(fi, hasFlashvars, false) + "\n";
				
				divs += div(fi) + "\n";
			}
			
			s = s.replace(/#HTML_START_TAG#/, htmltag());
			s = s.replace(/#DOC_TYPE#/, doctype());
			s = s.replace(/#CHARSET#/, charset());
			s = s.replace(/#SWF_EMBED#/, embeds);
			s = s.replace(/#DIVS#/, divs);
			s = s.replace(/#PAGE_TITLE#/, Model.getInstance().pageTitle);
			s = s.replace(/#SWFOBJECT_PATH#/, Model.getInstance().includeSO ? "" : Model.getInstance().hasSWF() ? '<script type="text/javascript" src="'+'data/js/swfobject.js'+'"></script>\n' : "");
			s = s.replace(/#STYLES#/, styles());
			
			return s;
		}

		private static function htmltag():String
		{
			return Model.getInstance().html5Embed ? '<html lang="en">' : '<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">';
		}

		public static function getPreviewHTML():String
		{
			var s : String = AssetsManager.getHTMLTemplate(AssetsManager.HTML_DYNAMIC);
			
			var embeds : String = new String();
			var divs : String = new String();
			for each (var fi : FileInfo in Model.getInstance().files.source)
			{
				if (fi.isSWF)
					embeds += js(fi, false, true) + "\n";
				
				divs += div(fi, true) + "\n";
			}
			
			s = s.replace(/#HTML_START_TAG#/, htmltag());
			s = s.replace(/#DOC_TYPE#/, doctype());
			s = s.replace(/#CHARSET#/, charset());
			s = s.replace(/#SWFOBJECT_INCLUDE#/, AssetsManager.getSWFObject(Model.getInstance().soVersion));
			s = s.replace(/#FLASHVARS#/, "");
			s = s.replace(/#SWF_EMBED#/, embeds);
			s = s.replace(/#DIVS#/, divs);
			s = s.replace(/#PAGE_TITLE#/, Model.getInstance().pageTitle);
			s = s.replace(/#SWFOBJECT_PATH#/, "");
			s = s.replace(/#STYLES#/, styles());
			
			return s;
		}
		
		private static function charset():String
		{
			return Model.getInstance().html5Embed ? '<meta charset="'+Model.getInstance().charset.value+'">' : '<meta http-equiv="Content-Type" content="text/html; charset='+Model.getInstance().charset.value+'" />';
		}
		
		private static function scriptinclude():String
		{
			return Model.getInstance().includeSO ? AssetsManager.getSWFObject(Model.getInstance().soVersion) : "";
		}
		
		private static function doctype():String
		{
			if (Model.getInstance().html5Embed) return "<!DOCTYPE html>";
			else return Model.getInstance().docType.value;
		}
		
		private static function indent(v:int):String
		{
			var s : String = new String();
			while (v-- > 0)
				s += "\t";
			return s;
		}
		
		private static function styles():String
		{
			var s : String = new String();
			
			if (Model.getInstance().isSingleFile)
			{
				s+=indent(2)+"html{height:100%}\n";
				s+=indent(2)+"body {background:#"+toHexString(Model.getInstance().backgroundColor)+"; margin:0 auto; height:100%; overflow:hidden;}\n";
			}
			else
			{
				s+=indent(2)+"body {background:#"+toHexString(Model.getInstance().backgroundColor)+";}\n";
			}
			
			s+=indent(2) + "a,p {color:#"+toHexString(Model.getInstance().textColor)+"; padding-bottom:5px;}"

			return s;
		}
		
		private static function js(fileInfo : FileInfo, flashvars:Boolean, preview : Boolean):String
		{
			var ei : String = Model.getInstance().expressInstall ? "data/swf/expressInstall.swf" : "false";
			var fpv : String = (Model.getInstance().rfpv.automatic ? fileInfo.fpversion : Model.getInstance().rfpv.label);
			var fv : String = flashvars ? ', flashvars' : '';
			
			var path : String = preview ? 'file:'+fileInfo.file.nativePath : 'data/swf/'+fileInfo.file.name;
			
			switch (Model.getInstance().soVersion)
			{
				case SWF_OBJECT_2:
					return 'swfobject.embedSWF("'+path+'", "flashcontent'+fileInfo.id+'", "'+fileInfo.width+'", "'+fileInfo.height+'", "'+fpv+'", "'+ei+'"'+fv+');'
				case SWF_OBJECT_1_5:
					//TODO SO1.5
					return 'swfobject.embedSWF("'+path+'", "flashcontent'+fileInfo.id+'", "'+fileInfo.width+'", "'+fileInfo.height+'", "'+fpv+'", "'+ei+'"'+fv+');'
				default:
					break;
			}
			
			return "";
		}

		private static function div(fileInfo : FileInfo, preview : Boolean = false):String
		{
			var s : String = new String();
			if (Model.getInstance().html5Embed)
				s += indent(2) + '<article id="content'+fileInfo.id+'">\n';
			else
				s += indent(2) + '<div id="content'+fileInfo.id+'">\n';
			
			//TODO html tags
			
			if (fileInfo.title.length > 0) 
			{
				if (Model.getInstance().html5Embed)
					s += indent(3) + '<header>\n'+indent(4)+'<p>'+fileInfo.title + '</p>' + '\n'+indent(3)+'</header>\n';
				else
					s += indent(3) + '<p>'+fileInfo.title + '</p>\n' + indent(3) + '<br/>\n';
			}
			
			if (fileInfo.isSWF)
			{
				s += indent(3) + '<div id="flashcontent'+fileInfo.id+'">\n';
				
				switch (Model.getInstance().soVersion)
				{
					case SWF_OBJECT_2:
						s +=  indent(4) + Model.getInstance().alternativeContent+'\n' + indent(3) + '</div>';
						break;
				}
			}
			else
			{
				var href : String = fileInfo.imageUrl ? "href='"+fileInfo.imageUrl+"'" : "";
				if (preview)
					s += indent(3) + '<img href="'+href+'" alt="'+fileInfo.file.name+'" src="file:' + fileInfo.file.nativePath + '"/>\n';
				else 
					s += indent(3) + '<img href="'+href+'" alt="'+fileInfo.file.name+'" src="data/img/' + fileInfo.file.name + '"/>\n';	
			}
			
			if (Model.getInstance().html5Embed)
				s += indent(2) + '</article>\n';
			else
				s += indent(2) + '</div>\n';
			
			s += indent(2) + '<br/>';
			return s;
		}
		
		private static function toHexString(value : int):String
		{
			var hexString:String = value.toString( 16 );
			while( hexString.length < 6 )
				hexString = '0' + hexString;
			
			return hexString;
		}
	}
}