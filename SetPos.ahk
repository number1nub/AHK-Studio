SetPos(oea:=""){
	static
	if(IsObject(oea)){
		sc:=csc(),current:=files.ssn("//*[@file='" oea.file "']/ancestor::main/@file").text
		if(!top:=positions.ssn("//main[@file='" current "']"))
			top:=positions.add("main",{file:current},,1)
		if(!fix:=ssn(top,"descendant::file[@file='" oea.file "']"))
			fix:=settings.under(top,"file",{file:oea.file})
		nea:=files.ea("//*[@sc='" sc.2357 "']"),cea:=files.ea("//*[@file='" oea.file "']")
		SetTimer,Disable,-1
		Sleep,2
		if(oea.file!=nea.file)
			tv(cea.tv,2,1)
		(oea.line!="")?(end:=sc.2136(oea.line),start:=sc.2128(oea.line)):(end:=oea.end,start:=oea.start)
		fix.SetAttribute("start",oea.start),fix.SetAttribute("end",oea.end),sc.2160(start,end)
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
			sc.2231(A_LoopField) ;*[My Breakpoint]
		/*
			Loop,Parse,breakpoint,`, ;*[Another (options to come later?)]
				sc.2043(A_LoopField,1)
		*/
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