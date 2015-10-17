Test_Plugin(){
	Save(),Exit(1,1)
	Run,%A_ScriptFullPath%
	ExitApp
	return
}