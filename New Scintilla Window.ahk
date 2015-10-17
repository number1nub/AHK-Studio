New_Scintilla_Window(file=""){
	sc:=csc(),GetPos(),doc:=current(3).sc,sc:=new s(1,{main:1,hide:1}),csc({hwnd:sc.sc})
	if(doc)
		sc.2358(0,doc),SetPos(doc)
	sc.2400(),sc.show(),Resize("rebar")
}