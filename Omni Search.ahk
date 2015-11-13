Omni_Search(start=""){
	static newwin,select:=[],obj:=[],pre
	if(hwnd(20))
		return
	code_explorer.scan(current())
	WinGetPos,x,y,w,h,% hwnd([1])
	width:=w-50
	newwin:=new GUIKeep(20)
	Gui,20:Margin,0,0
	width:=w-50,newwin.Add("Edit,goss w" width " vsearch," start,"ListView,w" width " r15 -hdr -Multi gosgo,Menu Command|Additional|1|2|Rating|index")
	Gui,20:-Caption
	hotkeys([20],{up:"omnikey",down:"omnikey",PgUp:"omnikey",PgDn:"omnikey","^Backspace":"deleteback",Enter:"osgo"})
	Gui,20:Show,% Center(20) " AutoSize",Omni-Search
	ControlSend,Edit1,^{End},% hwnd([20])
	bm:=bookmarks.sn("//mark")
	if(top:=cexml.ssn("//bookmarks"))
		top.ParentNode.RemoveChild(top)
	top:=cexml.Add("bookmarks")
	while,bb:=bm.item[A_Index-1],ea:=bo
		okmarks.ea(bb)
	if(!cexml.ssn("//bookmark/*[@file='" ssn(bb.ParentNode,"@file").text "']"))
		cexml.under(top,"bookmark",{type:"bookmark",text:ea.name,line:ea.line,file:ssn(bb.ParentNode,"@file").text,order:"text,type,file",root:ssn(bb,"ancestor::main/@file").text})
	oss:
	break:=1
	SetTimer,omnisearch,-10
	return
	omnisearch:
	Gui,20:Default
	GuiControl,20:-Redraw,SysListView321
	osearch:=search:=newwin[].search,Select:=[],LV_Delete(),sort:=[],stext:=[],fsearch:=search="^"?1:0
	for a,b in StrSplit("@^({[&+#%<")
		osearch:=RegExReplace(osearch,"\Q" b "\E")
	if(InStr(search,"?")){
		LV_Delete()
		for a,b in omni_search_class.prefix{
			info:=a="+"?"Add Function Call":b
			LV_Add("",a,info)
		}
		GuiControl,20:+Redraw,SysListView321
		Loop,4
			LV_ModifyCol(A_Index,"AutoHDR")
		return
	}if(RegExMatch(search,"\W")){
		pos:=1,replist:=[],find1:="",index:=1
		while,RegExMatch(search,"O)(\W)",found,pos),pos:=found.Pos(1)+found.len(1){
			if(found.1=" ")
				Continue
			if(pre:=omni_search_class.prefix[found.1]){
				replist.push(found.1)
				if(found.1="+"){
					find:="//main[@file='" current(2).file "']/descendant::*[@type='Class' or @type='Function'"
					break
				}else if(pre)
					add:="@type='" pre "'"
				find1.=index>1?" or " add:add
			}index++
		}
		for a,b in replist
			search:=RegExReplace(search,"\Q" b "\E")
		find:=find1?"//*[" find1 "]":"//*"
	}else
		find:="//*"
	for a,b in searchobj:=StrSplit(search)
		stext[b]:=stext[b]=""?1:stext[b]+1
	list:=cexml.sn(find),break:=0,currentparent:=current(2).file
	while,ll:=list.Item[A_Index-1],b:=xml.ea(ll){
		if(break){
			break:=0
			break
		}
		order:=ll.nodename="file"?"name,type,folder":b.type="menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(order,","),text:=b[info.1],rating:=0,b.parent:=ssn(ll,"ancestor-or-self::main/@file").text
		if(!b.file)
			if(!b.file:=ssn(ll,"ancestor-or-self::file/@file").text)
				b.file:=ssn(ll,"ancestor-or-self::main/@file").text
		if(fsearch){
			if(b.file=ssn(ll,"ancestor::main/@file").text)
				rating+=50
			if(currentparent=b.file)
				rating+=100
		}else{
			if(search){
				for c,d in stext{
					RegExReplace(text,"i)" c,"",count)
					if(Count<d)
						Continue,2
				}spos:=1
				for c,d in searchobj
					if(pos:=RegExMatch(text,"iO)(\b" d ")",found,spos),spos:=found.Pos(1)+found.len(1))
						rating+=100/pos
				if(pos:=InStr(text,osearch))
					rating+=400/pos
				if(currentparent=ssn(ll,"ancestor::main/@file").text)
					rating+=100
			}
		}
		two:=info.2="type"&&v.options.Show_Type_Prefix?omni_search_class.iprefix[b[info.2]] "  " b[info.2]:b[info.2]
		item:=LV_Add("",b[info.1],two,b[info.3],b[info.4],rating,LV_GetCount()+1)
		Select[item]:=b
	}
	Loop,4
		LV_ModifyCol(A_Index,"Auto")
	for a,b in [5,6]
		LV_ModifyCol(b,0)
	LV_ModifyCol(5,"Logical SortDesc")
	LV_Modify(1,"Select Vis Focus")
	GuiControl,20:+Redraw,SysListView321
	return
	20GuiEscape:
	20GuiClose:
	hwnd({rem:20})
	return
	osgo:
	Gui,20:Default
	LV_GetText(num,LV_GetNext(),6),item:=Select[num],search:=newwin[].search,pre:=SubStr(search,1,1)
	if(InStr(search,"?")){
		LV_GetText(pre,LV_GetNext())
		ControlSetText,Edit1,%pre%,% newwin.id
		ControlSend,Edit1,^{End},% newwin.id
		return
	}else if(type:=item.launch){
		text:=clean(item.text)
		if(type="label")
			SetTimer,%text%,-1
		else if(type="func"){
			v.runfunc:=text
			SetTimer,runfunc,-100
		}else
			Run,%type%
		hwnd({rem:20})
	}else if(pre="+"){
		hwnd({rem:20}),args:=item.args,sc:=csc(),args:=RegExReplace(args,"U)=?" chr(34) "(.*)" chr(34)),build:=item.text "("
		for a,b in StrSplit(args,",")
			comma:=a_index>1?",":"",value:=InputBox(sc.sc,"Add Function Call","Insert a value for : " b " :`n" item.text "(" item.args ")`n" build ")",""),value:=value?value:Chr(34) Chr(34),build.=comma value
		build.=")"
		sc.2003(sc.2008,build)
	}else if(item.type="file"){
		hwnd({rem:20}),tv(files.ssn("//main[@file='" item.parent "']/descendant::file[@file='" item.file "']/@tv").text)
	}else if(item.type~="i)(breakpoint|label|instance|method|function|hotkey|class|property|variable|bookmark)"){
		hwnd({rem:20}),TV(files.ssn("//*[@file='" item.file "']/@tv").text)
		Sleep,200
		item.text:=item.type="class"?"class " item.text:item.text
		(item.type~="i)bookmark|breakpoint")?(sc:=csc(),line:=sc.2166(item.pos),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()):(csc().2160(item.pos,item.pos+StrPut(item.text,"Utf-8")-1),v.sc.2169,getpos(),v.sc.2400)
	}
	return
	omnikey:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.id
	return
	deleteback:
	GuiControl,20:-Redraw,Edit1
	Send,+^{Left}{Backspace}
	GuiControl,20:+Redraw,Edit1
	return
}