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
		text:=sc.getseltext(),pos:=posinfo(),sc.2645(pos.start,pos.end-pos.start),sc.2003(sc.2008,"#Include " relative:=RelativePath(current(3).file,newsegment)),file:=FileOpen(newsegment,1,"UTF-8"),file.seek(0),file.write(text),file.length(file.position),update({file:newsegment,text:text}),node:=AddInclude(current(2).file,newsegment)
		GuiControl,1:+Redraw,SysTreeView321
		Code_Explorer.scan(node),Code_Explorer.scan(current())
	}
}
AddInclude(main,new){
	Relative:=RelativePath(main,new),path:=StrSplit(Relative,"\"),next:=current(1).firstchild
	if(!v.options.Full_Tree)
		for a,b in path
			if(a!=path.MaxIndex())
				slash:=v.options.Remove_Directory_Slash?"":"\",next:=files.under(next,"folder",{name:b,tv:FEAdd(slash b,ssn(next,"@tv").text,"Icon1 First Sort")})
	filename:=path[path.MaxIndex()]
	SplitPath,new,,dir
	FileGetTime,time,%new%
	node:=files.under(next,"file",{time:time,filename:filename,file:new,include:"#Include " Relative,tv:FEAdd(filename,ssn(next,"@tv").text,"Icon2 First Sort"),github:(folder!=rootfolder)?path[path.MaxIndex()-1] "\" filename:filename})
	mainfile:=cexml.ssn("//main[@file='" main "']")
	cexml.under(mainfile,"file",{type:"File",parent:ssn(mainfile,"@file").text,file:new,name:filename,folder:dir,order:"name,type,folder"})
	return node
}