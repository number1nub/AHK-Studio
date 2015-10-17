One_Backup(){
	current:=current(2).file
	SplitPath,current,,dir
	RunWait,% comspec " /C RD /S /Q " Chr(34) dir "\backup" Chr(34),,Hide
	Full_Backup()
}