New_Segment(new:="",text:="",adjusted:=""){
	cur:=adjusted?adjusted:current(2).file,sc:=csc(),parent:=mainfile:=current(2).file
	SplitPath,cur,,dir
	maindir:=dir
	if(!new){
		FileSelectFile,new,s,%dir%,Create a new Segment,*.ahk
		if(ErrorLevel)
			return
		new:=new~="\.ahk$"?new:new ".ahk"
		if(FileExist(new))
			return m("File Already Exists.","Please create a new file")
		SplitPath,new,filename,dir,,func
	}
	if(node:=ssn(current(1),"descendant::file[@file='" new "']"))
		return tv(ssn(node,"@tv").Text)
	SplitPath,new,file,newdir,,function
	Gui,1:Default
	Relative:=RegExReplace(relativepath(cur,new),"i)^lib\\([^\\]+)\.ahk$","<$1>")
	if(v.options.Includes_In_Place=1)
		sc.2003(sc.2008,"#Include " relative)
	else
		maintext:=Update({get:current(2).file}),update({file:current(2).file,text:maintext "`n#Include " Relative})
	/*
		Relative:=RegExReplace(relativepath(cur,new),"i)^lib\\([^\\]+)\.ahk$","<$1>")
	*/
	func:=clean(func)
	SplitPath,newdir,last
	FileAppend,% m("Create Function Named " clean(function) "?","btn:yn")="yes"?clean(function) "(){`r`n`r`n}":"",%new%,UTF-8
	Refresh_Current_Project(new)
	Sleep,300
	sc.2025(StrLen(function)+1),NewIndent()
}