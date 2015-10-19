Class GuiKeep{
	static keep:=[]
	__New(win,info*){
		this.osver:=SubStr(A_OSVersion,1,3),OnMessage(5,"Resize"),this.win:=win,setup(win),this.con:=[],this.ctrl:=[],this.resize:=0
		border:=StrSplit(A_OSVersion,".").1=10?0:DllCall("GetSystemMetrics",int,32)
		for a,b in {border:border,caption:DllCall("GetSystemMetrics",int,4)}
			this[a]:=b
		if(settings.ssn("//options/@Add_Margins_To_Windows").text!=1)
			Gui,Margin,0,0
		if(info.1)
			this.add(info*)
	}
	add(info*){
		win:=this.win,this.ahkid:=hwnd([this.win]),this.hwnd:=hwnd(this.win)
		for a,b in info{
			opt:=StrSplit(b,","),RegExMatch(opt.2,"iO)\bv(\w+)",found)
			if(found.1)
				this.var[found.1]:=1
			if(opt.1="s")
				split:=StrSplit(opt.3,"-"),hwnd:=new s(win,{pos:opt.2,label:split.1}),this.sc:=hwnd,var:=split.2,%var%:=hwnd,hwnd:=hwnd.sc
			else
				hwnd:=this.addctrl(opt)
			if(found.1)
				this.ctrl[found.1]:=hwnd
			if(opt.4){
				ControlGetPos,x,y,w,h,,ahk_id%hwnd%
				for a,b in {x:x,y:y,w:w,h:h}
					this.con[hwnd,a]:=b-(a="x"?(this.osver="10."?3:this.border*2):a="y"?(this.caption-(this.osver="10."?-3:this.Border)):a="h"?this.border:0)
				this.con[hwnd,"pos"]:=opt.4,this.Resize:=1
			}
		}
		if(this.resize)
			Gui,%win%:+Resize
		this.resize:=0
	}
	addctrl(opt:=""){
		static
		if(!opt){
			var:=[]
			Gui,% this.win ":Submit",Nohide
			for a,b in this.var
				var[a]:=%a%
			return var
		}
		Gui,% this.win ":Add",% opt.1,% opt.2 " hwndhwnd",% opt.3
		return hwnd
	}
	save(win){
		if(win)
			SaveGUI(win)
	}
	show(name:="",nopos:=0){
		Gui,% this.win ":Show",Hide AutoSize
		Gui,% this.win ":+MinSize"
		pos:=winpos(this.win),w:=pos.w,h:=pos.h,flip:={x:"w",y:"h"},GuiKeep.keep[this.win]:=this
		for control,b in this.con{
			obj:=this.gui[control]:=[]
			for c,d in StrSplit(b.pos)
				(d~="w|h")?(obj[d]:=b[d]-%d%):(d~="x|y")?(val:=flip[d],obj[d]:=b[d]-%val%)
		}
		pos:=settings.ssn("//gui/position[@window='" this.win "']").text,pos:=pos?pos:center(this.win),showpos:=nopos?"AutoSize":pos
		Gui,% this.win ":Show",%showpos%,%name%
		if(!this.Resize)
			Gui,% this.win ":Show",AutoSize
		v.activate:=this.win
		SetTimer,activate,-200
		return
		activate:
		WinActivate,% hwnd([v.activate])
		return
	}
	__Get(){
		return this.addctrl()
	}
	Destroy(){
		hwnd({rem:this.win})
	}
	current(win){
		return GuiKeep.keep[win]
	}
}