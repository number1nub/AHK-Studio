tv(tv:=0,open:="",history:=0){
	static fn,noredraw
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	TV_Modify(tv,"Select Vis Focus")
	if(open=""&&history=0)
		return
	tv:
	if(A_GuiEvent="S"||open||history){
		SetTimer,matchfile,Off
		if(!v.startup)
			getpos(),count:=0
		ei:=open?tv:a_eventinfo,sc:=csc(),file:=files.ssn("//*[@tv='" ei "']"),fn:=ssn(file,"@file").text
		sc.Enable()
		if(file.nodename!="file")
			return
		if(!ssn(file,"@tv").text)
			return
		if(!doc:=ssn(file,"@sc")){
			tvtop:
			Sleep,10
			doc:=sc.2375
			if(!doc)
				doc:=sc.2376(0,doc)
			if(!(doc)){
				count++
				if(count=3)
					return
				goto,tvtop
			}
			sc.2358(0,doc),tt:=update({get:fn}),sc.2037(65001),txt:=Encode(tt),set(),sc.2181(0,&txt),sc.2175(),dup:=files.sn("//file[@file='" fn "']")
			while,dd:=dup.item[A_Index-1]
				dd.SetAttribute("sc",doc)
		}else
			sc.2358(0,doc.text),marginwidth(sc),current(1).SetAttribute("last",fn)
		GuiControl,1:+Redraw,% sc.sc
		Sleep,150
		setpos(ei),uppos(),marginwidth(sc)
		if(history!=1)
			History(fn)
		history:=0
		WinSetTitle,% hwnd([1]),,AHK Studio - %fn%
		sc.4004("fold",[1])
		Sleep,150
		SetTimer,matchfile,-100
		if(v.savelinestat[fn]){
			sc:=csc()
			Loop,% sc.2154
				if(sc.2533(A_Index-1)=30)
					sc.2532(A_Index-1,31)
		}v.savelinestat.delete(fn),sc.Enable(1),MarginWidth() ;#[TV Figure out how to wait until the code is up and ready]
	}
	return
	matchfile:
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	sc:=csc()
	doc:=sc.2357(),tv:=files.ssn("//*[@tv='" TV_GetSelection() "']"),ea:=xml.ea(tv)
	if(doc!=ea.sc){
		tv(TV_GetSelection(),1)
	}
	return
}