t(x*){
	for a,b in x
		list.=b "`n"
	Tooltip,% list
}
m(x*){
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}}
	list.title:="AHK Studio",list.def:=0,list.time:=0,value:=0
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	MsgBox,% (value+262144+(list.def?(list.def-1)*256:0)),% list.title,%txt%,% list.time
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
			return b
}