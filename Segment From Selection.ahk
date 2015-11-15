Create_Segment_From_Selection(){
	pos:=posinfo(),sc:=csc()
	if(pos.start=pos.end)
		return m("Please select some text to create a new segment from")
	else{
		text:=sc.getseltext(),RegExMatch(text,"^(\w+)",segment),filename:=ssn(current(1),"@file").text
		SplitPath,filename,,dir
		FileSelectFile,newsegment,,%dir%\%segment1%
		newsegment:=InStr(newsegment,".ahk")?newsegment:newsegment ".ahk"
		if(ErrorLevel)
			return
		if(FileExist(newsegment))
			return m("Segment name already exists. Please choose another")
		text:=sc.getseltext(),pos:=posinfo()
		if(v.options.Includes_In_Place=1)
			sc.2003(sc.2008,"#Include " relative:=RelativePath(current(3).file,newsegment))
		else
			Relative:=RegExReplace(RelativePath(current(2).file,newsegment),"i)^lib\\([^\\]+)\.ahk$","<$1>"),maintext:=Update({get:current(2).file}),update({file:current(2).file,text:maintext "`n#Include " Relative})
		sc.2645(pos.start,pos.end-pos.start),file:=FileOpen(newsegment,1,"UTF-8"),file.seek(0),file.write(text),file.length(file.position),file.Close(),update({file:newsegment,text:text}),Refresh_Current_Project()
		GuiControl,1:+Redraw,SysTreeView321
}}