QF(){
	static quickfind:=[],find,lastfind,minmax,break,select
	qf:
	sc:=csc(),startpos:=sc.2008,break:=1
	ControlGetText,find,Edit1,% hwnd([1])
	if(find=lastfind&&sc.2570>1){
		if(GetKeyState("Shift","P"))
			return current:=sc.2575,sc.2574((current=0)?sc.2570-1:current-1),CenterSel()
		return sc.2606(),CenterSel()
	}
	pre:="O",find1:="",find1:=v.options.regex?find:"\Q" RegExReplace(find, "\\E", "\E\\E\Q") "\E",pre.=v.options.greed?"":"U",pre.=v.options.case_sensitive?"":"i",pre.=v.options.multi_line?"m`n":"",find1:=pre ")" find1 ""
	if(find=""||find="."||find=".*"||find="\")
		return sc.2571
	opos:=select.opos,select:=[],select.opos:=opos?opos:sc.2008,select.items:=[],text:=sc.getuni()
	if(sc.2508(0,start:=quickfind[sc.2357]+1)!=""){
		end:=sc.2509(0,start)
		if(end)
			text:=SubStr(text,1,end)
	}
	sc.Enable(),pos:=start?start:1,pos:=pos=0?1:pos,mainsel:="",index:=1,break:=0
	if(!IsObject(minmax))
		minmax:=[],minmax.1:={min:0,max:sc.2006},delete:=1
	for a,b in MinMax{
		search:=sc.textrange(b.min,b.max,1),pos:=1,start:=b.min-1
		while,RegExMatch(search,find1,found,pos){
			if(break){
				break:=0
				Break,2
			}
			if(found.Count()){
				if(!found.len(A_Index))
					Break
				Loop,% found.Count()
					ns:=StrPut(SubStr(search,1,found.Pos(A_Index)),"utf-8")-1,select.items.push({start:start+ns,end:start+ns+StrPut(found[A_Index])-1}),pos:=found.Pos(A_Index)+found.len(A_Index)
			}else{
				if(found.len=0)
					Break
				ns:=StrPut(SubStr(search,1,found.Pos(0)),"utf-8")-1,select.items.InsertAt(1,{start:start+ns,end:start+ns+StrPut(found[0])-1}),pos:=found.Pos(0)+found.len(0)
			}
			if(lastpos=pos)
				Break
			lastpos:=pos
		}
	}
	lastfind:=find
	if(select.items.MaxIndex()=1)
		obj:=select.items.1,sc.2160(obj.start,obj.end)
	else{
		num:=-1
		while,obj:=select.items.pop(){
			if(break)
				break
			sc[A_Index=1?2160:2573](obj.start,obj.end),num:=(obj.end>select.opos&&num<0)?A_Index-1:num
		}
		if(num>=0)
			sc.2574(num)
	}select:=[],sc.Enable(1),CenterSel(),Notify("setpos")
	return
	next:
	sc:=csc(),sc.2606(),sc.2169()
	return
	Clear_Selection:
	sc:=csc(),sc.2500(2),sc.2505(0,sc.2006),quickfind.remove(sc.2357),minmax:=""
	return
	Set_Selection:
	sc:=csc(),sc.2505(0,sc.2006),sc.2500(2)
	if(sc.2008=sc.2009)
		goto,Clear_Selection
	if(!IsObject(MinMax)),pos:=posinfo()
		minmax:=[]
	Loop,% sc.2570
		o:=[],o[sc.2577(A_Index-1)]:=1,o[sc.2579(A_Index-1)]:=1,minmax.Insert({min:o.MinIndex(),max:o.MaxIndex()})
	for a,b in minmax
		sc.2504(b.min,b.max-b.min)
	return
	Quick_Find:
	if(v.options.Auto_Set_Area_On_Quick_Find)
		gosub,Set_Selection
	ControlFocus,Edit1,% hwnd([1])
	ControlSend,Edit1,^A,% hwnd([1])
	lastfind:=""
	return
	Case_Sensitive:
	Regex:
	Multi_Line:
	Greed:
	onoff:=settings.ssn("//Quick_Find_Settings/@ " A_ThisLabel).text?0:1,att:=[],att[A_ThisLabel]:=onoff,settings.add("Quick_Find_Settings",att)
	GuiControl,1:,% RegExReplace(A_ThisLabel,"_"," "),%onoff%
	ToggleMenu(A_ThisLabel),v.options[A_ThisLabel]:=onoff,lastfind:=""
	ControlGetText,text,Edit1,% hwnd([1])
	if(text)
		goto,qf
	return
	checkqf:
	ControlGetFocus,Focus,% hwnd([1])
	if(Focus="Edit1")
		goto,qf
	else if(A_ThisHotkey="+Enter"||A_ThisHotkey="enter")
		replace(),MarginWidth()
	else
		marginwidth()
	if(v.options.full_auto)
		SetTimer,full,-10
	return
	full:
	sc:=csc()
	SetTimer,gofull,-1
	return
	gofull:
	fix_indent()
	GuiControl,1:+Redraw,% sc.sc
	return
}