SetPos(oea:=""){
	static
	if(IsObject(oea)){
		posinfo:=positions.ssn("//main[@file='" files.ssn("//*[@file='" oea.file "']/ancestor::main/@file").text "']/file[@file='" oea.file "']")
		nea:=files.ea("//*[@sc='" sc.2357 "']"),cea:=files.ea("//*[@file='" oea.file "']")
		SetTimer,Disable,-1
		Sleep,2
		if(oea.file!=nea.file)
			tv(cea.tv,2,1)
		if(oea.line)
			sc.2160(sc.2128(oea.line),sc.2136(oea.line))
		else
			sc.2160(oea.start,oea.end)
		SetTimer,CenterSel,-50
		SetTimer,Enable,-250
		return
	}
	delay:=(WinActive("A")=hwnd(1))?1:300
	if(delay=1)
		goto,spnext
	SetTimer,spnext,-%delay%
	GuiControl,1:+Redraw,% sc.sc
	return
	spnext:
	sc:=csc(),sc.2397(0),node:=files.ssn("//*[@sc='" sc.2357 "']"),file:=ssn(node,"@file").text,parent:=ssn(node,"ancestor::main/@file").text,posinfo:=positions.ssn("//main[@file='" parent "']/file[@file='" file "']"),doc:=ssn(node,"@sc").text,ea:=xml.ea(posinfo),fold:=ea.fold,breakpoint:=ea.breakpoint
	if(ea.file){
		Loop,Parse,fold,`,
			sc.2231(A_LoopField)
		Loop,Parse,breakpoint,`,
			sc.2043(A_LoopField,0)
		if(ea.start&&ea.end)
			sc.2160(ea.start,ea.end)
		if(ea.scroll!="")
			SetTimer,setscrollpos,-1
		return
		setscrollpos:
		if(ea.scroll)
			sc.2613(ea.scroll),sc.2400()
		return
	}
	return
}