AutoMenu(){
	AutoMenu:
	sc:=csc()
	if(sc.2007(sc.2008-1)~="40|123")
		return
	command:=RegExReplace(context(1),"#")
	if(v.word&&sc.2102=0&&v.options.Disable_Auto_Complete!=1){
		if(l:=commands.ssn("//Context/" command "/descendant-or-self::list[text()='" RegExReplace(v.word,"#") "']")){
			if(!list:=ssn(l,"@list"))
				return
			insert:=v.options.Auto_Space_After_Comma?", ":","
			if(sc.2007(sc.2008-StrLen(insert))!=44)
				sc.2003(sc.2008,insert),sc.2025(sc.2008+StrLen(insert))
			sc.2100(0,list.text,v.word:="")
		}
	}
	return
}