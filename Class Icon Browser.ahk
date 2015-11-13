Class Icon_Browser{
	static start:="",window:=[],keep:=[],newwin,caller
	__New(id,barid,desc:="",ofile:="Shell32.dll",oicon:=0,return:=0,ahwnd:=""){
		win:=85,this.barid:=toolbar.list[barid].ahkid,newwin:=new GUIKeep(win),newwin.Add("Text,,Editing icon for: " info.desc,"ListView,w500 h300 hwndlv gselect vselect AltSubmit Icon -Multi,Small,wh","Button,xm gloadfile,Load File (Icon/DLL/Image),y","Button,x+10 gloaddefault,Load Default Icons,y","Button,x+10 gibc,Cancel,y"),newwin.Show("Select Icon"),this.file:=(ic:=settings.ssn("//icons/@last").text)?ic:"shell32.dll",this.file:=InStr(this.file,".ahk")?A_AhkPath:this.file,this.win:=win,icon_browser.keep:=this,this.newwin:=newwin,this.listview:=newwin.ctrl.select,this.id:=id,this.tb:=toolbar.list[barid],this.ofile:=ofile,this.oicon:=oicon,this.return:=return,this.populate(),this.ahwnd:=ahwnd
		return
		85GuiEscape:
		85GuiClose:
		this:=icon_browser.keep,hwnd({rem:85})
		if(hh:=this.ahwnd)
			WinActivate,% "ahk_id" hh
		if(this.return)
			this.return.call(this.exitgui:=1)
		return
		ibc:
		this:=icon_browser.keep,this.number:=this.oicon,this.file:=this.ofile
		SetTimer,Select1,-1
		Sleep,300
		goto,85GuiEscape
		return
		loaddefault:
		this:=icon_browser.keep,this.file:="shell32.dll",this.start:=0,this.populate(),settings.add("icons",{"last":this.file})
		return
	}select(num:=""){
		select:
		if(A_GuiEvent!="I")
			return
		Gui,85:Default
		this:=icon_browser.keep,number:=LV_GetNext()
		if(!number)
			return
		Select1:
		number:=number?number:this.number,number:=num="image"?0:number
		if(this.return)
			return this.return.call(this.file,this.number:=number)
		NumPut(VarSetCapacity(button,32),button,0),NumPut(0x1|0x20,button,4),NumPut(this.id,button,8)
		num:=this.tb.iconlist[this.file,number]!=""?this.tb.iconlist[this.file,number]:IL_Add(this.tb.imagelist,this.file,number)-1,this.tb.iconlist[this.file,number]:=num,NumPut(num,button,12)
		SendMessage,0x400+64,% this.id,&button,,% this.tb.ahkid
		btn:=settings.ssn("//toolbar/bar[@id='" this.tb.id "']/button[@id='" this.id "']"),btn.setattribute("icon",number-1),btn.setattribute("file",this.file),number:=""
		if(this.close)
			hwnd({rem:85})
		if(this.focus)
			WinActivate,% this.focus
		return
	}load(filename:=""){
		loadfile:
		this:=icon_browser.keep
		if(!filename){
			FileSelectFile,filename,,,,*.exe;*.dll;*.png;*.jpg;*.gif;*.bmp;*.icl;*.ico
			if(ErrorLevel)
				return
		}
		this.file:=filename
		if filename contains .gif,.jpg,.png,.bmp
			return this.select("image")
		this.populate(),settings.add("icons",{"last":filename}),filename:=""
		return
	}exit(){
		for win in icon_browser.window
			Gui,%win%:Destroy
	}populate(){
		GuiControl,85:-Redraw,SysListView321
		il:=IL_Create(50,10,1),LV_SetImageList(il)
		while,icon:=IL_Add(il,this.file,A_Index)
			LV_Add("Icon" icon)
		SendMessage,0x1000+53,0,(47<<16)|(47&0xffff),,% "ahk_id" this.listview
		GuiControl,85:+Redraw,SysListView321
	}
}