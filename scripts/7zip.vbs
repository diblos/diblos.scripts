'************************************************
' File:    Zip.vbs (VBScript)
' Autore:  Giovanni Cenati
' http://digilander.libero.it/Cenati
' CreateEmptyZip (nome dello zip da creare)
' (Crea un nuovo file zip vuoto o sovrascrive quello esistente)
'
' AddFile2Zip (Nome archivio zip, File da aggiungere)
' (Aggiunge un singolo file ad uno zip esistente)
'
' AddFolder2Zip (Nome archivio zip, Cartella da aggiungere all'archivio)
' (Aggiunge ad uno zip esistente il contenuto di una cartella)
'
' Creates a zip archive and adds one or more files.
' Uses Win XP native support for zip archives as folders.
'************************************************
ScriptFullName = wscript.scriptfullname
CurrentPath = Left(scriptfullname, InStrRev(ScriptFullName, "\"))

ZipFile = CurrentPath & "test " & getFormattedDate & ".zip"
'FileDaAggiungere = wscript.scriptfullname
FileDaAggiungere = "D:\fromSDE_VmmHfm\VmmHfm.txt"
'FolderDaZippare = CurrentPath & "temp\"
FolderDaZippare = "D:\fromSDE_VmmHfm"

'Crea un file zip vuoto.
a = CreateEmptyZip(ZipFile)
'msgbox a 'Deve essere True.

'Aggiunge un file all'archivio zip appena creato.
a = AddFile2Zip (ZipFile, FileDaAggiungere)
'msgbox a

'Aggiunge il contenuto di un folder all'archivio zip.
'a= AddFolder2Zip (ZipFile, FolderDaZippare)
'msgbox a

'Attende che la copia sia finita
set fso=createobject("scripting.filesystemobject")
Set h=fso.getFile(ZipFile)
do
wscript.sleep 300
loop while h.size=< 22

'Ora posso chiudere lo script senza
'interrompere la compressione.
wscript.quit

Function AddFile2Zip (sZipFile, sFile2Add)
'Aggiunge un file all'archivio zip esistente.
'Attenzione: di default il metodo CopyFile sovrascrive.
'NameSpace vuole un pathname completo e non solo il nome file.
On Error Resume Next
AddFile2Zip = True
Set oApp = createobject("Shell.Application")
oApp.NameSpace(sZipFile).CopyHere sFile2Add
If Err<>0 Then AddFile2Zip=False
End Function

Function CreateEmptyZip(sPathName)
'Create empty Zip File.
'Crea un file zip vuoto.
Dim fso, fp
Const ForWriting  = 2 'Apre un file in scrittura.
CreateEmptyZip = True 'se tutto va bene resta true.
On Error Resume Next
Set fso = CreateObject("Scripting.FileSystemObject")
Set fp = fso.OpenTextFile( sPathName, ForWriting, True )
If Err <> 0 Then
Set opfs = Nothing
CreateEmptyZip=False
Exit Function 'Errore nella creazione
end if
fp.Write Chr(80) & Chr(75) & Chr(5) & Chr(6) & String(18, 0)
If Err <> 0 Then
Set opfs = Nothing
CreateEmptyZip=False
Exit Function 'errore nella scrittura
End If
fp.Close 'Chiude il file, altrimenti non si pu• usare.
Set fso = Nothing
Err.Clear
End Function

Function AddFolder2Zip (ZipFile, Folder)
'Copia il contenuto di una cartella in un file zip.
'Il folder deve essere indicato con pathname completo
'e terminare con un "\"
'Zipfile deve essere indicato con pathname completo.
AddFolder2Zip=True
Set oApp = CreateObject("Shell.Application")
'Copia il contenuto della cartella nello zip.
Set oFolder = oApp.NameSpace(Folder)
If Not oFolder Is Nothing Then
oApp.NameSpace(ZipFile).CopyHere oFolder.Items
End If

End Function

'================ Sebastian's Code [START]
Function fixNum (x)
    If Len(x) = 1 Then
        x = "0" & x
    End If
    fixNum = x
End Function

Function getFormattedDate
    getFormattedDate = Year(Date) & fixNum (Month(Date)) & fixNum (Day(Date))
End Function
'================ Sebastian's Code [END]