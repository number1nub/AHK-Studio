Run(){
	if(v.options.Virtual_Scratch_Pad&&InStr(current(2).file,"Scratch Pad.ahk")){
		DynaRun(csc().getuni())
		return
	}
	sc:=csc(),getpos(),save(),file:=ssn(current(1),"@file").text
	SplitPath,file,,dir,ext
	if(!current(1).xml)
		return
	if(file=A_ScriptFullPath)
		exit(1)
	main:=ssn(current(1),"@file").text
	run:=FileExist(dir "\AutoHotkey.exe")?Chr(34) dir "\AutoHotkey.exe" Chr(34) " " Chr(34) file Chr(34):Chr(34) file Chr(34)
	admin:=v.options.run_as_admin?"*RunAs ":""
	Run,%admin%%run%,%dir%,,pid
	if(!IsObject(v.runpid))
		v.runpid:=[]
	v.runpid.Insert(pid)
	if(file=A_ScriptFullPath)
		ExitApp
}
Run_As_U32(){
	Run_As("AutoHotkeyU32")
}
Run_As_U64(){
	Run_As("AutoHotkeyU64")
}
Run_As_Ansii(){
	Run_As("AutoHotkeyA32")
}
Run_As(exe){
	file:=current(2).file
	SplitPath,A_AhkPath,,dir
	SplitPath,file,,fdir
	Run,%dir%\%exe% "%file%",%fdir%
}