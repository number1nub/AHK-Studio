Delete_Project(x:=0){
	project:=current(2).file
	if(x=0)
		MsgBox,292,Are you sure?,This process can not be undone!`nDelete %project% and all its backups
	IfMsgBox,No
		return
	Close(0)
	if(v.options.Hide_Code_Explorer!=1)
		Code_Explorer.Refresh_Code_Explorer()
	SplitPath,project,,dir
	FileRecycle,%dir%
}