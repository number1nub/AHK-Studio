Class FTP{
	__New(name){
		ea:=settings.ea("//ftp/server[@name='" name "']"),this.error:=0
		if(!(ea.username!=""&&ea.password!=""&&ea.address!=""))
			return m("Please setup your ftp information")
		SplashTextOn,200,100,Logging In,Please Wait...
		port:=ea.port?ea.port:21,this.library:=DllCall("LoadLibrary","str","wininet.dll","Ptr"),this.Internet:=DllCall("wininet\InternetOpen","str",A_ScriptName,"UInt",AccessType,"str",Proxy,"str",ProxyBypass,"UInt",0,"Ptr")
		if(!this.internet)
			this.cleanup(A_LastError)
		this.connect:=DllCall("wininet\InternetConnect","PTR",this.internet,"str",ea.address,"uint",Port,"str",ea.Username,"str",ea.Password,"uint",1,"uint",flags,"uint",0,"Ptr")
		if(!this.connect){
			this.cleanup(A_LastError)
			SplashTextOff
		}VarSetCapacity(ret,40)
	}
	CreateFile(name){
		list:=[]
		SplitPath,name,filename,dir,,namenoext
		IfNotExist,temp
			FileCreateDir,temp
		FileDelete,% "temp\" filename
		file:=FileOpen("temp\" filename,2),file.write(publish(1)),file.seek(0),List[filename]:=file
		FileDelete,% "temp\" namenoext ".text"
		file:=FileOpen("temp\" namenoext ".text",2),upinfo:="",info:=vversion.sn("//info[@file='" name "']/versions/version")
		while,in:=info.item[A_Index-1]
			upinfo.=ssn(in,"@number").text "`r`n" in.text "`r`n"
		upinfo:=text(upinfo),file.write(upinfo),file.seek(0),List[namenoext ".text"]:=file
		return list
	}
	Put(file,dir,compile,existing:=""){
		SplashTextOff
		updir:="/" Trim(RegExReplace(dir,"\\","/"),"/"),this.cd("/" Trim(RegExReplace(dir,"\\","/"),"/"))
		if(!(this.internet!=0&&this.connection!=0))
			return 0
		SplitPath,file,name,dir,,namenoext
		if(existing)
			list:=[],list[name]:=FileOpen(file,"rw")
		else
			list:=this.createfile(file)
		BufferSize:=4096
		if(compile)
			compile(),list[namenoext ".exe"]:=FileOpen(dir "\" namenoext ".exe","r")
		info:=sn(node,"versions/version")
		while,in:=info.item[A_Index-1]
			upver.=in.text "`r`n"
		for a,b in list{
			if(upver){
				ff:=!InStr(a,".exe")?A_ScriptDir "\temp\" a:dir "\" namenoext ".exe"
				SplitPath,a,fname
				SplashTextOn,300,50,Uploading file %a%,Please Wait...
				ii:=DllCall("wininet\FtpPutFile",UPtr,this.connect,UPtr,&ff,UPtr,&fname,UInt,2,UInt,0,"cdecl")
				SplashTextOff
			}else{
				this.file:=DllCall("wininet\FtpOpenFile",UPtr,this.connect,UPtr,&a,UInt,0x40000000,UInt,0x2,UPtr,0,"cdecl")
				Progress,0,uploading,%a%,Uploading,Tahoma
				if(!this.file)
					this.cleanup(A_LastError)
				length:=b.length,totalsize:=0,size:=1,b.seek(0)
				while,size{
					size:=b.rawread(buffer,BufferSize),totalsize+=size
					Progress,% (totalsize*100)/length
					DllCall("wininet\InternetWriteFile","PTR",this.File,"PTR",&Buffer,"UInt",size,"UIntP",out,"cdecl")
					Sleep,30
				}close:=DllCall("wininet\InternetCloseHandle","UInt",this.file)
				Sleep,100
				b.close()
			}
		}
		t(),list:=""
		Progress,Off
	}
	__Delete(){
		this.cleanup
	}
	Cleanup(error*){
		if(error.1)
			m(error.1)
		SplashTextOff
		if(error.1){
			SplashTextOff
			this.error:=1,m(this.GetLastError(error.1))
		}
		for a,b in [this.file,this.connect,this.internet]
			DllCall("wininet\InternetCloseHandle","UInt",this.internet)
		DllCall("FreeLibrary","UInt",this.library)
		return 0
	}
	CD(dir){
		if(!DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl"))
			Loop,Parse,dir,/
				this.CreateDir(A_LoopField),this.SetDir(A_LoopField)
	}
	SetDir(dir){
		DllCall("wininet\FtpSetCurrentDirectory",UInt,this.connect,UPtr,&dir,"cdecl")
	}
	CreateDir(dir){
		DllCall("wininet\FtpCreateDirectory",UPtr,this.connect,UPtr,&dir,"cdecl")
	}
	GetDir(){
		cap:=VarSetCapacity(dir,128),DllCall("wininet\FtpGetCurrentDirectory",UInt,this.connect,UInt,&dir,UInt,&cap,"cdecl")
		return Trim(StrGet(&dir,128,"cp0"),"/")
	}
	GetLastError(error){ ;http://msdn.microsoft.com/en-us/library/ms679351
		size:=VarSetCapacity(buffer,1024)
		if(error = 12003){
			VarSetCapacity(ErrorMsg,4),DllCall("wininet\InternetGetLastResponseInfo","UIntP",&ErrorMsg,"PTR",&buffer,"UIntP",&size)
			return StrGet(&buffer,size)
		}
		DllCall("FormatMessage","UInt",0x00000800,"PTR",this.library,"UInt",error,"UInt",0,"Str",buffer,"UInt",size,"PTR",0)
		return buffer
	}
}
Text(text){
	return RegExReplace(text,"\x7f","`r`n")
}