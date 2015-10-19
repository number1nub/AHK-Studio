Class Code_Explorer{
	static explore:=[],TreeView:=[],sort:=[],function:="OUm`n)^\s*((\w|[^\x00-\x7F])+)\((.*)\)(\s+;.*)?\n?[\s*]?\{",label:="UOm`n)^\s*((\w|[^\x00-\x7F])+):[^\w][\s+;]",class:="Om`ni)^[\s*]?(class\s+(\w|[^\x00-\x7F])+)",Property:="Om`n)^\s*((\w|[^\x00-\x7F])+)\[(.*)?\][\s+;.*\s+]?[\s*]?{",functions:=[],variables:=[],varlist:=[]
	scan(node){
		static no:=new xml("no")
		ea:=xml.ea(node),text:="`n" update({get:ea.file}),pos:=1,parent:=ssn(node,"@file").text,next:=cexml.ssn("//file[@file='" parent "']"),fnme:=ea.file
		while,uu:=ssn(next,"*")
			uu.ParentNode.RemoveChild(uu)
		pos:=1,rem:=no.ssn("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.add("bad")
		while,RegExMatch(text,"OUm`r)\n\s*(\x2F\x2A.*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)
			no.under(notop,"bad",{min:found.pos(1)-3,max:found.pos(1)+found.len(1)-3,type:"comment"},,1)
		pos:=1
		while,RegExMatch(text,Code_Explorer.class,found,pos),pos:=found.Pos(1)+found.len(1)
			if(!no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "']"))
				cexml.under(next,"info",{type:"Class",opos:found.Pos(1)-1,pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:RegExReplace(found.1,"i)^(class|\s)"),upper:upper(RegExReplace(found.1,"i)(class\s+)"))})
		clist:=sn(next,"descendant::info[@type='Class']")
		while,cc:=clist.item[A_Index-1],ea:=xml.ea(cc){
			tt:=SubStr(text,ea.pos+1),total:="",braces:=0,start:=0
			for a,b in StrSplit(tt,"`n"){
				line:=Trim(RegExReplace(b,"(\s+" Chr(59) ".*)")),total.=b "`n"
				if(SubStr(line,0,1)="{")
					braces++,start:=1
				if(SubStr(line,1,1)="}"){
					while,((found1:=SubStr(line,A_Index,1))~="(}|\s)"){
						if(found1~="\s")
							Continue
						braces--
					}
				}if(start&&braces=0)
					break
			}
			total:=Trim(total,"`n"),cc.SetAttribute("end",np:=ea.pos+StrPut(total,"utf-8")-1)
			for a,b in {Property:Code_Explorer.property,Method:Code_Explorer.function}{
				pos:=1
				while,RegExMatch(total,b,found,pos),pos:=found.Pos(1)+found.len(1)
					if(no.ssn("//bad[@min<'" ea.pos+found.pos(1) "' and @max>'" ea.pos+found.pos(1) "']")=""&&found.1!="if")
						add:=a="property"?"[":"(",cexml.under(cc,"info",{type:a,pos:ea.pos+StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-2,text:found.1,upper:upper(found.1),args:found.value(3),class:ea.text})
			}
			no.Add("bad/bad",{min:ea.pos,max:np,type:"Class"},,1)
		}
		pos:=1
		while,RegExMatch(text,Code_Explorer.Function,found,pos),pos:=found.pos(1)+found.len(1){
			if(no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "']")=""&&found.1!="if"){
				cexml.under(next,"info",{args:found.3,type:"Function",text:found.1,upper:upper(found.1),pos:StrPut(SubStr(text,1,found.pos(1)))-3})
				/*
					if(RegExMatch(tq:=SubStr(text,found.Pos(0)+found.len(0)),"OU)^\s*(\;.*)\n",fq)){
						RegExMatch(SubStr(tq,fq.Pos(0)+fq.len(0)),"UO)^\s*(;.*)\n",fq2)
						v.listo.=fq.0 "`n-`n" fq2.0 "`n-----`n"
					}
				*/
			}
		}
		for type,find in {Hotkey:"Om`n)^\s*([#|!|^|\+|~|\$|&|<|>|*]*?\w+)::",Label:this.label}{
			pos:=1
			while,RegExMatch(text,find,fun,pos),pos:=fun.pos(1)+fun.len(1)
				if(!no.ssn("//bad[@min<'" fun.pos(1) "' and @max>'" fun.pos(1) "' and @type!='Class']"))
					cexml.under(next,"info",{type:type,pos:StrPut(SubStr(text,1,fun.Pos(1)),"utf-8")-3,text:fun.1,upper:upper(fun.1)})
		}pos:=1
		while,RegExMatch(text,"OUi).*(\w+)\s*:=\s*new\s*(\w+)\(",found,pos),pos:=found.Pos(2)+found.len(2){
			if(!no.ssn("//bad[@min<'" found.pos(1) "' and @max>'" found.pos(1) "' and @type!='Class']"))
				cexml.under(next,"info",{type:"Instance",upper:upper(found.1),pos:StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:found.1,class:found.2})
		}if(!v.options.Disable_Variable_List){
			pos:=1,main:=ssn(node,"ancestor::main")
			while,pos:=RegExMatch(text,"Osm`n)(\w+)\s*:=",var,pos),pos:=var.Pos(1)+var.len(1)
				if(!ssn(main,"descendant::*[@type='Variable'][@text='" var.1 "'] or descendant::*[@type='Instance'][@text='" var.1 "']"))
					cexml.under(next,"info",{type:"Variable",upper:upper(var.1),pos:StrPut(SubStr(text,1,var.Pos(1)),"utf-8")-3,text:var.1})
		}pos:=1
		while,pos:=RegExMatch(text,"OU);#\[(.*)\]",found,pos),pos:=found.Pos(1)+found.len(1)
			cexml.under(next,"info",{type:"Bookmark",upper:upper(found.1),pos:StrPut(SubStr(text,1,found.Pos(0)),"utf-8"),text:found.1})
	}
	remove(filename){
		this.explore.remove(ssn(filename,"@file").text),list:=sn(filename,"@file")
		while,ll:=list.item[A_Index-1]
			this.explore.Remove(ll.text)
	}
	populate(){
		code_explorer.Refresh_Code_Explorer()
		Gui,1:TreeView,SysTreeView321
	}
	Add(value,parent=0,options=""){
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		return this.Add(value,parent,options)
	}
	Refresh_Code_Explorer(){
		if(v.options.Hide_Code_Explorer)
			return
		Gui,1:Default
		Gui,1:TreeView,SysTreeView322
		GuiControl,1:-Redraw,SysTreeView322
		TV_Delete()
		code_explorer.scan(current()),cet:=code_explorer.treeview:=new xml("TreeView"),bookmark:=[]
		SplashTextOff
		GuiControl,1:-Redraw,SysTreeView322
		fz:=cexml.sn("//files/main")
		while,fn:=fz.Item[A_Index-1]{
			things:=sn(fn,"descendant::info"),filename:=ssn(fn,"@file").text
			if(things.length=0)
				Continue
			SplitPath,filename,file
			Gui,1:Default
			Gui,1:TreeView,SysTreeView322
			main:=TV_Add(file,0,"Sort")
			while,tt:=things.Item[A_Index-1],ea:=xml.ea(tt){
				if(ea.type="variable")
					continue
				fin:=ssn(tt,"ancestor::file/@file").text
				if(!top:=cet.ssn("//main[@file='" filename "'][@type='" ea.type "']"))
					if(!(ea.type~="(Method|Property)"))
						top:=cet.Add("main",{file:filename,type:ea.type,tv:TV_Add(ea.type,main,"Vis Sort")},"",1)
				if(ea.type~="(Method|Property)")
					cet.under(last,"info",{text:ea.text,pos:ea.pos,file:fin,tv:TV_Add(ea.text,ssn(last,"@tv").text,"Sort")})
				else
					last:=cet.under(top,"info",{text:ea.text,pos:ea.pos,file:fin,type:ea.type,tv:TV_Add(ea.text,ssn(top,"@tv").text,"Sort")})
			}
		}
		GuiControl,1:+Redraw,SysTreeView322
		return
	}
	cej(){
		static last
		cej:
		if((A_GuiEvent="S"||A_EventInfo=last)&&A_GuiEvent!="RightClick"){
			list:="",last:=A_EventInfo
			if(found:=code_explorer.TreeView.ssn("//*[@tv='" A_EventInfo "']")){
				ea:=xml.ea(found)
				if(ea.pos="")
					return
				parent:=ssn(found,"ancestor::main/@file").text,
				TV(files.ssn("//main[@file='" parent "']/descendant::file[@file='" ea.file "']/@tv").text)
				Sleep,200
				if(ea.type="bookmark"){
					sc:=csc(),line:=sc.2166(ea.pos),sc.2160(sc.2128(line),sc.2136(line)),CenterSel()
					ControlFocus,,% "ahk_id" csc().sc
				}
				else
					csc().2160(ea.pos,ea.pos+StrPut(ea.text,"Utf-8")-1+_:=ea.type="class"?+6:+0) ;,v.sc.2169,v.sc.2400
				ControlFocus,SysTreeView322,% hwnd([1])
			}
			return
		}
		return
	}
}