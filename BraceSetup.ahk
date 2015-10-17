BraceSetup(Win=1){
	static oldkeys:=[]
	Hotkey,IfWinActive,% hwnd([win])
	for a in oldkeys
		Hotkey,%a%,brace,Off
	v.brace:=[],autoadd:=settings.sn("//autoadd/*")
	if(!RegExReplace(test:=settings.ssn("//autoadd/*/@trigger").text,"\d"))
		while,aa:=autoadd.item[A_Index-1],ea:=xml.ea(aa)
			aa.SetAttribute("trigger",Chr(ea.trigger)),aa.SetAttribute("add",Chr(ea.add))
	v.braceadvance:=[],oldkeys:=[]
	while,aa:=autoadd.item(a_index-1),ea:=xml.ea(aa){
		if(ea.trigger){
			v.brace[ea.trigger]:=ea.add,v.braceadvance[ea.add]:=Asc(ea.add),oldkeys[ea.trigger]:=1
			if(ea.trigger!=ea.add)
				oldkeys[ea.Add]:=1
		}
	}
	for a in oldkeys
		Hotkey,%a%,brace,On
}