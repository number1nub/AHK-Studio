FileCheck(file){
	static dates:={commands:{date:20150902000000,loc:"lib\commands.xml",url:"http://files.maestrith.com/AHK-Studio/commands.xml",type:1},menus:{date:20151019224924,loc:"lib\menus.xml",url:"http://files.maestrith.com/AHK-Studio/menus.xml",type:2},scilexer:{date:20150606000000,loc:"SciLexer.dll",url:"http://files.maestrith.com/AHK-Studio/SciLexer.dll",type:1},icon:{date:20150914131604,loc:"AHKStudio.ico",url:"http://files.maestrith.com/AHK-Studio/AHKStudio.ico",type:3},Studio:{date:20151018140543,loc:A_MyDocuments "\Autohotkey\Lib\Studio.ahk",url:"https://raw.githubusercontent.com/maestrith/AHK-Studio-Plugins/master/Lib/Studio.ahk",type:1}}
	if(!FileExist(A_MyDocuments "\Autohotkey")){
		FileCreateDir,% A_MyDocuments "\Autohotkey"
		FileCreateDir,% A_MyDocuments "\Autohotkey\Lib"
	}
	if(file){
		if(file){
			if(!settings.ssn("//open/file[text()='" file "']"))
				settings.add("open/file",{select:1},file,1)
		}
		if(x:=ComObjActive("ahk-studio")){
			x.open(file),x.scanfiles(),x.Show()
			ExitApp
		}
	}if(A_PtrSize=8&&A_IsCompiled=""){
		SplitPath,A_AhkPath,,dir
		if(!FileExist(correct:=dir "\AutoHotkeyU32.exe")){
			m("Requires AutoHotkey 1.1 to run")
			ExitApp
		}
		Run,"%correct%" "%A_ScriptName%",%A_ScriptDir%
		ExitApp
		return
	}
	ComObjError(0)
	for a,b in dates{
		FileGetTime,time,% b.loc,M
		loc:=b.loc
		SplitPath,loc,,locdir
		if(FileExist(locdir)=""&&InStr(locdir,".")!=0){
			m("make it!",locdir,loc,"hmm",InStr(localdir,"."))
			FileCreateDir,%locdir%
		}
		if(b.type=2){
			if(menus.ssn("//date").text!=b.date){
				SplashTextOn,300,100,Downloading Menus XML,Please Wait...
				temp:=new xml("temp"),temp.xml.loadxml(URLDownloadToVar(b.url))
				if(menus.sn("//*").length=1)
					menus.xml.loadxml(temp[])
				else{
					menu:=temp.sn("//*")
					while,mm:=menu.item[A_Index-1]{
						ea:=xml.ea(mm)
						if !ea.clean
							Continue
						if(!menus.ssn("//*[@clean='" ea.clean "']")){
							pea:=xml.ea(mm.ParentNode)
							if(!parent:=menus.ssn("//*[@clean='" ssn(mm.ParentNode,"@clean").text "']"))
								parent:=menus.add("menus/main/menu",pea,"",1)
							next:=0,new:=menus.under(parent,"menu",ea),order:=[],list:=sn(parent,"*"),nn:=xml.ea(new)
							while,ll:=list.Item[A_Index-1],ea:=xml.ea(ll)
								order[ea.clean]:=ll
							for a,b in order{
								if(next){
									parent.insertbefore(new,b)
									break
								}
								if(a=nn.clean)
									next:=1
					}}}options:=temp.sn("//*[@option='1']")
					while,oo:=options.item[A_Index-1],ea:=xml.ea(oo)
						menus.ssn("//*[@clean='" ea.clean "']").SetAttribute("option",1)
				}menus.add("date",,b.date),menus.save(1)
		}}else if(time!=b.date){
			if(b.type=1){
				SplashTextOn,200,100,% "Downloading " b.loc,Please Wait....
				UrlDownloadToFile,% b.url,% b.loc
				FileSetTime,% b.date,% b.loc,M
			}else if(b.type=3&&FileExist(b.loc)=""){
				SplashTextOn,200,100,% "Downloading " b.loc,Please Wait....
				UrlDownloadToFile,% b.url,% b.loc
				FileSetTime,% b.date,% b.loc,M
			}
		}
		SplashTextOff
	}
	if(!settings.ssn("//fonts"))
		DefaultFont()
	RegRead,value,HKCU,Software\Classes\AHK-Studio
	if(!value)
		RegisterID("{DBD5A90A-A85C-11E4-B0C7-43449580656B}","AHK-Studio")
	if(!settings.ssn("//autoadd")){
		top:=settings.add("autoadd")
		for a,b in {"{":"}","[":"]","<":">","'":"'","(":")",Chr(34):Chr(34)}
			settings.under(top,"key",{trigger:a,add:b})
		settings.add("Auto_Indent",{Full_Auto:1}),settings.add("options",{Auto_Advance:1})
	}
	return
}