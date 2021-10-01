#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Menu_v0.11B.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Gui for NSP Forwarder Tool for 12+ Firmwares
#AutoIt3Wrapper_Res_Description=Gui for NSP Forwarder Tool for 12+ Firmwares
#AutoIt3Wrapper_Res_Fileversion=0.11.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.11
#AutoIt3Wrapper_Res_CompanyName=EddCase
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         EddCase & Shadow256
 Script Version: 0.11Beta

 Script Function:
	GUI for mpham's NSP Forwarder tool for 12+
	based on the work of
	The-4n's hacBrewPack

	mpham's thread on GBATemp https://gbatemp.net/threads/nsp-forwarder-tool-for-12.587936/
	EddCase's thread on GBATemp https://gbatemp.net/threads/gui-for-nsp-forwarder-tool-for-12.588018/
	The-4n's hacBrewPack on GitHub https://github.com/The-4n/hacBrewPack

Changelog

	0.1
		First Release
	0.2
		Fixed Random Key generation
		Added error checks for Name, Author and Icon Path have been entered
	0.3
		Switched from creating a batch file and running it to running the commands directly
		Fixed missing prod.key custom path options
	0.4
		Cleaning up after creating the forwarder,
			Restores NintendoLogo.png to default,
			Create new blank versions of nextArgv and nextNroPath
			Delete nacbrewpack_backup Directory
			Delete icon_AmericanEnglish.dat
			Delete TempIcon and TempLogo
	0.5
		Added Image conversion to the correct format and resolution
		Tidy up menu allignment
	0.6
		Added error checks on Path Lengths above 256 Characters long to Icon, Logo and Prod.key browse dialogs
		Added error check that Icon and Logo images are converted correctly
		Added option to open Icon and Logo in MSPaint as a sanity check also adds the suggestion to save out as a png, MSPaint Seems to be less fussy over filee types than the fuctions built into AutoIt
		Added changelog & known issues to Script

	0.6_Diagnose
		Copy TempIcon, TempLogo, icon_AmericanEnglish.dat, NintendoLogo and creates a txt file with the command string passed to hactool in out.txt
	0.7
		Diabled Diagnose Routine in standard, see notes in script to enable
		Error in TitleID generation (hopefully fixed) TitleID will now start 02-09 then random and end 2000, this should fix NSP generation Thank you GBATemp Member @duckbill007 for pointing out my error
	0.8 Beta
		Reorganize GUI to be More usable with screen readers, tested with NVDA Changes provided by GBATemp User Shadow256 (Thank You)
		Removed Old Unused code
	0.9 Beta (Shadow256)
		Change some path treatements, should fix some bugs like the bug of custom prod.keys path not always working
		Path for files pointed by the forwarder doesn't require anymore the "/" at the beginning of them
		Rewrite text of some labels
		Other minor changes
	0.10 Beta (Shadow256)
		Prod.keys should work properly.
		Special characters should be displayed correctly
		Fix some other bugs
		0.11 Beta (Shadow256)
			Default logo file and his backup will not be deleted anymore at the end of the process, should prevent for some big problems

Known Issues
	0.6
		Fixed in 0.10; Adds " " around Title and Author names when using non english characters (Pokémon), needs investigation if this is an issue with the GUI or hacBrewPack, Also does this behavior effect standard or only RetroArch forwarders
	0.8
		Fixed in 0.10; Custom Prod.Keys Location not working 100% for now place your prod.keys in the same location as Menu.exe (root folder)

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <ComboConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <GDIPlus.au3>


;Global Declerations
$version = "0.11 Beta"
$Title = "NSP Forwarder Tool for 12+" & "                                -=Menu v" & $version & "=-"
$Credits = "Thank You To" & @LF & @LF & "The-4n for hacBrewPack" & @LF & "mpham for NSP Forwarder tool for 12+" & @LF & @LF & "This Gui would not be possible without their work"
$hacbrewpac = '"' & @ScriptDir & "\hacbrewpack.exe" & '"'
$titleid = "05000A0000000000" ;16 characters long
$titlename = "App Name"
$titlepub = "Author"
$nropath = "switch/application/application.nro"
$corepath = "retroarch/core/corename.nro"
$rompath = "retroarch/roms/rom path"
$prodkeys = @ScriptDir & "\prod.keys"
$icon = ""
$logo = @ScriptDir & "\control\NintendoLogo.png"
$key = ""
$error = ""
$even = ""


