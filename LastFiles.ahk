lastfiles(){
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if(file)
			settings.add("last/file",,file,1)
	}
}