MissingPlugin(file,menuname){
	SplitPath,file,filename,dir
	if(dir="plugins"&&!FileExist(file)){
		if(m("This requires a plugin that has not been downloaded yet, Download it now?","btn:yn")="yes"){
			UrlDownloadToFile,https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/%filename%,%file%
			option:=menus.ssn("//*[@clean='" RegExReplace(menuname," ","_") "']/@option").text
			Refresh_Plugins()
			Run,%file% "%option%"
		}else
			return m("Unable to run this option.")
	}
}