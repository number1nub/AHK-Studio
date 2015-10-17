uppos(){
	sc:=csc()
	line:=sc.2166(sc.2008)
	if(v.track.line)
		if(v.track.line!=line||v.track.file!=current(2).file)
			v.track:=[]
	if(lastline!=line)
		hltline()
	lastline:=line
	if(Abs(sc.2008-sc.2009)>2)
		duplicates()
	Else if v.duplicateselect
		sc.2500(3),sc.2505(0,sc.2006),v.duplicateselect:="",v.selectedduplicates:=""
	if(sc.2353(sc.2008-1)>0)
		sc.2351(v.bracestart:=sc.2008-1,v.braceend:=sc.2353(sc.2008-1)),v.highlight:=1
	else if(sc.2353(sc.2008)>0)
		sc.2351(v.bracestart:=sc.2008,v.braceend:=sc.2353(sc.2008)),v.highlight:=1
	else if v.highlight
		v.bracestart:=v.braceend:="",sc.2351(-1,-1),v.highlight:=0
	text:="Line:" sc.2166(sc.2008)+1 " Column:" sc.2129(sc.2008) " Length:" sc.2006 " Position:" sc.2008,total:=0
	if(sc.2008!=sc.2009){
		text.=" Selected Count:" Abs(sc.2008-sc.2009)
		if(sc.2570>1){
			Loop,% sc.2570
				total+=Abs(sc.2579(A_Index-1)-sc.2577(A_Index-1))
			text.=" Total Selected:" total
	}}
	SetStatus(text,1)
}