;Check for a backup of the Logo png create a backup if there isn't one
If FileExists (@ScriptDir & "\logo\NintendoLogo.bak") = 0 Then
	FileCopy (@ScriptDir & "\logo\NintendoLogo.png", @ScriptDir & "\logo\NintendoLogo.bak")
Else
	FileCopy (@ScriptDir & "\logo\NintendoLogo.bak", @ScriptDir & "\logo\NintendoLogo.png")
EndIf

;Create the Gui
#Region ### START Koda GUI section ### Form=
$frmMain = GUICreate($Title, 610, 438, -1, -1)
$grpMain = GUICtrlCreateGroup("Standard Options", 4, 12, 600, 256)
$lblTitleName = GUICtrlCreateLabel("Application Name", 16, 32, 111, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpTitleName = GUICtrlCreateInput("Application Name", 144, 32, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblAuthor = GUICtrlCreateLabel("Author Name:", 16, 65, 122, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpAuthor = GUICtrlCreateInput("Author Name", 144, 65, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$lblTitleID = GUICtrlCreateLabel("Title ID:", 16, 98, 46, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpTitleID = GUICtrlCreateInput("Title ID", 144, 98, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btnTitleID = GUICtrlCreateButton("Random", 521, 98, 75, 25)
$lblIcon = GUICtrlCreateLabel("Icon Path:", 16, 131, 59, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpIcon = GUICtrlCreateInput("Icon Path", 144, 131, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btnIcon = GUICtrlCreateButton("Browse", 521, 131, 75, 25)
$lblLogo = GUICtrlCreateLabel("Logo Path:", 16, 164, 65, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpLogo = GUICtrlCreateInput("Do not change for default", 145, 164, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetTip(-1, "160 x 40 PNG")
$btnLogo = GUICtrlCreateButton("Browse", 521, 164, 75, 25)
$chkProd = GUICtrlCreateCheckbox("Custom prod.key location", 240, 208, 153, 17)
GUICtrlSetTip(-1, "By default it will use prod.keys in the same directory as Menu.exe")
$lblProd = GUICtrlCreateLabel("Prod.keys path:", 16, 236, 65, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpProd = GUICtrlCreateInput(@ScriptDir & "\prod.keys", 144, 236, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$btnProd = GUICtrlCreateButton("Browse", 521, 236, 75, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$grpForwarder = GUICtrlCreateGroup("Forwarder Options", 4, 272, 600, 113)
$chkStandard = GUICtrlCreateCheckbox("Standard Nro Forwarder", 160, 288, 137, 17)
$chkRetroArch = GUICtrlCreateCheckbox("RetroArch Rom Forwarder", 336, 288, 145, 17)
$lblNroPath = GUICtrlCreateLabel("Nro Path: sdmc:/", 16, 320, 56, 20, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$inpNroPath = GUICtrlCreateInput("switch/application.nro", 144, 318, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$lblRomPath = GUICtrlCreateLabel("Rom Path: sdmc:/", 16, 355, 63, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpRomPath = GUICtrlCreateInput("roms/rom_name.ext", 144, 355, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$cmbCore = GUICtrlCreateCombo("Pick a Core", 416, 318, 177, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlSetState(-1, $GUI_HIDE)
$lblCorePath = GUICtrlCreateLabel("Core Path: sdmc:/", 15, 318, 63, 25, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$inpCorePath = GUICtrlCreateInput("retroarch/cores/core.nro", 144, 318, 369, 25)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$btnCreate = GUICtrlCreateButton("Create Forwarder", 4, 390, 600, 40)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Create a random title ID
Call ("idrandom")

;Disable & Hide Menu Components
                GUICtrlSetState($lblProd, $GUI_DISABLE)
				GUICtrlSetState($inpProd, $GUI_DISABLE)
				GUICtrlSetState($btnProd, $GUI_DISABLE)
				GUICtrlSetState($lblNroPath, $GUI_SHOW)
				GUICtrlSetState($inpNroPath, $GUI_SHOW)
				GUICtrlSetState($inpCorePath, $GUI_HIDE)
				GUICtrlSetState($lblCorePath, $GUI_HIDE)
				GUICtrlSetState($lblRomPath, $GUI_HIDE)
				GUICtrlSetState($inpRomPath, $GUI_HIDE)
				GUICtrlSetState ($chkStandard, $GUI_CHECKED)
				GUICtrlSetState ($chkRetroArch, $GUI_UNCHECKED)



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $chkProd
			Call ("prodkeyscheck")
		Case $btnProd
			Call ("prodbrowse")
		Case $chkStandard
			Call ("standardcheck")
		Case $chkRetroArch
			Call ("retroarchcheck")
		Case $btnTitleID
			Call ("idrandom")
		Case $btnIcon
			Call ("iconbrowse")
		Case $btnLogo
			Call ("logobrowse")
		Case $btnCreate
			Call ("errorcheck")
			If $error = 0 Then
				Call ("imagemoves")
				Call ("pathwrites")
				;Remove the ; before the following line to enable the old GUI_Build.bat method of building the nsp also add ; to the the Call ("newbuild")
				;Call ("nspbuild")
				Call ("newbuild")
				;Remove the ; before the following to enable the diaganostic output
				;Call ("diagnose")
				Call ("tidy")
			Else
			EndIf
	EndSwitch
WEnd


Func idrandom()
;Switch Title ID Format 16 characters, official all start 01 and end Even Number 000 for Games and Odd Number 000 for DLC, and end 0800 for updates
;My Generated ones will now start between 02 and 09 and end 2000

		$key = ""
		$Key = $Key & Hex(Random() * 10)
		$titleid = "0" & Random (02, 09, 1)
		$titleid = $titleid & $key
		$titleid = StringTrimRight ( $titleid, 6 )
		$titleid = $titleid & "2000"
		GUICtrlSetData ($inpTitleID, $titleid)

EndFunc


Func prodkeyscheck()
;Enable menu changes when the prod.keys checkbox is clicked
		If GUICtrlRead($chkProd) = $GUI_CHECKED Then
			GUICtrlSetState($lblProd, $GUI_ENABLE)
			GUICtrlSetState($inpProd, $GUI_ENABLE)
			GUICtrlSetState($btnProd, $GUI_ENABLE)
			GUICtrlSetData ($inpProd, "prod.keys path")
		Else
			GUICtrlSetState($lblProd, $GUI_DISABLE)
			GUICtrlSetState($inpProd, $GUI_DISABLE)
			GUICtrlSetState($btnProd, $GUI_DISABLE)
			GUICtrlSetData ($inpProd, @ScriptDir & "\prod.keys")
			$prodkeys = @ScriptDir & "\prod.keys"
		EndIf
EndFunc

Func standardcheck()
;Enable menu changes when the standard forwarder checkbox is clicked
		If GUICtrlRead($chkStandard) = $GUI_CHECKED Then
			GUICtrlSetState($lblNroPath, $GUI_SHOW)
			GUICtrlSetState($inpNroPath, $GUI_SHOW)
			GUICtrlSetState($inpCorePath, $GUI_HIDE)
			GUICtrlSetState($lblCorePath, $GUI_HIDE)
			GUICtrlSetState($lblRomPath, $GUI_HIDE)
			GUICtrlSetState($inpRomPath, $GUI_HIDE)
			GUICtrlSetState ($chkRetroArch, $GUI_UNCHECKED)
		EndIf

EndFunc

Func retroarchcheck()
;Enable menu changes when the retroarch forwarder checkbox is clicked
		If GUICtrlRead($chkRetroArch) = $GUI_CHECKED Then
			GUICtrlSetState($lblNroPath, $GUI_HIDE)
			GUICtrlSetState($inpNroPath, $GUI_HIDE)
			GUICtrlSetState($inpCorePath, $GUI_SHOW)
			GUICtrlSetState($lblCorePath, $GUI_SHOW)
			GUICtrlSetState($lblRomPath, $GUI_SHOW)
			GUICtrlSetState($inpRomPath, $GUI_SHOW)
			GUICtrlSetState ($chkStandard, $GUI_UNCHECKED)
		EndIF

EndFunc


Func iconbrowse()
;Steup the browse for Icon dialog and copy resultant path
	$icon = FileOpenDialog ("Select your icon file, This will be resized", @ScriptDir, "Icon (*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tif)", $FD_FILEMUSTEXIST)
	If @error Then
		GUICtrlSetData ($inpIcon, "Icon Path")
	Else
		Local $ILength = StringLen ($icon)
			If $ILength > 256 Then
				MsgBox (0, "Error", "Path Length Too Long")
				Return
			EndIf
		GUICtrlSetData ($inpIcon, $icon)
		Call ("iconconvert")
	EndIf
EndFunc


Func logobrowse()
;Steup the browse for Icon dialog and copy resultant path
	$logo = FileOpenDialog ("Select your logo file, This will be resized", @ScriptDir, "Logo (*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.tif)", $FD_FILEMUSTEXIST)
	If @error Then
		GUICtrlSetData ($inpLogo, "Do not change for default")
	Else
		Local $LLength = StringLen ($logo)
			If $LLength > 256 Then
				MsgBox (0, "Error", "Path Length Too Long")
				Return
			EndIf
		GUICtrlSetData ($inpLogo, $logo)
		Call ("logoconvert")
	EndIf
EndFunc

Func prodbrowse()
;Setup the browse for Prod.Keys dialog and copy resultant path

	$prodkeys = FileOpenDialog ("Select your Prod.keys file",@ScriptDir, "All files (*.*)", $FD_FILEMUSTEXIST)
	if @error Then
		GUICtrlSetData ($inpProd, "prod.keys path")
		$prodkeys = @ScriptDir & "\prod.keys"
	Else
		Local $PLength = StringLen ($prodkeys)
			If $PLength > 256 Then
				MsgBox (0, "Error", "Path Length Too Long")
				Return
			EndIf
		GUICtrlSetData ($inpProd, $prodkeys)
	EndIf
EndFunc


Func errorcheck()

	;Check if prod.keys can be found
	$prodkeys = GUICtrlRead ($inpProd)
	If FileExists (@ScriptDir & "\prod.keys") = 0 And FileExists ($prodkeys) = 0 Then
		MsgBox (0, "Error", "No prod.keys found")
		$error = 1
		$prodkeys = @ScriptDir & "\prod.keys"
		Return
	Else
		$error = 0
	EndIf


	;Check The Application Name has changed
	If GUICtrlRead ($inpTitleName) = "Application Name" Then
		Msgbox(0,"Error","You Haven't Changed the Application Name")
		$error = 1
		Return
	Else
		$error = 0
	EndIf

	;Check the Author Name has changed
	If GUICtrlRead ($inpAuthor) = "Author Name" Then
		Msgbox(0,"Error","You Haven't Changed the Author Name")
		$error = 1
		Return
	Else
		$error = 0
	EndIf

	;Check if the Icon Path has changed
	If GUICtrlRead ($inpIcon) = "Icon Path" Then
		Msgbox(0,"Error","You Haven't Choosen an Icon")
		$error = 1
		Return
	Else
		$error = 0
	EndIf

	If FileExists (@ScriptDir & "\control\control.nacp") = 0 Then
		Msgbox(0,"Error","control\control.nacp file missing in script's folder")
		$error = 1
		Return
	Else
		$error = 0
	EndIf


EndFunc

Func imagemoves()
	;Move Images into the corect places
	FileCopy (@ScriptDir & "\TempIcon.jpg", @ScriptDir & "\control\icon_AmericanEnglish.dat",1)
	If GUICtrlRead ($inpLogo) = "Do not change for default" Then
		Return
	Else
		;FileCopy (GUICtrlRead ($inpLogo), @ScriptDir & "\logo\NintendoLogo.png", 1)
		FileCopy (@ScriptDir & "\TempLogo.png", @ScriptDir & "\logo\NintendoLogo.png", 1)
	EndIf
EndFunc

Func pathwrites()
	If GUICtrlRead($chkStandard) = $GUI_CHECKED Then
		FileDelete (@ScriptDir & "\romfs\nextArgv")
		FileWrite (@ScriptDir & "\romfs\nextArgv", "sdmc:/" & GUICtrlRead( $inpNroPath))
		FileDelete (@ScriptDir & "\romfs\nextNroPath")
		FileWrite (@ScriptDir & "\romfs\nextNroPath", "sdmc:/" & GUICtrlRead( $inpNroPath))
	Else
		FileDelete (@ScriptDir & "\romfs\nextArgv")
		FileWrite (@ScriptDir & "\romfs\nextArgv", "sdmc:/" & GUICtrlRead( $inpCorePath) & ' "' & "sdmc:/" & GUICtrlRead ($inpRomPath) & '"')
		FileDelete (@ScriptDir & "\romfs\nextNroPath")
		FileWrite (@ScriptDir & "\romfs\nextNroPath", "sdmc:/" & GUICtrlRead( $inpCorePath))
	EndIf
EndFunc



Func newbuild()


	;Old Version of New build process try to do it all internally rather than create and run the batch file
		$titleid = GUICtrlRead ($inpTitleID)
		$titlename = GUICtrlRead ($inpTitleName)
		$titlepub = GUICtrlRead ($inpAuthor)
		Local $hFile = FileOpen(@ScriptDir & "\control\control.nacp", 17)
		If $hFile = -1 Then
			MsgBox(0, "Error", "Unable to open control\\control.nacp file.")
			Return
		EndIf
		FileSetPos($hFile, 0, 0)
		For $i = 1 To 0x3000
			FileWrite($hFile, Binary("0x00"))
		Next
		FileSetPos($hFile, 0, 0)
		For $i = 1 To 0x11
			FileWrite($hFile, StringToBinary($titlename, $SB_UTF8))
			FileSetPos($hFile, $i*0x300-0x100, 0)
			FileWrite($hFile, StringToBinary($titlepub, $SB_UTF8))
			FileSetPos($hFile, $i*0x300, 0)
		Next
		FileClose($hFile)
		ShellExecuteWait ($hacbrewpac, ' --titleid "' & $titleid & '" --nspdir NSP -k "' & $prodkeys & '"', @ScriptDir, $SHEX_OPEN, @SW_HIDE)

		FileMove (@ScriptDir & "\NSP\" & $titleid & ".nsp", @ScriptDir & "\NSP\" & $titlename & "_" & $titleid & ".nsp")
		ShellExecute ("Explorer.exe", '"' & @ScriptDir & '\NSP\"', '"' & @ScriptDir & '\NSP\"')


EndFunc

		;This Function has been replaced by newbuild
Func nspbuild()
;Build Command
		$titleid = GUICtrlRead ($inpTitleID)
		$titlename = GUICtrlRead ($inpTitleName)
		$titlepub = GUICtrlRead ($inpAuthor)
		Local $hFile = FileOpen(@ScriptDir & "\control\control.nacp", 17)
		If $hFile = -1 Then
			MsgBox(0, "Error", "Unable to open control\\control.nacp file.")
			Return
		EndIf
		FileSetPos($hFile, 0, 0)
		For $i = 1 To 0x3000
			FileWrite($hFile, Binary("0x00"))
		Next
		FileSetPos($hFile, 0, 0)
		For $i = 1 To 0x11
			FileWrite($hFile, StringToBinary($titlename, $SB_UTF8))
			FileSetPos($hFile, $i*0x300-0x100, 0)
			FileWrite($hFile, StringToBinary($titlepub, $SB_UTF8))
			FileSetPos($hFile, $i*0x300, 0)
		Next
		FileClose($hFile)
		$build = $hacbrewpac & ' --titleid "' & $titleid & '" --nspdir NSP -k "' & $prodkeys & '"'


;Create the batch file
		FileDelete (@ScriptDir & "\GUI_Build.bat")
		FileWrite (@scriptDir & "\GUI_Build.bat", $build & @CRLF)
		FileWrite (@scriptDir & "\GUI_Build.bat", 'cd /d "' & @scriptDir & '"' & @CRLF)
		FileWrite (@scriptDir & "\GUI_Build.bat", "exit")
		RunWait(@ComSpec & ' /c "' & @ScriptDir & '\GUI_Build.bat"')
		FileMove (@ScriptDir & "\NSP\" & $titleid & ".nsp", @ScriptDir & "\NSP\" & $titlename & "_" & $titleid & ".nsp")
		ShellExecute ("Explorer.exe", '"' & @ScriptDir & '\NSP\"', '"' & @ScriptDir & '\NSP\"')

;Tidy Up

EndFunc


Func iconconvert()

    _GDIPlus_Startup()

	Local $hBitmap = _GDIPlus_ImageLoadFromFile ( GUICtrlRead ($inpIcon) )
    Local $hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, 256, 256) ;resize image

    	_GDIPlus_ImageSaveToFile ( $hBitmap_Scaled, @ScriptDir & "\TempIcon.jpg" )


    ;cleanup resources
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_BitmapDispose($hBitmap_Scaled)
    _GDIPlus_Shutdown()

	If FileExists (@ScriptDir & "\TempIcon.jpg") = 0 Then
		Local $YesNo = MsgBox (4, "Error, Conversion Failed", "Icon Image Format Incorrect!" & @LF & @LF & "Would you like me to try and open it in MSPaint?" & @LF & @LF & "If it opens please save it as a PNG" & @LF & "with a different name & try again")
		If $YesNo = 6 Then
			ShellExecute ("mspaint", '"' & GUICtrlRead ($inpIcon) & '"')
		ElseIf $YesNo = 7 Then
			Return
		EndIF
	EndIf
EndFunc


Func logoconvert()

    _GDIPlus_Startup()

	Local $hBitmap = _GDIPlus_ImageLoadFromFile ( GUICtrlRead ($inpLogo) )
    Local $hBitmap_Scaled = _GDIPlus_ImageResize($hBitmap, 160, 40) ;resize image

    	_GDIPlus_ImageSaveToFile ( $hBitmap_Scaled, @ScriptDir & "\TempLogo.png" )


    ;cleanup resources
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_BitmapDispose($hBitmap_Scaled)
    _GDIPlus_Shutdown()

	If FileExists (@ScriptDir & "\TempLogo.png") = 0 Then
		Local $YesNo = MsgBox (4, "Error, Conversion Failed", "Logo Image Format Incorrect!" & @LF & @LF & "Would you like me to try and open it in MSPaint?" & @LF & @LF & "If it opens please save it as a PNG" & @LF & "with a different name & try again")
		If $YesNo = 6 Then
			ShellExecute ("mspaint", '"' & GUICtrlRead ($inpLogo) & '"')
		ElseIf $YesNo = 7 Then
			Return
		EndIF
	EndIf
EndFunc


Func tidy()
	;Reset everything to defaults

		;Delete icon_AmericanEnglish.dat
		FileDelete (@ScriptDir & "\control\icon_AmericanEnglish.dat")

		;Delete and create new empty nextArgv and nextNroPath files
		FileDelete (@ScriptDir & "\romfs\nextArgv")
		FileWrite (@ScriptDir & "\romfs\nextArgv","")
		FileDelete (@ScriptDir & "\romfs\nextNroPath")
		FileWrite (@ScriptDir & "\romfs\nextNroPath","")

		;Restore the NintendoLogo.png
		FileDelete (@ScriptDir & "\logo\NintendoLogo.png")
		FileCopy (@ScriptDir & "\logo\NintendoLogo.bak", @ScriptDir & "\logo\NintendoLogo.png")

		;Delete the hacbrewpack_backup directory
		FileDelete (@ScriptDir & "\hacbrewpack_backup\*.*")
		DirRemove (@ScriptDir & "\hacbrewpack_backup\",1)

		;Delete the old GUI_Build.bat which is no longer needed
		FileDelete (@ScriptDir & "\GUI_Build.bat")

		;Delete Temporary Logo and Icon
		FileDelete (@ScriptDir & "\TempIcon.jpg")
		FileDelete (@ScriptDir & "\TempLogo.png")


EndFunc

Func diagnose()


	MsgBox (0, "", $prodkeys)
	;Clean Diagnose folder before running
	FileDelete (@ScriptDir & "\Diagnose\*.*")

	;Copy All Images and Create a txt file showing the command passed to hacbrewpack to help with diagnosis into the diagnose folder
	DirCreate (@ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\TempIcon.jpg", @ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\TempLogo.png", @ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\logo\NintendoLogo.png", @ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\control\icon_AmericanEnglish.dat", @ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\romfs\nextNroPath", @ScriptDir & "\Diagnose\")
	FileCopy (@ScriptDir & "\romfs\nextArgv", @ScriptDir & "\Diagnose\")
	FileWriteLine (@ScriptDir & "\Diagnose\Out.txt", $hacbrewpac & ' --titleid "' & $titleid & '" --nspdir NSP -k "' & $prodkeys & '"')

EndFunc