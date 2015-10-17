Compile(main=""){
	main:=ssn(current(1),"@file").Text,v.compiling:=1
	SplitPath,main,,dir,,name
	SplitPath,A_AhkPath,file,dirr
	Loop,%dirr%\Ahk2Exe.exe,1,1
		file:=A_LoopFileFullPath
	if(!FileExist("temp"))
		FileCreateDir,temp
	FileDelete,temp\temp.upload
	FileAppend,% publish(1),temp\temp.upload
	SplashTextOn,200,100,Compiling,Please wait.
	Loop,%dir%\*.ico
		icon:=A_LoopFileFullPath
	if(icon)
		add=/icon "%icon%"
	RunWait,%file% /in "%A_ScriptDir%\temp\temp.upload" /out "%dir%\%name%.exe" %add%
	if(FileExist("upx.exe")){
		SplashTextOn,,50,Compressing EXE,Please wait...
		RunWait,upx.exe -9 "%dir%\%name%.exe",,Hide
	}
	FileDelete,temp\temp.upload
	SplashTextOff
	v.compiling:=0
}