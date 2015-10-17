Current(parent=""){
	sc:=csc(),node:=files.ssn("//*[@sc='" sc.2357 "']")
	if parent=1
		return ssn(node,"ancestor-or-self::main")
	if parent=2
		return xml.ea(ssn(node,"ancestor-or-self::main"))
	if parent=3
		return xml.ea(node)
	return node
}