Export(){
	indir:=settings.ssn("//export/file[@file='" ssn(current(1),"@file").text "']"),warn:=settings.ssn("//options/@Warn_Overwrite_On_Export").text?"S16":""
	FileSelectFile,filename,%warn%,% indir.text,Export Compiled AHK,*.ahk
	SplitPath,filename,,outdir
	filename:=InStr(filename,".ahk")?filename:filename ".ahk"
	FileDelete,%filename%
	file:=FileOpen(filename,"rw","utf-8"),file.seek(0),file.write(publish(1)),file.length(file.length)
	if(!indir)
		indir:=settings.Add("export/file",{file:ssn(current(1),"@file").text},,1)
	if(outdir)
		indir.text:=filename
}