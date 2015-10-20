New(filename:="",text:=""){
	ts:=settings.ssn("//template").text,file:=FileOpen("c:\windows\shellnew\template.ahk",0),td:=file.Read(file.length),file.close(),template:=ts?ts:td,index:=0
	if(filename=1||text=""){
		while,FileExist(A_WorkingDir "\Projects\Untitled\Untitled" A_Index)
			index:=A_Index
		index++
		FileCreateDir,% A_WorkingDir "\Projects\Untitled\Untitled" index
		filename:=A_WorkingDir "\Projects\Untitled\Untitled" index "\Untitled.ahk"
		FileAppend,%template%,%filename%
	}else if(filename=""){
		FileSelectFile,filename,S,% ProjectFolder(),Create A New Project,*.ahk
		if(ErrorLevel)
			return
		filename:=SubStr(filename,-3,1)="."?filename:filename ".ahk"
		if(InStr(filename,".ahk"))
			FileAppend,%template%,%filename%
	}else if(text){
		SplitPath,filename,,outdir
		FileCreateDir,%outdir%
		FileAppend,%text%,%filename%
	}
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	tv:=open(filename,1),tv(tv)
}