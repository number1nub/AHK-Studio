stop(x:=0){
	Stop_Debugger:
	if(v.dbgsock=""&&x=0)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("stop")
	sleep,200
	v.ddd.debug.disconnect()
	v.ddd.debug.off()
	csc("Scintilla1")
	return
}