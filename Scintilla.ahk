Scintilla(return:=""){
	static list
	filedate:=20151111121313
	FileGetTime,time,lib\scintilla.xml
	if(time<=filedate)
		FileDelete,lib\scintilla.xml
	if(!FileExist("lib\scintilla.xml")){
		SplashTextOn,300,100,Downloading definitions,Please wait
		URLDownloadToFile,http://files.maestrith.com/AHK-Studio/scintilla.xml,lib\scintilla.xml
		SplashTextOff
		FileSetTime,%filedate%,lib\scintilla.xml
	}
	if(!IsObject(scintilla)){
		ll:=scintilla.sn("//commands/*")
		while,l:=ssn(ll.item[A_Index-1],"@name").text
			list.=l " "
		list:=Trim(list)
		scintilla:=new xml("scintilla","lib\scintilla.xml")
	}
	if(return)
		return list
}