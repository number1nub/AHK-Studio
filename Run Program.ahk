Run_Program(){
	if(!v.dbgsock)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("run")
}