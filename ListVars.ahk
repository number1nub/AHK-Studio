ListVars(){
	List_Variables:
	if(v.dbgsock=""&&x=0)
		return m("Currently no file being debugged"),debug.off()
	v.ddd.send("context_get -c 1")
	return
}