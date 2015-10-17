class toolbar{
	static keep:=[],order:=[],list:=[],imagelist:="",toolbar1,toolbar2,toolbar3,fun
	__New(win,parent,id,mask=""){
		static count:=0
		static
		count++
		mask:=mask?mask:0x100|0x0040|0x10|0x0008|0x800|0x0004|0x20
		Gui,%win%:Default
		Gui,%win%:Add,Custom,ClassToolbarWindow32 hwndhwnd +%mask% gtoolbar vtoolbar%count%
		this.iconlist:=[],this.hwnd:=hwnd,this.count:=count,this.buttons:=[],this.returnbutton:=[],this.keep[hwnd]:=this,this.ahkid:="ahk_id" hwnd,this.parent:=parent,this.order[count]:=this,this.imagelist:=IL_Create(20,1,settings.ssn("//options/@Small_Icons").text?0:1),this.SetImageList(),this.list[id]:=this,this.id:=id,this.setmaxtextrows()
		return this
	}
	setstate(button,state){
		SendMessage,0x400+17,button,0<<16|state&0xffff,,% this.ahkid
	}
	SetImageList(){
		SendMessage,0x400+48,0,% this.imagelist,,% "ahk_id " this.hwnd
	}
	il(icon="",file=""){
		if(icon!=""){
			if(this.iconlist[file,icon]!="")
				return this.iconlist[file,icon]
			if file contains .gif,.jpg,.png,.bmp
				index:=IL_Add(this.imagelist,file)-1
			else
				index:=IL_Add(this.imagelist,file,icon+1)-1
			this.iconlist[file,icon+1]:=index
			return index
		}
	}
	add(info){
		new:=[]
		if(info.text){
			VarSetCapacity(STR,StrLen(info.text)*2)
			StrPut(info.text,&STR,strlen(info.text)*2)
			SendMessage,0x400+77,0,&STR,,% "ahk_id " this.Hwnd
			Index:=ErrorLevel
		}
		iimage:=this.il(info.icon,info.file),this.buttons[info.id]:={icon:iimage,state:info.state,text:info.text,index:index,func:info.func,iimage:info.icon,file:info.file,id:info.id,runfile:info.runfile},this.returnbutton.Insert(this.buttons[info.id])
	}
	addbutton(id){
		VarSetCapacity(button,20,0)
		info:=this.buttons[id]
		if(!info.id){
			NumPut(1,button,9)
			SendMessage,1044,1,&button,,% "ahk_id" this.hwnd
			return
		}
		if(IsFunc(info.func)=0&&IsLabel(info.func)=0&&FileExist(menus.ssn("//*[@clean='" info.func "']/@plugin").text)="")
			return
		NumPut(info.icon,Button,0,"int"),NumPut(info.id,Button,4,"int"),NumPut(info.state,button,8,"char"),NumPut(info.style,button,9,"char"),NumPut(info.Index,button,8+(A_PtrSize*2),"ptr")
		SendMessage,1044,1,&button,,% "ahk_id" this.hwnd ;TB_ADDBUTTONSW
	}
	SetMaxTextRows(MaxRows=0){
		SendMessage,0x043C,MaxRows, 0,, % "ahk_id " this.Hwnd
		return (ErrorLevel="FAIL")?False:True
	}
	Customize(){
		SendMessage,0x041B, 0, 0,, % "ahk_id " this.Hwnd
		return (ErrorLevel="FAIL")?False:True
	}
	barinfo(){
		VarSetCapacity(size,8),VarSetCapacity(rect,16)
		WinGetPos,,,w,,% "ahk_id" this.hwnd
		SendMessage,0x400+29,0,&rect,,% "ahk_id" this.hwnd
		height:=NumGet(rect,12)
		SendMessage,0x400+99,0,&size,,% "ahk_id" this.hwnd ;TB_GETIDEALSIZE
		ideal:=NumGet(&size)
		return info:={ideal:ideal,id:this.id,height:height,hwnd:this.hwnd,width:ideal+20}
	}
	ideal(){
		VarSetCapacity(size,8)
		SendMessage,0x400+99,0,&size,,% "ahk_id" this.hwnd ;TB_GETIDEALSIZE
		parent:=DllCall("GetParent","uptr",this.hwnd),parent:="ahk_id" parent
		NumPut(VarSetCapacity(band,80),&band,0),NumPut(0x200|0x40,band,4)
		SendMessage,0x400+16,% this.id,0,,% parent
		bandnum:=ErrorLevel
		SendMessage,0x400+28,%bandnum%,&band,,% parent ;getbandinfo
		NumPut(0x200|0x40,band,4),NumPut(NumGet(&size),&band,68),NumPut(NumGet(&size)+20,&band,44)
		SendMessage,0x400+11,%bandnum%,&band,,% parent ;setbandinfow
	}
	delete(button){
		rem:=settings.ssn("//toolbar/bar[@id='" this.id "']/button[@id='" button.id "']"),rem.ParentNode.RemoveChild(rem)
		SendMessage,0x400+25,% button.id,0,,% this.ahkid
		SendMessage,0x400+22,%ErrorLevel%,0,,% this.ahkid
		this.buttons[button.id]:=""
	}
	notification(){
		toolbar:
		code:=NumGet(A_EventInfo+8,0,"Int"),Hwnd:=NumGet(A_EventInfo),this:=toolbar.keep[hwnd]
		if(code=-12)
			return 1
		if(Hwnd!=this.Hwnd)
			return 0
		if(code=-713){
			Sleep,5
			return 1
		}
		if code not in -5,-708,-720,-723,-706,-707,-20
		{
			Sleep,10
			return 0
		}
		if(code=-5){ ;right click
			if(GetKeyState("Ctrl","P")&&this.id!=10002)
				this.delete(this.buttons[NumGet(A_EventInfo+12)])
			else
				this.customize()
		}
		if(code=-20){ ;left click
			button:=this.buttons[NumGet(A_EventInfo+12)]
			if(GetKeyState("Alt","P")&&GetKeyState("Ctrl","P")){
				removeid:=this.id
				if(removeid=10000||removeid=10001)
					return m("Can not remove original toolbars only ones you create")
				if(removeid=10002)
					return m("Can not delete the Debug Toolbar")
				if(removeid=11000)
					return m("Quick Find must stay")
				MsgBox,308,Remove This Toolbar,This Can NOT be undone.  Are you sure?
				IfMsgBox,Yes
				{
					rebar.hw.1.hide(removeid)
					for a,b in [settings.ssn("//rebar/band[@id='" removeid "']"),settings.ssn("//toolbar/bar[@id='" removeid "']")]
						if(b.xml)
							b.ParentNode.RemoveChild(b)
				}
				return
			}
			if(GetKeyState("Ctrl","P")&&button)
				new icon_browser(NumGet(A_EventInfo+12),this.id,button.file,button.iimage)
			else if(!button.runfile){
				func:=button.func
				if(IsFunc(func))
					%func%()
				else if(IsLabel(func))
					SetTimer,%func%,-10
				else if(FileExist((plugin:=menus.ssn("//*[@clean='" func "']/@plugin").text))){
					info:=menus.ea("//*[@clean='" func "']")
					Run,% Chr(34) info.plugin Chr(34) " " Chr(34) info.option Chr(34)
				}
				return 1
			}
			else if(button.runfile)
				return runfile(button.runfile)
			return 0
		} 
		if(code=-708) ;toolbar change
			this.ideal()
		if(code=-720){
			if(info:=this.returnbutton[NumGet(A_EventInfo+12)+1]){
				for a,b in [[info.icon,0,"int"],[info.id,4,"int"],[info.state,8,"char"],[info.style,9,"char"],[info.index,16,"int"]]
					NumPut(b.1,A_EventInfo+16,b.2,b.3)
				PostMessage,1,,,,% "ahk_id" this.parent
			}
		}
		if(code=-723) ;TBN_INITCUSTOMIZE
			PostMessage,1,,,,% "ahk_id" this.parent
		if(code=-706) ;TBN_QUERYINSERT
			PostMessage,1,,,,% "ahk_id" this.parent
		if(code=-707) ;TBN_QUERYDELETE
			PostMessage,1,,,,% "ahk_id" this.parent
		return 1
	}
	save(){
		VarSetCapacity(button)
		vis:=settings.sn("//toolbar/*/*/@vis")
		while,vv:=vis.item[A_Index-1]
			vv.text:=0
		sep:=settings.sn("//toolbar/*/separator")
		while,vv:=sep.item[A_Index-1]
			vv.parentnode.removechild(vv)
		for Control,this in this.order{
			top:=settings.ssn("//toolbar")
			SendMessage,0x400+24,0,0,,% this.ahkid ;TB_BUTTONCOUNT
			Loop,%ErrorLevel%{
				VarSetCapacity(button,80)
				SendMessage,0x400+23,% A_Index-1,&button,,% this.ahkid ;TB_GETBUTTON
				if(NumGet(&button,4)=0){
					bar:=ssn(top,"bar[@id='" this.id "']"),new:=settings.under(bar,"separator",{vis:1},1)
					continue
				}
				id:=NumGet(&button,4),next:=ssn(top,"bar[@id='" this.id "']/button[@id='" id "']"),next.setattribute("vis",1),next.parentnode.appendchild(next)
			}
		}
	}
}