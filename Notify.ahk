Notify(csc:=""){
	static last,lastline,lastpos:=[],focus:=[],dwellfold:="",spam
	if(csc=0)
		return lastpos:=[]
	notify:
	fn:=[],info:=A_EventInfo,code:=NumGet(info+(A_PtrSize*2))
	if(NumGet(info+0)=v.debug.sc&&v.debug.sc)
		return
	if(info=256||info=512||info=768)
		return
	if(code=2029||(code=2007&&WinActive(hwnd([1]))=0)){
		getpos(),focus:=sc:=csc()
		if(!WinActive(hwnd([1])))
			lastpos[current(3).sc]:={2008:sc.2008,2009:sc.2009,2152:sc.2152}
		else
			lastpos[current(3).sc]:=[]
		return ;focus:=[]
	}
	if(code=2028){
		sc:=focus.sc?focus:csc(1),lp:=lastpos[current(3).sc],csc(1)
		if((sc.2008!=lp.2008||sc.2009!=lp.2009||sc.2152!=lp.2152)&&lp.2008!="")
			sc.2160(lp.2008,lp.2009),sc.2613(lp.2152)
		SetTimer,Enable,-10
		SetTimer,LButton,-200
		if(v.options.Check_For_Edited_Files_On_Focus=1)
			check_for_edited()
		csc(1)
		return
	}
	if(!s.ctrl[NumGet(info+0)])
		return
	if code not in 2001,2002,2004,2006,2007,2008,2010,2014,2018,2019,2021,2022,2027
		return 0
	;0:"Obj",2:"Code",4:"ch",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",17:"listType",22:"updated"
	for a,b in {0:"Obj",2:"Code",3:"position",4:"ch",5:"mod",6:"modType",7:"text",8:"length",9:"linesadded",10:"msg",11:"wparam",12:"lparam",13:"line",14:"fold",17:"listType",22:"updated"}
		fn[b]:=NumGet(Info+(A_PtrSize*a))
	if(fn.code=2010){
		margin:=NumGet(Info+(A_PtrSize*16)),line:=sc.2166(fn.position)
		if(margin=3)
			sc.2231(line)
		if(margin=1){
			if(!GetKeyState("Shift","P")){
				text:=Trim(sc.getline(line))
				if(RegExMatch(text,"\s+;#\[.*\]"))
					start:=sc.2128(line),pos:=RegExMatch(text,"UO)(\s*;#\[.*\])",found),sc.2190(start+pos-1),sc.2192(start+pos-1+found.len(1)),sc.2194(0,""),code_explorer.scan(current())
				else
					text:=sc.gettext(),text:=SubStr(text,1,sc.2128(line)),slash:=RegExMatch(text,"(\s*;#\[.*\])")?"/":"",end:=sc.2136(line),start:=sc.2128(line),_:=start=end?(add:=3+StrLen(slash),space:=""):(add:=4+StrLen(slash),space:=" "),sc.2003(end,space Chr(59) "#[" slash (name:=SubStr(current(3).filename,1,-4)) "]"),sc.2160(end+add,end+add+StrPut(name,utf-8)-1)
			}else if(GetKeyState("Shift","P")){
				/*
					add the stop point for debugging
				*/
			}
		}
	}if(fn.code=2022){
		if v.options.Autocomplete_Enter_Newline
			SetTimer,sendenter,100
		Else{
			v.word:=StrGet(fn.text,"utf-8")
			if(v.word="#Include"&&v.options.Disable_Include_Dialog!=1)
				SetTimer,getinclude,-200
			else if(v.word~="i)(goto|gosub)")
				SetTimer,goto,-100
			else if(v.word="settimer")
				SetTimer,showlabels,-80
			else
				SetTimer,automenu,-100
		}
	}if(code=2007)
		uppos()
	if(fn.code=2001){
		if(fn.ch=46)
			if(fn.ch=46)
				Show_Class_Methods(sc.textrange(sc.2266(sc.2008-1,1),sc.2267(sc.2008-1,1)))
		if(fn.ch=10&&v.options.full_auto){
			GuiControl,1:-Redraw,% sc.sc
			if(sc.2007(sc.2008)=125&&sc.2007(sc.2008-2)=123)
				sc.2003(sc.2008,"`n")
			SetTimer,newindent,-10
			return
		}
		if(fn.ch=10&&v.options.full_auto!=1){
			SetTimer,fix_next,-50
			return
		}cpos:=sc.2008,start:=sc.2266(cpos,1),end:=sc.2267(cpos,1),word:=sc.getword()
		if((StrLen(word)>1&&sc.2102=0&&v.options.Disable_Auto_Complete!=1&&sc.2010(cpos)~="\b(13|1|11|3)\b"=0)){
			word:=RegExReplace(word,"^\d*"),list:=Trim(v.keywords[SubStr(word,1,1)]),code_explorer.varlist[current(2).file]
			if(!sc.2202&&v.options.Disable_Auto_Complete_While_Tips_Are_Visible=1){
			}else
				if(list&&instr(list,word))
					sc.2100(StrLen(word),list)
		}style:=sc.2010(sc.2008-2)
		settimer,context,-150
		c:=fn.ch
		if c in 44,32
			replace()
		if(fn.ch=44&&v.options.Auto_Space_After_Comma)
			sc.2003(sc.2008," "),sc.2025(sc.2008+1)
	}if(fn.code=2008){
		if(fn.modtype&0x02){
			del:=SubStr(StrGet(fn.text,"utf-8"),1,1)
			if(delete:=v.match[del]){
				if(Chr(sc.2007(sc.2008))=delete){
					SetTimer,deleteit,-0
					return
					deleteit:
					sc.2645(sc.2008,1)
					return
		}}}
		if((fn.modtype&0x01)||(fn.modtype&0x02))
			update({sc:sc.2357})
		if(fn.modtype&0x02)
			update({sc:sc.2357})
		if(fn.linesadded)
			MarginWidth(sc)
		return
	}if(fn.code=2001)
		ch:=fn.ch?fn.ch:sc.2007(sc.2008),uppos(),SetStatus("Last Entered Character: " Chr(ch) " Code:" ch,2)
	if(fn.code=2014){
		if(fn.listtype=1){
			if(!IsObject(scintilla))
				scintilla:=new xml("scintilla","lib\scintilla.xml")
			command:=StrGet(fn.text,"utf-8"),info:=scintilla.ssn("//commands/item[@name='" command "']"),ea:=xml.ea(info),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),syn:=ea.syntax?ea.code "()":ea.code,sc.2160(start,end),sc.2170(0,[syn])
			if(ea.syntax)
				sc.2025(sc.2008-1),sc.2200(start,ea.code ea.syntax)
		}Else if(fn.listType=2){
			vv:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,vault.ssn("//*[@name='" vv "']").text)
			if(v.options.full_auto)
				SetTimer,fullauto,-1
		}else if(fn.listType=3)
			text:=StrGet(fn.text,"utf-8") "()",start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text),sc.2025(sc.2008+StrLen(text)-1)
		else if(fn.listtype=4)
			text:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text "."),sc.2025(sc.2008+StrLen(text ".")),Show_Class_Methods(text)
		else if(fn.listtype=5){
			text:=StrGet(fn.text,"utf-8"),start:=sc.2266(sc.2008,1),end:=sc.2267(sc.2008,1),sc.2645(start,end-start),sc.2003(sc.2008,text "()"),sc.2025(sc.2008+StrLen(text "."))
			SetTimer,context,-10
		}
	}
	return
	sendenter:
	SetTimer,sendenter,Off
	Send,{Enter}
	if(v.options.full_auto)
		SetTimer,fullauto,10
	return
	enable:
	for a,b in s.ctrl
		GuiControl,1:+Redraw,% b.sc
	return
}