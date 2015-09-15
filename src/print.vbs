'On Error resume next
'If Err.Number <> 0 Then
'  WScript.Echo "Error in DoStep1: " & Err.Description
'  Err.Clear
'End If
Dim XL
Dim XLWkbk
Dim ObjArgs
set objargs = wscript.arguments
if objArgs.count <> 2 then
	wscript.echo "invalid passed arguments"
	wscript.quit
end if
filepath = objargs(0)
savefilepath = objargs(1)
''wscript.echo filepath
''wscript.echo savefilepath
Set fso = CreateObject ("Scripting.FileSystemObject")
Set stdout = fso.GetStandardStream (1)
Set stderr = fso.GetStandardStream (2)

if right(filepath,4)=".xls" or right(filepath,5)=".xlsx" then
	Set XL = CreateObject("excel.application")
	XL.Visible = False
	set XLWkbk = XL.Workbooks.Open(filepath)
	If Err.Number <> 0 Then
	  stdout.WriteLine "fail:error " & Err.Description
	  Err.Clear
	End If
	'' 44=html
	XLWkbk.SaveAs savefilepath ,44
	XLWkbk.Close False
	XL.Close
	stdout.WriteLine "success"
elseif right(filepath,4)=".doc" or right(filepath,5)=".docx" then
	Set XL = CreateObject("Word.application")
	XL.Visible = False
	set XLWkbk = XL.Documents.Open(filepath)
	If Err.Number <> 0 Then
	  stdout.WriteLine "fail:error " & Err.Description
	  Err.Clear
	End If
	'' 8=html 17=pdf 18=xps
	XLWkbk.SaveAs savefilepath ,8
	XLWkbk.Close False
	XL.Quit
	stdout.WriteLine "success"
elseif right(filepath,4)=".ppt" or right(filepath,5)=".pptx" then
	Set XL = CreateObject("Powerpoint.application")
	''XL.Visible = False
	set XLWkbk = XL.Presentations.Open(filepath)
	If Err.Number <> 0 Then
	  stdout.WriteLine "fail:error " & Err.Description
	  Err.Clear
	End If
	''16=gif 17=jpg 32=pdf 18=png xps=33
	XLWkbk.SaveAs savefilepath ,17
	XLWkbk.Close
	XL.Quit
	stdout.WriteLine "success"
end if
