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
	search:=newwin[].search,Select:=[],LV_Delete(),sort:=[],stext:=[]
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
		find:="//*[",pos:=1,replist:=[]
		while,RegExMatch(search,"O)(\W)",found,pos),pos:=found.Pos(1)+found.len(1){
			if(pre:=omni_search_class.prefix[found.1]){
				if(found.1="+"){
					find:="//main[@file='" current(2).file "']/descendant::*[@type='Class' or @type='Function']"
					break
				}else if(pre)
					add:="@type='" pre "'"
				find.=A_Index>1?" or " add:add
				replist.push(found.1)
			}
		}
		for a,b in replist
			search:=RegExReplace(search,"\Q" b "\E")
		find.="]"
	}else
		find:="//*"
	for a,b in StrSplit(search)
		stext[b]:=stext[b]=""?1:stext[b]+1
	list:=cexml.sn(find),break:=0,currentparent:=current(2).file
	while,ll:=list.Item[A_Index-1]{
		if(break){
			break:=0
			break
		}
		b:=xml.ea(ll),order:=ll.nodename="file"?"name,type,folder":b.type="menu"?"text,type,additional1":"text,type,file,args",info:=StrSplit(order,","),rating:=0,text:=b[info.1],b.root:=ssn(ll,"ancestor::main[@file]/@file").text,b.parent:=ssn(ll,"ancestor-or-self::file[@file]/@file").text,b.file:=b.parent
		for c,d in stext{
			RegExReplace(text,"i)" c,"",count)
			if(d>count||count=0)
				Continue 2
			rating+=count
			if(count=d)
				rating+=10
		}
		if(div:=RegExMatch(text,"i)" sea:=RegExReplace(search,"(.)","\b$1.*"),found)){
			rating+=100/div
			for c,d in StrSplit(sea,"\b")
				rating+=20/RegExMatch(text,"i)\b" d)
		}
		if(ssn(ll,"ancestor::main[@file='" b.file "']")&&search="")
			rating+=100
		for c,d in StrSplit(search," ")
			if(RegExMatch(text,"i)\b" d))
				rating+=20
		if(SubStr(text,1,StrLen(search))=search)
			rating+=50
		if(SubStr(text,-3)=".ahk")
			rating+=40
		if(currentparent=ssn(ll,"ancestor::main/@file").text)
			rating+=30
		two:=info.2="type"&&v.options.Show_Type_Prefix?omni_search_class.iprefix[b[info.2]] "  " b[info.2]:b[info.2]
		item:=LV_Add("",b[info.1],two,b[info.3],b[info.4],rating,LV_GetCount()+1)
		Select[item]:=b
	}
	Loop,6
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
	}
	else if(item.type="file"){
		hwnd({rem:20}),tv(files.ssn("//main[@file='" item.root "']/descendant::file[@file='" item.parent "']/@tv").text)
	}else if(item.type~="i)(label|instance|method|function|hotkey|class|property|variable|bookmark)"){
		hwnd({rem:20}),TV(files.ssn("//*[@file='" item.file "']/@tv").text)
		Sleep,200
		item.text:=item.type="class"?"class " item.text:item.text
		(item.type="bookmark")?(sc:=csc(),line:=sc.2166(item.pos),sc.2160(sc.2128(line),sc.2136(line)),hwnd({rem:20}),CenterSel()):(csc().2160(item.pos,item.pos+StrPut(item.text,"Utf-8")-1),v.sc.2169,getpos(),v.sc.2400)
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