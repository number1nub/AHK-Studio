Scratch_Pad(){
	static
	if(v.options.Virtual_Scratch_Pad){
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		if(!tv)
			top:=files.ssn("//*"),main:=files.under(top,"main",{file:"Virtual Scratch Pad.ahk"}),files.under(main,"file",{tv:tv:=TV_Add("Virtual Scratch Pad"),file:"Virtual Scratch Pad.ahk",virtual:1}),tv(tv)
		else if(TV_GetSelection()!=tv)
			tv(tv)
		else
			History({back:1})
		return
	}
	newpath:=A_ScriptDir "\projects\Scratch Pad\Scratch Pad.ahk"
	file:=current(3).file
	if(file=newpath){
		if(main&&current)
			tv(files.ssn("//main[@file='" main "']/descendant::file[@file='" current "']/@tv").text)
		else
			tv(files.ssn("//main/file/@tv").text)
	}else{
		main:=current(2).file,current:=current(3).file
		if(!FileExist(newpath)){
			ts:=settings.ssn("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td,index:=0,new(newpath,template)
		}else if(!files.ssn("//main/file[@file='" newpath "']/@tv").text)
			open(newpath),tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
		else
			tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
	}
}