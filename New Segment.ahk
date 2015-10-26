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
	Relative:=RegExReplace(relativepath(cur,new),"i)^lib\\([^\\]+)\.ahk$","<$1>"),func:=clean(func)
	SplitPath,newdir,last
	sc.2003(sc.2006,["`n#Include " Relative])
	FileAppend,% m("Create Function Named " function "?","btn:yn")="yes"?function "(){`r`n`r`n}":"",%new%,UTF-8
	Refresh_Current_Project(new)
	Sleep,300
	sc.2025(StrLen(function)+1),NewIndent()
}