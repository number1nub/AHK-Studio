ExecScript(Script, Wait:=false){
	shell:=ComObjCreate("WScript.Shell"),exec:=shell.Exec("AutoHotkey.exe /ErrorStdOut *"),exec.StdIn.Write(script),exec.StdIn.Close()
	if(Wait)
		return exec.StdOut.ReadAll()
	return exec
}
Dyna_Run(){
	ExecScript(publish(1))
}