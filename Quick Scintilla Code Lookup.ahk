Quick_Scintilla_Code_Lookup(){
	static list
	sc:=csc(),word:=upper(sc.textrange(start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1)))
	if(!list)
		list:=scintilla(1)
	ea:=scintilla.ea("//commands/item[@name='" word "']")
	if(ea.code){
		syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
		if ea.syntax
			sc.2025(sc.2008-1),Context()
		return
	}
	slist:=scintilla.sn("//commands/item[contains(@name,'" word "')]"),ll:="",count:=0
	while,sl:=slist.item[A_Index-1]
		ll.=ssn(sl,"@name").text " ",count++
	if(count=0)
		return
	sc.2117(1,Trim(ll)),sc.2160(start,end)
}