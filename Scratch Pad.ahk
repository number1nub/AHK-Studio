Scratch_Pad(){
	static
	newpath:=A_ScriptDir "\projects\Scratch Pad\Scratch Pad.ahk"
	file:=current(3).file
	if(file=newpath){
		if(main&&current)
			tv(files.ssn("//main[@file='" main "']/descendant::file[@file='" current "']/@tv").text)
		else
			tv(files.ssn("//main/file/@tv").text)
	}else{
		main:=current(2).file,current:=current(3).file
		if(!FileExist(newpath))
			ts:=settings.ssn("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td,index:=0,new(newpath,template)
		else if(!files.ssn("//main/file[@file='" newpath "']/@tv").text)
			open(newpath),tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
		else
			tv(files.ssn("//main/file[@file='" newpath "']/@tv").text)
	}
}