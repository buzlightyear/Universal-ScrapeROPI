#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Ressources\Universal_Xml_Scraper.ico
#AutoIt3Wrapper_Outfile=..\BIN\Universal_XML_Scraper.exe
#AutoIt3Wrapper_Outfile_x64=..\BIN\Universal_XML_Scraper64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Description=Scraper XML Universel
#AutoIt3Wrapper_Res_Fileversion=2.1.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
#AutoIt3Wrapper_Res_LegalCopyright=LEGRAS David
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/reel
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;*************************************************************************
;**																		**
;**						Universal XML Scraper V2						**
;**						LEGRAS David									**
;**																		**
;*************************************************************************

;Autoit Librairy definitions
;---------------------------

#include <Date.au3>
#include <array.au3>
#include <File.au3>
#include <String.au3>
#include <GuiStatusBar.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <InetConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

TraySetState(2)

;Global Values
;---------------------------

If Not _FileCreate(@ScriptDir & "\test") Then ; Testing UXS Directory
	Global $iScriptPath = @AppDataDir & "\UXMLS" ; If not, use Path to current user's Roaming Application Data
	DirCreate($iScriptPath) ;
Else
	Global $iScriptPath = @ScriptDir
	FileDelete($iScriptPath & "\test")
EndIf

Global $iINIPath = $iScriptPath & "\UXS-config.ini"
Global $iLOGPath = $iScriptPath & "\LOGs\log.txt"
Global $iVerboseLVL = IniRead($iINIPath, "GENERAL", "$vVerbose", 0)
Global $MS_AutoConfigItem

;Personnal Librairy definitions
;---------------------------

#include "./Include/_MultiLang.au3"
#include "./Include/_ExtMsgBox.au3"
#include "./Include/_Trim.au3"
#include "./Include/_Hash.au3"
;~ #include "./Include/_zip.au3"
#include "./Include/_XML.au3"
#include "./Include/MailSlot.au3"
#include "./Include/_GraphGDIPlus.au3"
#include "./Include/_MyFunction.au3"
#include "./Include/_ITaskBarList.au3"

$oTaskbar = _ITaskBar_CreateTaskBarObj()

;Checking Version
;----------------
_LOG_Ceation($iLOGPath) ; Starting Log

If @OSArch = "X64" Then
	_LOG("Scrape in x64", 0, $iLOGPath)
	Local $iScraper = "Scraper64.exe"
Else
	_LOG("Scrape in x86", 0, $iLOGPath)
	Local $iScraper = "Scraper.exe"
EndIf

If @Compiled Then
	Local $iScriptVer = FileGetVersion(@ScriptFullPath)
	Local $iINIVer = IniRead($iINIPath, "GENERAL", "$verINI", '0.0.0.0')
	Local $iSoftname = "UniversalXMLScraperV" & $iScriptVer
	If $iINIVer <> $iScriptVer Then
		FileDelete($iScriptPath & "\UXS-config.ini")
		FileDelete($iScriptPath & "\LanguageFiles")
		FileDelete($iScriptPath & "\Ressources")
		FileDelete($iScriptPath & "\Mix")
		FileDelete($iScriptPath & "\ProfilsFiles")
		_LOG("Update file needed from version " & $iINIVer & " to " & $iScriptVer, 1, $iLOGPath)
		While ProcessExists($iScraper)
			ProcessClose($iScraper)
		WEnd
		FileDelete($iScraper)
	Else
		_LOG("No updated files needed (Version : " & $iScriptVer & ")", 1, $iLOGPath)
	EndIf
Else
	Local $iScriptVer = 'In Progress'
	Local $iINIVer = IniRead($iINIPath, "GENERAL", "$verINI", '0.0.0.0')
	Local $iSoftname = "UniversalXMLScraper(TestDev)"
	_LOG("Dev version", 1, $iLOGPath)
EndIf

#Region FileInstall
_LOG("Starting files installation", 0, $iLOGPath)
DirCreate($iScriptPath & "\LanguageFiles")
DirCreate($iScriptPath & "\Ressources")
DirCreate($iScriptPath & "\Ressources\Licences")
DirCreate($iScriptPath & "\Mix")
DirCreate($iScriptPath & "\Mix\TEMP")
DirCreate($iScriptPath & "\ProfilsFiles")
DirCreate($iScriptPath & "\ProfilsFiles\Ressources")
FileInstall(".\UXS-config.ini", $iScriptPath & "\UXS-config.ini")
FileInstall(".\LanguageFiles\UXS-ENGLISH.XML", $iScriptPath & "\LanguageFiles\UXS-ENGLISH.XML")
FileInstall(".\LanguageFiles\UXS-FRENCH.XML", $iScriptPath & "\LanguageFiles\UXS-FRENCH.XML")
FileInstall(".\LanguageFiles\UXS-PORTUGUESE.XML", $iScriptPath & "\LanguageFiles\UXS-PORTUGUESE.XML")
FileInstall(".\LanguageFiles\UXS-GERMAN.XML", $iScriptPath & "\LanguageFiles\UXS-GERMAN.XML")
FileInstall(".\LanguageFiles\UXS-SPANISH.XML", $iScriptPath & "\LanguageFiles\UXS-SPANISH.XML")
FileInstall(".\LanguageFiles\UXS-ITALIAN.XML", $iScriptPath & "\LanguageFiles\UXS-ITALIAN.XML")
FileInstall(".\LanguageFiles\UXS-DUTCH.XML", $iScriptPath & "\LanguageFiles\UXS-DUTCH.XML")
FileInstall(".\Ressources\plink.exe", $iScriptPath & "\Ressources\plink.exe")
FileInstall(".\Ressources\pngquant.exe", $iScriptPath & "\Ressources\pngquant.exe")
FileInstall(".\Ressources\7za.exe", $iScriptPath & "\Ressources\7za.exe")
;~ FileInstall(".\Ressources\optipng.exe", $iScriptPath & "\Ressources\optipng.exe")
;~ FileInstall(".\Ressources\Licences\LICENSE optipng.txt", $iScriptPath & "\Ressources\Licences\LICENSE optipng.txt")
FileInstall(".\Ressources\Licences\LICENSE pngquant.txt", $iScriptPath & "\Ressources\Licences\LICENSE pngquant.txt")
FileInstall(".\Ressources\Licences\LICENSE plink.txt", $iScriptPath & "\Ressources\Licences\LICENSE plink.txt")
FileInstall(".\Ressources\Licences\LICENSE 7za.txt", $iScriptPath & "\Ressources\Licences\LICENSE 7za.txt")
FileInstall(".\Ressources\systemlist.txt", $iScriptPath & "\Ressources\systemlist.txt")
FileInstall(".\Ressources\regionlist.txt", $iScriptPath & "\Ressources\regionlist.txt")
FileInstall(".\Ressources\UXS.jpg", $iScriptPath & "\Ressources\UXS.jpg")
FileInstall(".\Ressources\UXS Wizard.jpg", $iScriptPath & "\Ressources\UXS Wizard.jpg")
FileInstall(".\Ressources\jingle_uxs.MP3", $iScriptPath & "\Ressources\jingle_uxs.MP3")
FileInstall(".\Mix\Arcade (moon).zip", $iScriptPath & "\Mix\")
FileInstall(".\Mix\Standard (3img).zip", $iScriptPath & "\Mix\")
FileInstall(".\ProfilsFiles\Retrorangepi.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\RecalboxV3 (MIX).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\RecalboxV3.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\RecalboxV4 (MIX).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\RecalboxV4 [SCUMMVM] (MIX).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\RecalboxV4.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie (MIX).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie (MIX)(Video).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie.xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie (Video).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie [Rom folder] (MIX).xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Retropie [Rom folder].xml", $iScriptPath & "\ProfilsFiles\", 0)
FileInstall(".\ProfilsFiles\Ressources\empty.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-SCUMMVM-RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-RecalboxV3.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-Retropie.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper(MIX)-Retropie(Video).jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-RecalboxV4.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-RecalboxV3.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-Retropie.jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\ProfilsFiles\Ressources\Screenscraper-Retropie(Video).jpg", $iScriptPath & "\ProfilsFiles\Ressources\", 0)
FileInstall(".\Scraper.exe", $iScriptPath & "\Scraper.exe", 0)
FileInstall(".\Scraper64.exe", $iScriptPath & "\Scraper64.exe", 0)
FileSetAttrib($iScriptPath & "\Scraper.exe", "+H")
FileSetAttrib($iScriptPath & "\Scraper64.exe", "+H")
_LOG("Ending files installation", 1, $iLOGPath)
#EndRegion FileInstall

;Splash Screen
$F_Splashcreen = GUICreate("", 799, 449, -1, -1, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW)
GUICtrlCreatePic($iScriptPath & "\Ressources\UXS.jpg", -1, -1, 800, 450)
SoundPlay($iScriptPath & "\Ressources\jingle_uxs.MP3")
GUISetState()

;Const def
;---------
Global $iDevId = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B5", "1gdf1g1gf", $CALG_RC4))
Global $iDevPassword = BinaryToString(_Crypt_DecryptData("0x1552EDED2FA9B547FBD0D9A623D954AE7BEDC681", "1gdf1g1gf", $CALG_RC4))
Global $iTEMPPath = $iScriptPath & "\TEMP"
Global $iRessourcesPath = $iScriptPath & "\Ressources"
Global $iLangPath = $iScriptPath & "\LanguageFiles" ; Where we are storing the language files.
Global $iProfilsPath = $iScriptPath & "\ProfilsFiles" ; Where we are storing the profils files.
Global $iMIXPath = $iScriptPath & "\Mix" ; Where we are storing the MIX files.
Global $iPathMixTmp = $iMIXPath & "\TEMP" ; Where we are storing the current MIX files.
Global $iURLMirror = "http://uxs-screenscraper.recalbox.com/"
Global $iURLSS = "http://www.screenscraper.fr/"
Global $iURLScraper = $iURLSS

_LOG("Verbose LVL : " & $iVerboseLVL, 1, $iLOGPath)
_LOG("Path to ini : " & $iINIPath, 1, $iLOGPath)
_LOG("Path to log : " & $iLOGPath, 1, $iLOGPath)
_LOG("Path to language : " & $iLangPath, 1, $iLOGPath)

;Variable def
;------------
Global $vUserLang = IniRead($iINIPath, "LAST_USE", "$vUserLang", -1)
Global $MP_, $aPlink_Command, $vScrapeCancelled
Global $vProfilsPath = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", -1)
Local $vXpath2RomPath, $vFullTimer, $vRomTimer, $vSelectedProfil = -1
Local $L_SCRAPE_Parts[3] = [300, 480, -1]
Local $oXMLProfil, $oXMLSystem, $oXMLCountry
Local $aConfig, $aRomList, $aXMLRomList
Local $nMsg
Local $sMailSlotMother = "\\.\mailslot\Mother"
Local $sMailSlotCancel = "\\.\mailslot\Cancel"
Local $hMailSlotMother = _CreateMailslot($sMailSlotMother)
Local $vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
Local $vStart = 0, $vWizCancel = 0
Local $sMailSlotCheckEngine = "\\.\mailslot\CheckEngine"
Local $hMailSlotCheckEngine = _CreateMailslot($sMailSlotCheckEngine)

;---------;
;Principal;
;---------;

; Loading language
Local $aLangList = _MultiLang_LoadLangDef($iLangPath, $vUserLang)
If Not IsArray($aLangList) Or $aLangList < 0 Then
	_LOG("Impossible to load language", 2, $iLOGPath)
	Exit
EndIf
;~ _ArrayDisplay($aLangList, "$aLangList") ;Debug

; Update Checking
_LOG("Update Checking", 1, $iLOGPath)
Local $iChangelogPath = $iScriptPath & "\changelog.txt"
FileDelete($iChangelogPath)
Local $Result = _DownloadWRetry("https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/changelog.txt", $iChangelogPath)
Switch $Result
	Case -1
		_LOG("Error downloading Changelog", 2, $iLOGPath)
	Case -2
		_LOG("Time Out downloading Changelog", 2, $iLOGPath)
	Case Else
		Local $iChangelogVer = FileReadLine($iChangelogPath)
		_LOG("Local : " & $iScriptVer & " - Github : " & $iChangelogVer, 0, $iLOGPath)
		If $iChangelogVer <> $iScriptVer And @Compiled = 1 Then
			_LOG("Asking to Update", 0, $iLOGPath)
			_GUI_Update($iChangelogPath)
		EndIf
EndSwitch

;Catching SystemList.xml
$oXMLSystem = _XMLSystem_Create()
If $oXMLSystem = -1 Then Exit

;Catching CountryList.xml
$oXMLCountry = _XMLCountry_Create()
If $oXMLCountry = -1 Then Exit

;Delete Splascreen
GUIDelete($F_Splashcreen)

#Region ### START Koda GUI section ### Form=
Local $F_UniversalScraper = GUICreate(_MultiLang_GetText("main_gui"), 601, 370)
GUISetBkColor(0x34495c, $F_UniversalScraper)
Local $MF = GUICtrlCreateMenu(_MultiLang_GetText("mnu_file"))
Local $MF_Separation = GUICtrlCreateMenuItem("", $MF)
Local $MF_Exit = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_file_exit"), $MF)

Local $MC = GUICtrlCreateMenu(_MultiLang_GetText("mnu_cfg"))
Local $MC_Wizard = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_Wizard"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_Config_LU = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_LU"), $MC)
Local $MC_config_autoconf = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_autoconf"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_config_Option = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_Option"), $MC)
Local $MC_config_MISC = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_MISC"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_config_PIC = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_config_PIC"), $MC)
Local $MC_Miximage = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_miximage"), $MC)
Local $MC_MixDownload = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_download_miximage"), $MC)
Local $MC_Separation = GUICtrlCreateMenuItem("", $MC)
Local $MC_Profil = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_profil"), $MC)
Local $MC_Langue = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_cfg_langue"), $MC)
;~ Local $MC_TEST = GUICtrlCreateMenuItem("TEST", $MC) ; Debug

Local $MS = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape"))
Local $MS_AutoConfig = GUICtrlCreateMenu(_MultiLang_GetText("mnu_scrape_autoconf"), $MS, 1)
Local $MS_Scrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_solo"), $MS)
Local $MS_Separation = GUICtrlCreateMenuItem("", $MS)
Local $MS_FullScrape = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_scrape_fullscrape"), $MS)

Local $MP = GUICtrlCreateMenu(_MultiLang_GetText("mnu_ssh"))
Local $MP_Parameter = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_ssh_Parameter"), $MP)
Local $MP_Separation = GUICtrlCreateMenuItem("", $MP)
GUICtrlSetState($MP, $GUI_DISABLE)

Local $MH = GUICtrlCreateMenu(_MultiLang_GetText("mnu_help"))
Local $MH_Help = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_help_wiki"), $MH)
Local $MH_Support = GUICtrlCreateMenu(_MultiLang_GetText("mnu_help_support"), $MH)
Local $MH_Support_Screenscraper = GUICtrlCreateMenuItem("Screenscraper", $MH_Support, 1)
Local $MH_Support_Tipee = GUICtrlCreateMenuItem("Tipee (€)", $MH_Support, 2)
Local $MH_Support_Patreon = GUICtrlCreateMenuItem("Patreon ($)", $MH_Support, 3)
Local $MH_Link = GUICtrlCreateMenu(_MultiLang_GetText("mnu_help_link"), $MH)
Local $MH_Link_Screenzone = GUICtrlCreateMenuItem("http://www.screenzone.fr/", $MH_Link, 1)
Local $MH_Link_Recalbox = GUICtrlCreateMenuItem("https://www.recalbox.com/", $MH_Link, 2)
Local $MH_Link_Retropie = GUICtrlCreateMenuItem("https://retropie.org.uk/", $MH_Link, 3)
Local $MH_Changelog = GUICtrlCreateMenuItem('Changelog', $MH)
Local $MH_Log = GUICtrlCreateMenuItem('Log', $MH)
Local $MH_About = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_help_about"), $MH)

Local $P_BACKGROUND = GUICtrlCreatePic($iScriptPath & "\ProfilsFiles\Ressources\empty.jpg", -1, 0, 600, 293)
Local $PB_SCRAPE = GUICtrlCreateProgress(2, 297, 478, 25)
Local $B_SCRAPE = GUICtrlCreateButton(_MultiLang_GetText("scrap_button"), 481, 296, 118, 27)
Local $L_SCRAPE = _GUICtrlStatusBar_Create($F_UniversalScraper)
_GUICtrlStatusBar_SetParts($L_SCRAPE, $L_SCRAPE_Parts)
Dim $F_UniversalScraper_AccelTable[3][2] = [["!+{DOWN}", $MC_Config_LU], ["!+{F21}", $MC_Separation], ["{VERR.MAJ}", $MS_FullScrape]]
GUISetAccelerators($F_UniversalScraper_AccelTable)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

_ITaskBar_SetThumbNailToolTip($F_UniversalScraper)

$vProfilDefault = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", "")
If $vProfilDefault = "" Then
	$vStart = 1
	IniWrite($iINIPath, "LAST_USE", "$vMirror", 0)
Else
	;Opening XML Profil file
	$oXMLProfil = _XML_Open($vProfilsPath)
	If $oXMLProfil = -1 Then Exit

	;Setting MIX Template
	_LOG("Setting Mix Template", 0, $iLOGPath)
	$vLastMIX = $iMIXPath & "\" & IniRead($iINIPath, "LAST_USE", "$vMixImage", "Standard (3img)") & ".zip"
	DirRemove($iPathMixTmp, 1)
	DirCreate($iPathMixTmp)
;~ 	$vResult = _Zip_UnzipAll($vLastMIX, $iPathMixTmp, 0)
	$vResult = _Unzip($vLastMIX, $iPathMixTmp)
	If $vResult < 0 Then
		Switch $vResult
			Case 1
				_LOG("not a Zip file", 2, $iLOGPath)
			Case 2
				_LOG("Impossible to unzip", 2, $iLOGPath)
			Case Else
				_LOG("Unknown Zip Error (" & @error & ")", 2, $iLOGPath)
		EndSwitch
	EndIf

	If IniRead($iINIPath, "LAST_USE", "$vMirror", 1) = 0 Then $iURLScraper = $iURLSS

	$aDIRList = _Check_autoconf($oXMLProfil)
	_LoadConfig($oXMLProfil)
	_GUI_Refresh($oXMLProfil)
EndIf
_LOG("GUI Constructed", 1, $iLOGPath)

While 1
	$nMsg = GUIGetMsg()
	If $vStart = 1 Then $nMsg = $MC_Wizard

	Switch $nMsg
		Case $MC_Wizard ;Wizard
			If $vStart = 0 Then $vWizCancel = 1
			$vBoucle = 1
			$vMaxWizard = 5
			While $vBoucle < $vMaxWizard
				Switch $vBoucle
					Case 1
						$vResult = _WizardProfil($vWizCancel)
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vResult)
								_LOG("Wizard - Profil selected : " & $vResult, 0, $iLOGPath)
								$oXMLProfil = _XML_Open($vResult)
								If $oXMLProfil = -1 Then Exit
								IniWrite($iINIPath, "LAST_USE", "$vRechFiles", _Coalesce(_XML_Read("Profil/General/Research", 0, "", $oXMLProfil), "*.*|*.xml;*.txt;*.dv;*.fs;*.xor;*.drv;*.dat;*.cfg;*.nv;*.sav*|"))
								$vBoucle = $vBoucle + 1
						EndSwitch

					Case 2
						$vResult = _WizardAutoconf($vWizCancel)
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								_XML_Replace("Profil/AutoConf/Source_RootPath", $vResult, 0, "", $oXMLProfil)
								FileDelete($vProfilsPath)
								_XML_SaveToFile($oXMLProfil, $vProfilsPath)
								IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", 1)
								$aDIRList = _Check_autoconf($oXMLProfil)
								If IsArray($aDIRList) Then
									IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[1][1])
									IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[1][2])
									IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[1][3])
									IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[1][4])
									IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[1][5])
									_LoadConfig($oXMLProfil)
									_GUI_Refresh($oXMLProfil)
									If IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", 0) <> 0 Then $vBoucle = $vBoucle + 1
								EndIf

						EndSwitch
					Case 3
						If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then
							$vResult = _WizardWindow(_MultiLang_GetText("win_Wizard_MIX_Title"), _MultiLang_GetText("win_Wizard_MIX_Desc"), "", "", 0, 1, 1, $vWizCancel)
							If $vResult > 0 Then _GUI_Config_MIX($iMIXPath, $iPathMixTmp)
						Else
							_WizardWindow(_MultiLang_GetText("win_Wizard_END_Title"), _MultiLang_GetText("win_Wizard_END_Desc"), "", "", 0, 1, 1, $vWizCancel)
							$vResult = -2
						EndIf
						Switch $vResult
							Case -2
								$vBoucle = $vMaxWizard
							Case -1
								$vBoucle = $vBoucle - 1
							Case Else
								$vBoucle = $vBoucle + 1
						EndSwitch
					Case 4
						$vResult = _WizardWindow(_MultiLang_GetText("win_Wizard_END_Title"), _MultiLang_GetText("win_Wizard_END_Desc"), "", "", 0, 0, 0, 2)
						$vBoucle = $vMaxWizard
				EndSwitch
			WEnd
			If $vStart = 1 Then $vStart = 0
		Case $GUI_EVENT_CLOSE, $MF_Exit ; Exit
			DirRemove($iTEMPPath, 1)
			_LOG("Universal XML Scraper Closed", 0, $iLOGPath)
			Exit
		Case $MC_Profil ;Profil Selection
			$vProfilsPath = _ProfilSelection($iProfilsPath)
			IniWrite($iINIPath, "LAST_USE", "$vProfilsPath", $vProfilsPath)
			;Opening XML Profil file
			$oXMLProfil = _XML_Open($vProfilsPath)
			If $oXMLProfil = -1 Then Exit
			IniWrite($iINIPath, "LAST_USE", "$vRechFiles", _Coalesce(_XML_Read("Profil/General/Research", 0, "", $oXMLProfil), "*.*||"))
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
			$nMsg = ""
		Case $MC_Langue ;Langue Selection
			$aLangList = _MultiLang_LoadLangDef($iLangPath, -1)
			If Not IsArray($aLangList) Or $aLangList < 0 Then
				_LOG("Impossible to load language", 2, $iLOGPath)
				Exit
			EndIf
			_LoadConfig($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MC_Config_LU ;Manual Path Configuration
			_GUI_Config_LU()
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_Option ;Option Configuration
			$GUI_Config_Options = _GUI_Config_Options($oXMLProfil)
			If $GUI_Config_Options = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_PIC ;Picture Configuration
			_GUI_Config_Image($oXMLProfil, $iPathMixTmp)
			_GUI_Refresh($oXMLProfil)
		Case $MC_config_MISC ;General Configuration
			_GUI_Config_MISC()
			_GUI_Refresh($oXMLProfil)
		Case $MC_Miximage ;Mix Image Selection
			_GUI_Config_MIX($iMIXPath, $iPathMixTmp)
		Case $MC_MixDownload
			_GUI_Config_MIX_Download()
		Case $MC_config_autoconf ;Autoconf Configuration
			$GUI_Config_autoconf = _GUI_Config_autoconf($oXMLProfil)
			If $GUI_Config_autoconf = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
			Local $vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
			$vSystem = $vSystem[UBound($vSystem) - 1]

			If $aDIRList <> -1 Then
				For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
					If $aDIRList[$vBoucle][0] = $vSystem Then
						_LOG("Checked system :" & $aDIRList[$vBoucle][0], 0, $iLOGPath)
						IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
						IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
						IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
						IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
						IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
						$nMsg = 0
						_GUI_Refresh($oXMLProfil)
					EndIf
				Next
			EndIf
		Case $MP_Parameter
			$GUI_Config_SSHParameter = _GUI_Config_SSHParameter($oXMLProfil)
			If $GUI_Config_SSHParameter = 1 Then
				FileDelete($vProfilsPath)
				_XML_SaveToFile($oXMLProfil, $vProfilsPath)
			EndIf
			$aDIRList = _Check_autoconf($oXMLProfil)
			_GUI_Refresh($oXMLProfil)
		Case $MH_Help
			ShellExecute("https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/wiki")
		Case $MH_Support_Screenscraper
			ShellExecute("http://www.screenscraper.fr/")
		Case $MH_Support_Tipee
			ShellExecute("https://www.tipeee.com/screenscraper")
		Case $MH_Support_Patreon
			ShellExecute("https://www.patreon.com/screenscraper")
		Case $MH_Link_Screenzone
			ShellExecute("http://www.screenzone.fr/")
		Case $MH_Link_Recalbox
			ShellExecute("https://www.recalbox.com/")
		Case $MH_Link_Retropie
			ShellExecute("https://retropie.org.uk/")
		Case $MH_Changelog
			_GUI_Update($iChangelogPath, $F_UniversalScraper)
		Case $MH_Log
			_GUI_Log($F_UniversalScraper)
		Case $MH_About ;Help
			SoundPlay($iScriptPath & "\Ressources\jingle_uxs.MP3")
			$sMsg = "UNIVERSAL XML SCRAPER - " & $iScriptVer & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_By") & @CRLF & @CRLF
			$sMsg &= _MultiLang_GetText("win_About_Thanks") & @CRLF
			$sMsg &= "All Screenzone comunity" & @CRLF
			$sMsg &= "All Recalbox comunity" & @CRLF
			$sMsg &= "All Friends on IRC and forum" & @CRLF
			$sMsg &= "Special dedicace :" & @CRLF
			$sMsg &= "MarbleMad for Screenscraper" & @CRLF
			$sMsg &= "Kam3leon for Splashscreen" & @CRLF
			$sMsg &= "Neogeronimo for the Jingle" & @CRLF
			$sMsg &= "Madmeggo, Paradadf and Lackyluuk for German translation" & @CRLF
			$sMsg &= "Paradadf for Spanish translation" & @CRLF
			$sMsg &= "Cricetomutante for Italian translation" & @CRLF
			$sMsg &= "Digital Lumberjack for the Mirror" & @CRLF
			$sMsg &= "Verybadsoldier for the 'In ZIP scrape'" & @CRLF

			_ExtMsgBoxSet(1, 2, 0x34495c, 0xFFFF00, 10, "Arial")
			_ExtMsgBox($EMB_ICONINFO, "OK", _MultiLang_GetText("win_About_Title"), $sMsg, 15)
		Case $B_SCRAPE, $MS_Scrape ;Solo Scrape or Cancel
			$vFullTimer = TimerInit()
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			$aRomList = _SCRAPE($oXMLProfil, $vNbThread)
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			_LOG("-- Full Scrape in " & Round((TimerDiff($vFullTimer) / 1000), 2) & "s", 0, $iLOGPath)
			_Results($aRomList, $vNbThread, $vFullTimer)
			$vScrapeCancelled = 0
			_GUI_Refresh($oXMLProfil)
		Case $MS_FullScrape ;FullScrape
			Dim $aRomList_FULL[1][12]
			$vFullTimer = TimerInit()
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
				$aRomList = _SCRAPE($oXMLProfil, $vNbThread, 1)
				If IsArray($aRomList) Then
					For $i = 1 To UBound($aRomList, 1) - 1
						ReDim $aRomList_FULL[UBound($aRomList_FULL, 1) + 1][UBound($aRomList, 2)]
						For $j = 0 To UBound($aRomList, 2) - 1
							$aRomList_FULL[UBound($aRomList_FULL, 1) - 1][$j] = $aRomList[$i][$j]
						Next
					Next
				EndIf
				If Not _Check_Cancel() Then $vBoucle = UBound($MS_AutoConfigItem) - 1
			Next
			$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", 1)
			_LOG("-- Full Scrape in " & Round((TimerDiff($vFullTimer) / 1000), 2) & "s", 0, $iLOGPath)
			_Results($aRomList_FULL, $vNbThread, $vFullTimer)
			$vScrapeCancelled = 0
			_GUI_Refresh($oXMLProfil)
	EndSwitch
	;SSH Menu
	If IsArray($MP_) Then
		For $vBoucle = 1 To UBound($MP_) - 1
			If $nMsg = $MP_[$vBoucle] Then _Plink($oXMLProfil, $aPlink_Command[$vBoucle][0])
		Next
	EndIf

	;Auto Conf Sub Menu
	If $aDIRList <> -1 Then
		For $vBoucle = 1 To UBound($MS_AutoConfigItem) - 1
			If $nMsg = $MS_AutoConfigItem[$vBoucle] Then
				_LOG("Autoconfig Selected :" & $aDIRList[$vBoucle][0], 0, $iLOGPath)
				For $vBoucle2 = 1 To UBound($MS_AutoConfigItem) - 1
					GUICtrlSetState($MS_AutoConfigItem[$vBoucle2], $GUI_UNCHECKED)
				Next
				GUICtrlSetState($MS_AutoConfigItem[$vBoucle], $GUI_CHECKED)
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $aDIRList[$vBoucle][1])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $aDIRList[$vBoucle][2])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $aDIRList[$vBoucle][3])
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $aDIRList[$vBoucle][4])
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $aDIRList[$vBoucle][5])
				$nMsg = 0
				_GUI_Refresh($oXMLProfil)
			EndIf
		Next
	EndIf

WEnd

;---------;
;Fonctions;
;---------;

Func _LoadConfig($oXMLProfil)
	Local $aMatchingCountry
	Dim $aConfig[15]
	$aConfig[0] = IniRead($iINIPath, "LAST_USE", "$vTarget_XMLName", " ")
	$aConfig[1] = IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", "")
	$aConfig[2] = IniRead($iINIPath, "LAST_USE", "$vTarget_RomPath", "./")
	$aConfig[3] = IniRead($iINIPath, "LAST_USE", "$vSource_ImagePath", "")
	$aConfig[4] = IniRead($iINIPath, "LAST_USE", "$vTarget_ImagePath", "./downloaded_images/")
	$aConfig[5] = IniRead($iINIPath, "LAST_USE", "$vScrape_Mode", 0)
	$aConfig[6] = IniRead($iINIPath, "LAST_USE", "$vMissingRom_Mode", 0)
	$aConfig[7] = IniRead($iINIPath, "LAST_USE", "$vCountryPic_Mode", 0)
	If IniRead($iINIPath, "LAST_USE", "$vLangPref", "0") = "0" Then IniWrite($iINIPath, "LAST_USE", "$vLangPref", _MultiLang_GetText("langpref"))
	If IniRead($iINIPath, "LAST_USE", "$vCountryPref", "0") = "0" Then IniWrite($iINIPath, "LAST_USE", "$vCountryPref", _MultiLang_GetText("countrypref"))
	$aConfig[9] = IniRead($iINIPath, "LAST_USE", "$vLangPref", "")
	$aConfig[10] = IniRead($iINIPath, "LAST_USE", "$vCountryPref", "")
	$aConfig[11] = $iRessourcesPath & "\regionlist.txt"
	$aConfig[12] = 0
	$aConfig[13] = IniRead($iINIPath, "LAST_USE", "$vSSLogin", "")
	$aConfig[14] = BinaryToString(_Crypt_DecryptData(IniRead($iINIPath, "LAST_USE", "$vSSPassword", ""), "1gdf1g1gf", $CALG_RC4))

	If Not FileExists($aConfig[1]) Then
		_ExtMsgBox($EMB_ICONEXCLAM, "OK", _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"), 15)
		_LOG("Error Access to : " & $aConfig[1], 2, $iLOGPath)
		Return 0
	EndIf

	_LOG("$vTarget_XMLName = " & $aConfig[0], 1, $iLOGPath)
	_LOG("$vSource_RomPath = " & $aConfig[1], 1, $iLOGPath)
	_LOG("$vTarget_RomPath = " & $aConfig[2], 1, $iLOGPath)
	_LOG("$vSource_ImagePath = " & $aConfig[3], 1, $iLOGPath)
	_LOG("$vTarget_ImagePath = " & $aConfig[4], 1, $iLOGPath)
	_LOG("$vScrape_Mode = " & $aConfig[5], 1, $iLOGPath)
	_LOG("$vMissingRom_Mode = " & $aConfig[6], 1, $iLOGPath)
	_LOG("$vCountryPic_Mode = " & $aConfig[7], 1, $iLOGPath)
	_LOG("$vLangPref = " & $aConfig[9], 1, $iLOGPath)
	_LOG("$vCountryPref = " & $aConfig[10], 1, $iLOGPath)
	_LOG("$aMatchingCountry = " & $aConfig[11], 1, $iLOGPath)

	If Not FileExists($aConfig[3]) Then DirCreate($aConfig[3] & "\")
;~ 	If Not FileExists($aConfig[0]) Then _FileCreate($aConfig[0])

	Return $aConfig
EndFunc   ;==>_LoadConfig

Func _ProfilSelection($iProfilsPath, $vProfilsPath = -1) ;Profil Selection
	; Loading profils list
	$aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
;~ 	_ArrayDisplay($aProfilList, "$aProfilList") ;Debug
	If Not IsArray($aProfilList) Then
		_LOG("No Profils found", 2, $iLOGPath)
		Exit
	EndIf
	_ArrayColInsert($aProfilList, 0)
	_ArrayColInsert($aProfilList, 0)
	_ArrayDelete($aProfilList, 0)

	For $vBoucle = 0 To UBound($aProfilList) - 1
		$aProfilList[$vBoucle][0] = _XML_Read("Profil/Name", 1, $aProfilList[$vBoucle][2])
		If StringInStr($aProfilList[$vBoucle][0], $vProfilsPath) Then $vProfilsPath = $aProfilList[$vBoucle][2]
	Next
;~ 	_ArrayDisplay($aProfilList, "$aProfilList") ;Debug

	If $vProfilsPath = -1 Then $vProfilsPath = _SelectGUI($aProfilList, $aProfilList[0][2], "Profil")
	_LOG("Profil selected : " & $vProfilsPath, 0, $iLOGPath)
	Return $vProfilsPath
EndFunc   ;==>_ProfilSelection

Func _Plink($oXMLProfil, $vPlinkCommand, $vSilentPlink = 0) ;Send a Command via Plink
	Local $vPlink_Ip = _XML_Read("Profil/Plink/Ip", 0, "", $oXMLProfil)
	Local $vPlink_Root = _XML_Read("Profil/Plink/Root", 0, "", $oXMLProfil)
	Local $vPlink_Pswd = _XML_Read("Profil/Plink/Pswd", 0, "", $oXMLProfil)

	If $vSilentPlink = 0 Then
		Local $aPlink_Command = _XML_Read("Profil/Plink/Command/" & $vPlinkCommand, 0, "", $oXMLProfil)
		If MsgBox($MB_OKCANCEL, $vPlinkCommand, _MultiLang_GetText("mess_ssh_" & $vPlinkCommand)) = $IDOK Then
			_LOG("SSH : " & $aPlink_Command, 0, $iLOGPath)
			$sRun = $iScriptPath & "\Ressources\plink.exe " & $vPlink_Ip & " -ssh -l " & $vPlink_Root & " -pw " & $vPlink_Pswd & " " & $aPlink_Command
			$iPid = Run($sRun, '', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD) ;@ComSpec & " /c " &
			$PlinkTimeout = TimerInit()
			While ProcessExists($iPid)
				If TimerDiff($PlinkTimeout) > 5000 Then
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PlinkGlobal") & @CRLF & "(Timeout)")
					_LOG("TimeOut with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2, $iLOGPath)
					StdioClose($iPid)
					Return -1
				EndIf
				$_StderrRead = StderrRead($iPid)
				If Not @error And $_StderrRead <> '' Then
					If StringInStr($_StderrRead, 'Unable to open connection') Then
						MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PlinkGlobal") & @CRLF & _MultiLang_GetText("err_PlinkConnection"))
						_LOG("Unable to open connection with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2, $iLOGPath)
						StdioClose($iPid)
						Return -1
					EndIf
				EndIf
			WEnd
		Else
			_LOG("SSH canceled : " & $aPlink_Command, 1, $iLOGPath)
		EndIf
	Else
		$sRun = $iScriptPath & "\Ressources\plink.exe " & $vPlink_Ip & " -ssh -l " & $vPlink_Root & " -pw " & $vPlink_Pswd & " " & $vPlinkCommand
		_LOG("SSH : " & $sRun, 1, $iLOGPath)
		$iPid = Run(@ComSpec & " /c " & $sRun, '', @SW_HIDE, $STDIN_CHILD + $STDERR_CHILD + $STDOUT_CHILD) ;@ComSpec & " /c " &
		$PlinkTimeout = TimerInit()
		While ProcessExists($iPid)
			If TimerDiff($PlinkTimeout) > 300000 Then
				MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PlinkGlobal") & @CRLF & "(Timeout)")
				_LOG("TimeOut with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2, $iLOGPath)
				StdioClose($iPid)
				Return -1
			EndIf
			$_StderrRead = StderrRead($iPid)
			If Not @error And $_StderrRead <> '' Then
				If StringInStr($_StderrRead, 'Unable to open connection') Then
					_LOG("Unable to open connection with Plink (" & $vPlink_Root & ":" & $vPlink_Pswd & "@" & $vPlink_Ip & ")", 2, $iLOGPath)
					StdioClose($iPid)
					Return -1
				EndIf
			EndIf
			$_StdoutRead = StdoutRead($iPid)
			If $_StdoutRead <> '' Then
				_LOG("SSH Return : " & $_StdoutRead, 1, $iLOGPath)
				StdioClose($iPid)
				Return $_StdoutRead
			EndIf
		WEnd
	EndIf
	Return
EndFunc   ;==>_Plink

Func _GUI_Config_Options($oXMLProfil)
	Local $aValue_Option = ""
	Local $vDefaultOptionValue = 0
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_Option_Title"), 243, 263, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Option = GUICtrlCreateGroup(_MultiLang_GetText("win_config_Option_GroupOption"), 8, 8, 225, 65)
	$L_Option = GUICtrlCreateLabel(_MultiLang_GetText("win_config_Option_GroupOption_Choice"), 16, 23)
	$C_Option = GUICtrlCreateCombo("", 16, 40, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_OptionParam = GUICtrlCreateGroup(_MultiLang_GetText("win_config_Option_GroupParam"), 8, 80, 225, 129)
	$C_OptionParam = GUICtrlCreateCombo("", 16, 104, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	$E_OptionParamDesc = GUICtrlCreateEdit("", 16, 128, 209, 73, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 8, 216, 105, 41)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 126, 216, 105, 41)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$aOption = _XML_ListValue('Profil/Options/Option/Option_Name', "", $oXMLProfil)
	$vOption = ""
	For $vBoucle = 1 To UBound($aOption) - 1
		$vOption = $vOption & $aOption[$vBoucle] & "|"
	Next
	GUICtrlSetData($C_Option, $vOption, "Select an option")

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Option Configuration Canceled", 0, $iLOGPath)
				Return -1
			Case $C_Option
				$vValue_Option = ""
				GUICtrlSetData($C_OptionParam, $vValue_Option)
				$aValue_Option = _XML_ListValue('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option', "", $oXMLProfil)
				_ArrayColInsert($aValue_Option, 1)
				For $vBoucle = 1 To UBound($aValue_Option) - 1
					$aValue_Option[$vBoucle][1] = _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[' & $vBoucle & ']/Name', 1, "", $oXMLProfil)
					$vValue_Option = $vValue_Option & $aValue_Option[$vBoucle][1] & "|"
				Next

				$vNode = _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/NodeName', 0, "", $oXMLProfil)
				$vType = _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Type', 0, "", $oXMLProfil)
				$vDefaultOptionValue = _XML_Read('Profil/Element[@Type="' & $vType & '"]/' & $vNode, 0, "", $oXMLProfil)
				$vDefaultOptionName = _ArraySearch($aValue_Option, $vDefaultOptionValue)
				If $vDefaultOptionName > 0 Then
					$vDefaultOptionName = $aValue_Option[$vDefaultOptionName][1]
				Else
					$vDefaultOptionName = $aValue_Option[1][1]
				EndIf
				GUICtrlSetData($C_OptionParam, $vValue_Option, $vDefaultOptionName)
				GUICtrlSetData($E_OptionParamDesc, _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[@Name="' & GUICtrlRead($C_OptionParam) & '"]/Desc', 1, "", $oXMLProfil))
			Case $C_OptionParam
				GUICtrlSetData($E_OptionParamDesc, _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Source_Value_Option[@Name="' & GUICtrlRead($C_OptionParam) & '"]/Desc', 1, "", $oXMLProfil))
			Case $B_CONFENREG
				$vDefaultOptionName = GUICtrlRead($C_OptionParam)
				If IsArray($aValue_Option) Then
					$vDefaultOptionValue = _ArraySearch($aValue_Option, $vDefaultOptionName)
					If $vDefaultOptionValue > 0 Then
						$vNode = _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/NodeName', 0, "", $oXMLProfil)
						$vDefaultOptionValue = $aValue_Option[$vDefaultOptionValue][0]
;~ 						MsgBox(0, "$vDefaultOptionValue - Node", 'Profil/Element[@Type="' & GUICtrlRead($C_Option) & '"]/' & $vNode & " -> " & $vDefaultOptionValue)
						$vType = _XML_Read('Profil/Options/Option[Option_Name="' & GUICtrlRead($C_Option) & '"]/Type', 0, "", $oXMLProfil)
						_XML_Replace('Profil/Element[@Type="' & $vType & '"]/' & $vNode, $vDefaultOptionValue, 0, "", $oXMLProfil)
						_LOG("Option Configuration Saved", 0, $iLOGPath)
						_LOG("------------------------", 1, $iLOGPath)
						_LOG(GUICtrlRead($C_Option) & " = " & $vDefaultOptionValue, 1, $iLOGPath)

						GUIDelete($F_CONFIG)
						GUISetState(@SW_ENABLE, $F_UniversalScraper)
						WinActivate($F_UniversalScraper)
						Return 1
					EndIf
				EndIf
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Option Configuration Error : No choice made", 0, $iLOGPath)
				Return -1

		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_Options

Func _GUI_Config_Image($oXMLProfil, $iPathMixTmp)
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_PIC_Title"), 474, 122, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Picture = GUICtrlCreateGroup(_MultiLang_GetText("win_config_PIC_GroupPICParam"), 8, 0, 225, 113)
	$L_PicSize = GUICtrlCreateLabel(_MultiLang_GetText("win_config_PIC_GroupPICParam_PicSize"), 16, 16)
	$I_Width = GUICtrlCreateInput("", 16, 36, 89, 21)
	$I_Height = GUICtrlCreateInput("", 136, 36, 89, 21)
	$L_X = GUICtrlCreateLabel("X", 116, 40, 11, 17)
	$L_PicExt = GUICtrlCreateLabel(_MultiLang_GetText("win_config_PIC_GroupPICParam_PicExt"), 16, 76)
	$C_PicExt = GUICtrlCreateCombo("", 136, 72, 89, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_PicExt, "defaut|jpg|png", StringLower(_Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Ext", ""), _XML_Read('Profil/General/Image_Extension', 0, "", $oXMLProfil))))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 72, 105, 41)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 72, 105, 41)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then
		GUICtrlSetData($I_Width, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Width", ""), _XML_Read("Profil/General/Target_Width", 0, $iPathMixTmp & "\config.xml")))
		GUICtrlSetData($I_Height, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Height", ""), _XML_Read("Profil/General/Target_Height", 0, $iPathMixTmp & "\config.xml")))
	Else
		GUICtrlSetData($I_Width, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Width", ""), _XML_Read("Profil/General/Target_Image_Width", 0, "", $oXMLProfil)))
		GUICtrlSetData($I_Height, _Coalesce(IniRead($iINIPath, "LAST_USE", "$vTarget_Image_Height", ""), _XML_Read("Profil/General/Target_Image_Height", 0, "", $oXMLProfil)))
	EndIf

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Image Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_CONFENREG
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Width", GUICtrlRead($I_Width))
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Height", GUICtrlRead($I_Height))
				$vPicExt = GUICtrlRead($C_PicExt)
				If $vPicExt = "defaut" Then $vPicExt = ""
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Ext", $vPicExt)
				_LOG("Image Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vTarget_Image_Width = " & GUICtrlRead($I_Width), 1, $iLOGPath)
				_LOG("$vTarget_Image_Height = " & GUICtrlRead($I_Height), 1, $iLOGPath)
				_LOG("$vTarget_Image_Ext = " & $vPicExt, 1, $iLOGPath)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_Image

Func _GUI_Config_MIX($iMIXPath, $iPathMixTmp)
	Local $vMIXListC = ""
	$aMIXList = _FileListToArrayRec($iMIXPath, "*.zip", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	For $vBoucle = 1 To UBound($aMIXList) - 1
		$vMIXListC = $vMIXListC & "|" & StringTrimRight($aMIXList[$vBoucle], 4)
	Next

	$vMIXLast = _XML_Read("/Profil/Name", 1, $iPathMixTmp & "\config.xml")

	#Region ### START Koda GUI section ### Form=
	$F_MIXIMAGE = GUICreate(_MultiLang_GetText("win_config_mix_Title"), 825, 343, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$C_MIXIMAGE = GUICtrlCreateCombo("", 8, 314, 401, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($C_MIXIMAGE, $vMIXListC, $vMIXLast)
	$B_OK = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Enreg"), 416, 312, 200, 25)
	$B_CANCEL = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Cancel"), 616, 312, 200, 25)
	$P_Empty = GUICtrlCreatePic("", 8, 8, 400, 200)
	$P_Full = GUICtrlCreatePic("", 417, 8, 400, 200)
	$L_Empy = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_empty"), 144, 216, 116, 17, $SS_CENTER)
	$L_Exemple = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_exemple"), 592, 216, 44, 17)
	$E_Description = GUICtrlCreateEdit("", 8, 240, 809, 65, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$vMIXExempleEmptyPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Empty_Exemple", 0, $iPathMixTmp & "\config.xml")
	$vMIXExempleFullPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Full_Exemple", 0, $iPathMixTmp & "\config.xml")
	GUICtrlSetImage($P_Empty, $vMIXExempleEmptyPath)
	GUICtrlSetImage($P_Full, $vMIXExempleFullPath)
	$vDescription = "Author : " & _XML_Read("/Profil/Infos/Author", 0, $iPathMixTmp & "\config.xml")
	$vDescription = $vDescription & @CRLF & "Description :" & @CRLF & StringReplace(_XML_Read("/Profil/Infos/Description", 0, $iPathMixTmp & "\config.xml"), "@CRLF", @CRLF)
	GUICtrlSetData($E_Description, $vDescription)

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CANCEL
				DirRemove($iPathMixTmp, 1)
				DirCreate($iPathMixTmp)
;~ 				_Zip_UnzipAll($iMIXPath & "\" & $vMIXLast & ".zip", $iPathMixTmp, 1)
				$vResult = _Unzip($iMIXPath & "\" & $vMIXLast & ".zip", $iPathMixTmp)
				If $vResult < 0 Then
					Switch $vResult
						Case 1
							_LOG("not a Zip file", 2, $iLOGPath)
						Case 2
							_LOG("Impossible to unzip", 2, $iLOGPath)
						Case Else
							_LOG("Unknown Zip Error (" & @error & ")", 2, $iLOGPath)
					EndSwitch
				EndIf
				IniWrite($iINIPath, "LAST_USE", "$vMixImage", $vMIXLast)
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("MIX Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_OK
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Width", "")
				IniWrite($iINIPath, "LAST_USE", "$vTarget_Image_Height", "")
				IniWrite($iINIPath, "LAST_USE", "$vMixImage", GUICtrlRead($C_MIXIMAGE))
				_LOG("MIX Configuration Saved : " & GUICtrlRead($C_MIXIMAGE), 0, $iLOGPath)
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
			Case $C_MIXIMAGE
				If GUICtrlRead($C_MIXIMAGE) <> _XML_Read("/Profil/Name", 1, $iPathMixTmp & "\config.xml") Then
					DirRemove($iPathMixTmp, 1)
					DirCreate($iPathMixTmp)
;~ 					_Zip_UnzipAll($iMIXPath & "\" & GUICtrlRead($C_MIXIMAGE) & ".zip", $iPathMixTmp, 1)
					$vResult = _Unzip($iMIXPath & "\" & GUICtrlRead($C_MIXIMAGE) & ".zip", $iPathMixTmp)
					If $vResult < 0 Then
						Switch $vResult
							Case 1
								_LOG("not a Zip file", 2, $iLOGPath)
							Case 2
								_LOG("Impossible to unzip", 2, $iLOGPath)
							Case Else
								_LOG("Unknown Zip Error (" & @error & ")", 2, $iLOGPath)
						EndSwitch
					EndIf
					$vMIXExempleEmptyPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Empty_Exemple", 0, $iPathMixTmp & "\config.xml")
					$vMIXExempleFullPath = $iPathMixTmp & "\" & _XML_Read("/Profil/General/Full_Exemple", 0, $iPathMixTmp & "\config.xml")
					GUICtrlSetImage($P_Empty, $vMIXExempleEmptyPath)
					GUICtrlSetImage($P_Full, $vMIXExempleFullPath)
					$vDescription = "Author : " & _XML_Read("/Profil/Infos/Author", 0, $iPathMixTmp & "\config.xml")
					$vDescription = $vDescription & @CRLF & "Description :" & @CRLF & StringReplace(_XML_Read("/Profil/Infos/Description", 0, $iPathMixTmp & "\config.xml"), "@CRLF", @CRLF)
					GUICtrlSetData($E_Description, $vDescription)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_GUI_Config_MIX

Func _GUI_Config_MIX_Download()
	Local $vMIXListC = "", $vLastMIX = "", $aMIXList
	Local $vMIXExempleEmptyPath = $iRessourcesPath & "\Empty_exemple.jpg"
	Local $vMIXExempleFullPath = $iRessourcesPath & "\Full_exemple.jpg"
	Local $vMIXDescriptionPath = $iRessourcesPath & "\Description.txt"

	Local $Result = _DownloadWRetry("https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/MIX%20Repository/_MIXList.txt", $iRessourcesPath & "\_MIXList.txt")
	Switch $Result
		Case -1
			_LOG("Error downloading _MIXList", 2, $iLOGPath)
			Return 0
		Case -2
			_LOG("Time Out downloading _MIXList", 2, $iLOGPath)
			Return 0
	EndSwitch
	_FileReadToArray($Result, $aMIXList)
	For $vBoucle = 1 To UBound($aMIXList) - 1
		$vMIXListC = $vMIXListC & "|" & $aMIXList[$vBoucle]
	Next

	#Region ### START Koda GUI section ### Form=
	$F_MIXIMAGE = GUICreate(_MultiLang_GetText("win_config_mix_Download_Title"), 825, 343, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$C_MIXIMAGE = GUICtrlCreateCombo("", 8, 314, 401, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($C_MIXIMAGE, $vMIXListC)
	$B_OK = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Download_Download"), 416, 312, 200, 25)
	$B_CANCEL = GUICtrlCreateButton(_MultiLang_GetText("win_config_mix_Download_Exit"), 616, 312, 200, 25)
	$P_Empty = GUICtrlCreatePic("", 8, 8, 400, 200)
	$P_Full = GUICtrlCreatePic("", 417, 8, 400, 200)
	$L_Empy = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_empty"), 144, 216, 116, 17, $SS_CENTER)
	$L_Exemple = GUICtrlCreateLabel(_MultiLang_GetText("win_config_mix_exemple"), 592, 216, 44, 17)
	$E_Description = GUICtrlCreateEdit("", 8, 240, 809, 65, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	While 1
		Local $nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CANCEL
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("MIX Download Exit", 0, $iLOGPath)
				Return
			Case $B_OK
				$vMIXURL = 'https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/MIX Repository/' & GUICtrlRead($C_MIXIMAGE) & '.zip'
				_DownloadWRetry($vMIXURL, $iMIXPath & "\" & GUICtrlRead($C_MIXIMAGE) & '.zip')
				_LOG("MIX Download : " & GUICtrlRead($C_MIXIMAGE), 0, $iLOGPath)
				GUIDelete($F_MIXIMAGE)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
			Case $C_MIXIMAGE
				If GUICtrlRead($C_MIXIMAGE) <> $vLastMIX Then
					$vMIXExempleURL = 'https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/MIX Repository/Preview/' & GUICtrlRead($C_MIXIMAGE) & '/'
					$vMIXExempleEmptyPath = _DownloadWRetry($vMIXExempleURL & "Empty_exemple.jpg", $vMIXExempleEmptyPath)
					$vMIXExempleFullPath = _DownloadWRetry($vMIXExempleURL & "Full_exemple.jpg", $vMIXExempleFullPath)
					GUICtrlSetImage($P_Empty, $vMIXExempleEmptyPath)
					GUICtrlSetImage($P_Full, $vMIXExempleFullPath)
					$vMIXDescriptionURL = 'https://raw.githubusercontent.com/Universal-Rom-Tools/Universal-XML-Scraper/master/MIX Repository/Preview/' & GUICtrlRead($C_MIXIMAGE) & '/'
					ConsoleWrite($vMIXDescriptionURL & "Description.txt" & @CRLF)
					$vMIXDescriptionPath = _DownloadWRetry($vMIXDescriptionURL & "Description.txt", $vMIXDescriptionPath)
					$vDescription = StringReplace(FileRead($vMIXDescriptionPath), @LF, @CRLF)
					GUICtrlSetData($E_Description, $vDescription)
					$vLastMIX = GUICtrlRead($C_MIXIMAGE)
				EndIf
		EndSwitch
	WEnd

EndFunc   ;==>_GUI_Config_MIX_Download

Func _GUI_Config_MISC()
	Local $aRechFiles = StringSplit(IniRead($iINIPath, "LAST_USE", "$vRechFiles", "*.*|*.xml;*.txt;*.dv;*.fs;*.xor;*.drv;*.dat;*.cfg;*.nv;*.sav*|"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aScrapeMode = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeModeChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aScrapeSearchMode = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeSearchModeChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $aVerbose = StringSplit(_MultiLang_GetText("win_config_MISC_GroupMISC_VerboseChoice"), '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
	Local $vNbThreadDefault = 0, $vRootPathOnPI = ""

	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_MISC_Title"), 475, 372, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Misc = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupMISC"), 8, 0, 225, 321)
	$L_CountryPref = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_CountryPref"), 16, 15)
	$I_CountryPref = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vCountryPref", ""), 16, 34, 209, 21)
	$L_LangPref = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_LangPref"), 16, 60)
	$I_LangPref = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vLangPref", ""), 16, 80, 209, 21)
	$L_ScrapeMode = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeMode"), 16, 108)
	$C_ScrapeMode = GUICtrlCreateCombo("", 16, 128, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_ScrapeMode, _MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeModeChoice"), $aScrapeMode[IniRead($iINIPath, "LAST_USE", "$vScrape_Mode", 0)])
	$L_ScrapeSearchMode = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeSearchMode"), 16, 156)
	$C_ScrapeSearchMode = GUICtrlCreateCombo("", 16, 176, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_ScrapeSearchMode, _MultiLang_GetText("win_config_MISC_GroupMISC_ScrapeSearchModeChoice"), $aScrapeSearchMode[IniRead($iINIPath, "LAST_USE", "$vScrapeSearchMode", 0)])
	$L_Verbose = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupMISC_Verbose"), 16, 204)
	$C_Verbose = GUICtrlCreateCombo("", 16, 224, 209, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_Verbose, _MultiLang_GetText("win_config_MISC_GroupMISC_VerboseChoice"), $aVerbose[IniRead($iINIPath, "GENERAL", "$vVerbose", 0)])
	$CB_MissingRom_Mode = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_MISC_GroupMISC_MissingMode"), 16, 252)
	$CB_RechSys = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_MISC_GroupMISC_RechSys"), 16, 274)
	$CB_Mirror = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_MISC_GroupMISC_Mirror"), 16, 296)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_ScreenScraper = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupScreenScraper"), 240, 0, 225, 153)
	$L_SSLogin = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Login"), 248, 15)
	$I_SSLogin = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSSLogin", ""), 248, 34, 113, 21)
	$L_SSPassword = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Password"), 248, 61)
	$I_SSPassword = GUICtrlCreateInput(BinaryToString(_Crypt_DecryptData(IniRead($iINIPath, "LAST_USE", "$vSSPassword", ""), "1gdf1g1gf", $CALG_RC4)), 248, 80, 113, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	$L_Thread = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_NbThread"), 376, 15)
	$C_Thread = GUICtrlCreateCombo("1", 376, 34, 81, 21, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUICtrlSetData($C_Thread, "", "")
	$B_SSCheck = GUICtrlCreateButton(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_Check"), 368, 80, 91, 21)
	$B_SSRegister = GUICtrlCreateButton(_MultiLang_GetText("win_config_MISC_GroupScreenScraper_SSRegister"), 248, 112, 211, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_RechFiles = GUICtrlCreateGroup(_MultiLang_GetText("win_config_MISC_GroupRechFiles"), 240, 160, 225, 161)
	$L_Include = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_Include"), 248, 175)
	$I_Include = GUICtrlCreateInput($aRechFiles[0], 248, 194, 209, 21)
	$L_Exclude = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_Exclude"), 248, 220)
	$I_Exclude = GUICtrlCreateInput($aRechFiles[1], 248, 240, 209, 21)
	$L_ExcludeFolder = GUICtrlCreateLabel(_MultiLang_GetText("win_config_MISC_GroupRechFiles_ExcludeFolder"), 248, 268)
	$I_ExcludeFolder = GUICtrlCreateInput($aRechFiles[2], 248, 288, 209, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Experimental = GUICtrlCreateGroup("Experimental", 8, 320, 225, 49)
	$CB_SSHHash = GUICtrlCreateCheckbox("SSH HASH", 16, 340, 89, 17)
	$B_Local_RomPath = GUICtrlCreateButton("Rom Path", 112, 336, 115, 25)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 328, 105, 33)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 328, 105, 33)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($CB_MissingRom_Mode, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vMissingRom_Mode", "0") = "1" Then GUICtrlSetState($CB_MissingRom_Mode, $GUI_CHECKED)
	GUICtrlSetState($CB_RechSys, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vRechSYS", "1") = "1" Then GUICtrlSetState($CB_RechSys, $GUI_CHECKED)
	GUICtrlSetState($CB_Mirror, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vMirror", "0") = "1" Then GUICtrlSetState($CB_Mirror, $GUI_CHECKED)
	GUICtrlSetState($CB_SSHHash, $GUI_UNCHECKED)
	GUICtrlSetState($B_Local_RomPath, $GUI_DISABLE)
	If IniRead($iINIPath, "LAST_USE", "$vHashOnPI", "0") = "1" Then
		GUICtrlSetState($CB_SSHHash, $GUI_CHECKED)
		GUICtrlSetState($B_Local_RomPath, $GUI_ENABLE)
	EndIf

	$vNbThread = IniRead($iINIPath, "LAST_USE", "$vNbThread", "1")
	$vTEMPPathSSCheck = $iScriptPath & "\Ressources\SSCheck.xml"
	$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
	$vSSPassword = GUICtrlRead($I_SSPassword) ;$vSSPassword

	$vTEMPPathSSCheck = _DownloadWRetry($iURLScraper & "api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vTEMPPathSSCheck)
	$vSSParticipation = Number(_XML_Read("/Data/ssuser/uploadsysteme", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadinfos", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/romasso", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadmedia", 0, $vTEMPPathSSCheck))
	$vSSContrib = Number(_XML_Read("/Data/ssuser/contribution", 0, $vTEMPPathSSCheck))
	_LOG("SS Check ssid=" & $vSSLogin & " participation = " & $vSSParticipation & " contribution = " & $vSSContrib, 1, $iLOGPath)
	If $vSSParticipation < 1 Then $vSSParticipation = 0
	Switch $vSSParticipation
		Case 0
			$vNbThreadMax = 1
		Case 1
			$vNbThreadMax = 2
		Case 2 To 49
			$vNbThreadMax = 3
		Case 50 To 199
			$vNbThreadMax = 4
		Case 200 To 499
			$vNbThreadMax = 5
		Case 500 To 749
			$vNbThreadMax = 6
		Case 750 To 999
			$vNbThreadMax = 7
		Case 999 To 9999999
			$vNbThreadMax = 8
		Case Else
			$vNbThreadMax = 1
	EndSwitch
	Switch $vSSContrib
		Case 2
			$vNbThreadMax = $vNbThreadMax + 1
		Case 3 To 999999
			$vNbThreadMax = $vNbThreadMax + 5
	EndSwitch

	$vNbThreadC = ""
	For $vBoucle = 1 To $vNbThreadMax
		$vNbThreadC = $vNbThreadC & $vBoucle & "|"
	Next

	If $vNbThread > $vNbThreadMax Then $vNbThread = $vNbThreadMax
	GUICtrlSetData($C_Thread, $vNbThreadC, $vNbThread)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("MISC Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_Local_RomPath
				$vRootPathOnPI = InputBox("Local Path to the Rom folder", "Enter the local path to the general rom folder from the root (ex : /recalbox/share/roms)", "", "", -1, -1, Default, Default, 0, $F_CONFIG)
			Case $CB_SSHHash
				If _IsChecked($CB_SSHHash) Then
					GUICtrlSetState($B_Local_RomPath, $GUI_ENABLE)
				Else
					GUICtrlSetState($B_Local_RomPath, $GUI_DISABLE)
				EndIf
			Case $B_CONFENREG
				IniWrite($iINIPath, "LAST_USE", "$vNbThread", GUICtrlRead($C_Thread))
				_LOG("SS lvl=" & $vSSParticipation & " Max Thread = " & $vNbThreadMax & " Thread selected = " & GUICtrlRead($C_Thread), 1, $iLOGPath)
				IniWrite($iINIPath, "LAST_USE", "$vScrape_Mode", StringLeft(GUICtrlRead($C_ScrapeMode), 1))
				IniWrite($iINIPath, "LAST_USE", "$vScrapeSearchMode", StringLeft(GUICtrlRead($C_ScrapeSearchMode), 1))
				IniWrite($iINIPath, "GENERAL", "$vVerbose", StringLeft(GUICtrlRead($C_Verbose), 1))
				$iVerboseLVL = StringLeft(GUICtrlRead($C_Verbose), 1)
				IniWrite($iINIPath, "LAST_USE", "$vMissingRom_Mode", 0)
				If _IsChecked($CB_MissingRom_Mode) Then IniWrite($iINIPath, "LAST_USE", "$vMissingRom_Mode", 1)
				IniWrite($iINIPath, "LAST_USE", "$vRechSYS", 0)
				If _IsChecked($CB_RechSys) Then IniWrite($iINIPath, "LAST_USE", "$vRechSYS", 1)

				If _IsChecked($CB_Mirror) Then
					IniWrite($iINIPath, "LAST_USE", "$vMirror", 1)
					$iURLScraper = $iURLMirror
				Else
					IniWrite($iINIPath, "LAST_USE", "$vMirror", 0)
					$iURLScraper = $iURLSS
				EndIf

				If _IsChecked($CB_SSHHash) Then
					IniWrite($iINIPath, "LAST_USE", "$vHashOnPI", 1)
					IniWrite($iINIPath, "LAST_USE", "$vRootPathOnPI", $vRootPathOnPI)
				Else
					IniWrite($iINIPath, "LAST_USE", "$vHashOnPI", 0)
				EndIf

				IniWrite($iINIPath, "LAST_USE", "$vRechFiles", GUICtrlRead($I_Include) & "|" & GUICtrlRead($I_Exclude) & "|" & GUICtrlRead($I_ExcludeFolder))
				$vCountryPref = GUICtrlRead($I_CountryPref) ;$vCountryPref
				IniWrite($iINIPath, "LAST_USE", "$vCountryPref", $vCountryPref)
				$vLangPref = GUICtrlRead($I_LangPref) ;$vLangPref
				IniWrite($iINIPath, "LAST_USE", "$vLangPref", $vLangPref)
				$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
				IniWrite($iINIPath, "LAST_USE", "$vSSLogin", $vSSLogin)
				$vSSPassword = _Crypt_EncryptData(GUICtrlRead($I_SSPassword), "1gdf1g1gf", $CALG_RC4) ;$vSSPassword
				IniWrite($iINIPath, "LAST_USE", "$vSSPassword", $vSSPassword)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return GUICtrlRead($C_Thread)
			Case $B_SSRegister
				_LOG("Launch Internet Browser to Register", 0, $iLOGPath)
				ShellExecute($iURLSS & "membreinscription.php")
			Case $B_SSCheck
				GUICtrlSetData($C_Thread, "", "")
				$vTEMPPathSSCheck = $iScriptPath & "\Ressources\SSCheck.xml"
				$vSSLogin = GUICtrlRead($I_SSLogin) ;$vSSLogin
				$vSSPassword = GUICtrlRead($I_SSPassword) ;$vSSPassword
				_LOG("SS Check ssid=" & $vSSLogin, 3, $iLOGPath)
				$vTEMPPathSSCheck = _DownloadWRetry($iURLScraper & "api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vTEMPPathSSCheck)
				$vSSParticipation = Number(_XML_Read("/Data/ssuser/uploadsysteme", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadinfos", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/romasso", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadmedia", 0, $vTEMPPathSSCheck))
				$vSSContrib = Number(_XML_Read("/Data/ssuser/contribution", 0, $vTEMPPathSSCheck))
				$vSSLevel = Number(_XML_Read("/Data/ssuser/niveau", 0, $vTEMPPathSSCheck))
				_LOG("SS Check ssid=" & $vSSLogin & " participation = " & $vSSParticipation & " contribution = " & $vSSContrib, 1, $iLOGPath)
				If $vSSParticipation < 1 Then $vSSParticipation = 0
				Switch $vSSParticipation
					Case 0
						$vNbThreadMax = 1
					Case 1
						$vNbThreadMax = 2
					Case 2 To 49
						$vNbThreadMax = 3
					Case 50 To 199
						$vNbThreadMax = 4
					Case 200 To 499
						$vNbThreadMax = 5
					Case 500 To 749
						$vNbThreadMax = 6
					Case 750 To 999
						$vNbThreadMax = 7
					Case 999 To 9999999
						$vNbThreadMax = 8
					Case Else
						$vNbThreadMax = 1
				EndSwitch
				Switch $vSSContrib
					Case 2
						$vNbThreadMax = $vNbThreadMax + 1
					Case 3 To 999999
						$vNbThreadMax = $vNbThreadMax + 5
				EndSwitch
				Switch $vSSLevel
					Case 0
						$vNbThreadMax = 1
						_LOG("Not Registered", 0, $iLOGPath)
						MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_NotRegistered"), 10, $F_CONFIG)
					Case 499 To 9999999
						$vNbThreadMax = 99
						_LOG("God Mode", 0, $iLOGPath)
						MsgBox($MB_ICONWARNING, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_GodMode"), 10, $F_CONFIG)
					Case Else
						_LOG("Nb Thread Available : " & $vNbThreadMax, 0, $iLOGPath)
						MsgBox($MB_ICONINFORMATION, _MultiLang_GetText("mess_ssregister_title"), _MultiLang_GetText("mess_ssregister_OK") & " " & $vNbThreadMax & " Threads", 10, $F_CONFIG)
				EndSwitch

				$vNbThreadC = ""
				For $vBoucle = 1 To $vNbThreadMax
					$vNbThreadC = $vNbThreadC & $vBoucle & "|"
				Next
				If $vNbThreadMax > 5 Then
					$vNbThreadDefault = 5
				Else
					$vNbThreadDefault = $vNbThreadMax
				EndIf
				GUICtrlSetData($C_Thread, $vNbThreadC, $vNbThreadDefault)
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_MISC

Func _GUI_Config_LU()
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_LU_Title"), 477, 209, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$G_Scrape = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupScrap"), 8, 0, 225, 201)
	$L_Source_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), 16, 16)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRom"))
	$I_Source_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), 16, 35, 177, 21)
	$B_Source_RomPath = GUICtrlCreateButton("...", 198, 35, 27, 21)
	$L_Target_XMLName = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_XMLName"), 16, 63)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Target_XMLName = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_XMLName", ""), 16, 83, 177, 21)
	$B_Target_XMLName = GUICtrlCreateButton("...", 198, 83, 27, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupScrap_Target_RomPath"), 16, 108)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_RomPath", ""), 16, 128, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_LU_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vSource_ImagePath", ""), 248, 34, 177, 21)
	$B_Source_ImagePath = GUICtrlCreateButton("...", 430, 34, 27, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_LU_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(IniRead($iINIPath, "LAST_USE", "$vTarget_ImagePath", ""), 248, 80, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 128, 105, 73)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 128, 105, 73)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Path Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_Target_XMLName
				$vTarget_XMLName = FileSaveDialog(_MultiLang_GetText("win_config_GroupScrap_PathXML"), GUICtrlRead($I_Source_RomPath), "xml (*.xml)", 18, "gamelist.xml", $F_CONFIG)
				If @error Then $vTarget_XMLName = GUICtrlRead($I_Target_XMLName)
				GUICtrlSetData($I_Target_XMLName, $vTarget_XMLName)
			Case $B_Source_RomPath
				$vSource_RomPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RomPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RomPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RomPath, $vSource_RomPath)
			Case $B_Source_ImagePath
				$vSource_ImagePath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RomPath"), GUICtrlRead($I_Source_RomPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_ImagePath), $F_CONFIG)
				GUICtrlSetData($I_Source_ImagePath, $vSource_ImagePath)
			Case $B_CONFENREG
				$vSource_RomPath = GUICtrlRead($I_Source_RomPath) ;$vSource_RomPath
				If (StringRight($vSource_RomPath, 1) = '\') Then StringTrimRight($vSource_RomPath, 1)
				IniWrite($iINIPath, "LAST_USE", "$vSource_RomPath", $vSource_RomPath)
				$vTarget_XMLName = GUICtrlRead($I_Target_XMLName) ;$vTarget_XMLName
				If StringInStr(FileGetAttrib($vTarget_XMLName), "D") > 0 Then
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), "XMLName must be a file, not a folder", 0, $F_CONFIG)
					_LOG("$vTarget_XMLName is a FOLDER = " & $vTarget_XMLName, 2, $iLOGPath)
					ContinueCase
				EndIf
				IniWrite($iINIPath, "LAST_USE", "$vTarget_XMLName", $vTarget_XMLName)
				$vTarget_RomPath = GUICtrlRead($I_Target_RomPath) ;$vTarget_RomPath
				IniWrite($iINIPath, "LAST_USE", "$vTarget_RomPath", $vTarget_RomPath)
				$vSource_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$vSource_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$vSource_ImagePath", $vSource_ImagePath)
				$vTarget_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$vTarget_ImagePath
				IniWrite($iINIPath, "LAST_USE", "$vTarget_ImagePath", $vTarget_ImagePath)
				_LOG("Path Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1, $iLOGPath)
				_LOG("$vSource_RomPath = " & $vSource_RomPath, 1, $iLOGPath)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1, $iLOGPath)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1, $iLOGPath)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1, $iLOGPath)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_LU

Func _GUI_Config_autoconf($oXMLProfil)
	#Region ### START Koda GUI section ### Form=
	$F_CONFIG = GUICreate(_MultiLang_GetText("win_config_autoconf_Title"), 477, 209, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$CB_Autoconf = GUICtrlCreateCheckbox(_MultiLang_GetText("win_config_autoconf_Use"), 8, 8, 225, 33, BitOR($GUI_SS_DEFAULT_CHECKBOX, $BS_CENTER, $BS_VCENTER))
	$G_Scrape = GUICtrlCreateGroup(_MultiLang_GetText("win_config_autoconf_GroupScrap"), 8, 40, 225, 161)
	$L_Source_RootPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Source_RootPath"), 16, 56)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Source_RootPath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil), 16, 75, 177, 21)
	$B_Source_RootPath = GUICtrlCreateButton("...", 198, 75, 27, 21)
	$L_Target_XMLName = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Target_XMLName"), 16, 103)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathXML"))
	$I_Target_XMLName = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_XMLName", 0, "", $oXMLProfil), 16, 123, 177, 21)
	$L_Target_RomPath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupScrap_Target_RomPath"), 16, 153)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupScrap_PathRomSub"))
	$I_Target_RomPath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_RomPath", 0, "", $oXMLProfil), 16, 173, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$G_Image = GUICtrlCreateGroup(_MultiLang_GetText("win_config_autoconf_GroupImage"), 240, 0, 225, 113)
	$L_Source_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Source_ImagePath"), 248, 15)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImage"))
	$I_Source_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Source_ImagePath", 0, "", $oXMLProfil), 248, 34, 177, 21)
	$L_Target_ImagePath = GUICtrlCreateLabel(_MultiLang_GetText("win_config_autoconf_GroupImage_Target_ImagePath"), 248, 60)
	GUICtrlSetTip(-1, _MultiLang_GetText("tips_config_GroupImage_PathImageSub"))
	$I_Target_ImagePath = GUICtrlCreateInput(_XML_Read("Profil/AutoConf/Target_ImagePath", 0, "", $oXMLProfil), 248, 80, 177, 21)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 240, 128, 105, 73)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 358, 128, 105, 73)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	GUICtrlSetState($CB_Autoconf, $GUI_UNCHECKED)
	If IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", 0) = 1 Then GUICtrlSetState($CB_Autoconf, $GUI_CHECKED)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("Path Configuration Canceled", 0, $iLOGPath)
				Return
			Case $B_Source_RootPath
				$vSource_RootPath = FileSelectFolder(_MultiLang_GetText("win_config_LU_GroupScrap_Source_RootPath"), GUICtrlRead($I_Source_RootPath), $FSF_CREATEBUTTON, GUICtrlRead($I_Source_RootPath), $F_CONFIG)
				GUICtrlSetData($I_Source_RootPath, $vSource_RootPath)
			Case $B_CONFENREG
				$vSource_RootPath = GUICtrlRead($I_Source_RootPath) ;$vSource_RootPath
				If (StringRight($vSource_RootPath, 1) = '\') Then StringTrimRight($vSource_RootPath, 1)
				_XML_Replace("Profil/AutoConf/Source_RootPath", $vSource_RootPath, 0, "", $oXMLProfil)
				$vTarget_XMLName = GUICtrlRead($I_Target_XMLName) ;$vTarget_XMLName
				If StringInStr(FileGetAttrib($vTarget_XMLName), "D") > 0 Then
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), "XMLName must be a file, not a folder", 0, $F_CONFIG)
					_LOG("$vTarget_XMLName is a FOLDER = " & $vTarget_XMLName, 2, $iLOGPath)
					ContinueCase
				EndIf
				_XML_Replace("Profil/AutoConf/Target_XMLName", $vTarget_XMLName, 0, "", $oXMLProfil)
				$vTarget_RomPath = GUICtrlRead($I_Target_RomPath) ;$vTarget_RomPath
				_XML_Replace("Profil/AutoConf/Target_RomPath", $vTarget_RomPath, 0, "", $oXMLProfil)
				$vSource_ImagePath = GUICtrlRead($I_Source_ImagePath) ;$vSource_ImagePath
				_XML_Replace("Profil/AutoConf/Source_ImagePath", $vSource_ImagePath, 0, "", $oXMLProfil)
				$vTarget_ImagePath = GUICtrlRead($I_Target_ImagePath) ;$vTarget_ImagePath
				_XML_Replace("Profil/AutoConf/Target_ImagePath", $vTarget_ImagePath, 0, "", $oXMLProfil)
				If _IsChecked($CB_Autoconf) Then
					$vAutoconf_Use = 1
				Else
					$vAutoconf_Use = 0
				EndIf

				IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", $vAutoconf_Use)
				_LOG("AutoConf Path Configuration Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("$vSource_RootPath = " & $vSource_RootPath, 1, $iLOGPath)
				_LOG("$vTarget_XMLName = " & $vTarget_XMLName, 1, $iLOGPath)
				_LOG("$vTarget_RomPath = " & $vTarget_RomPath, 1, $iLOGPath)
				_LOG("$vSource_ImagePath = " & $vSource_ImagePath, 1, $iLOGPath)
				_LOG("$vTarget_ImagePath = " & $vTarget_ImagePath, 1, $iLOGPath)
				GUIDelete($F_CONFIG)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return 1
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_autoconf

Func _GUI_Config_SSHParameter($oXMLProfil)
	#Region ### START Koda GUI section ### Form=
	$F_SSH = GUICreate("SSH", 234, 130, -1, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$B_CONFENREG = GUICtrlCreateButton(_MultiLang_GetText("win_config_Enreg"), 8, 80, 105, 41)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 121, 80, 105, 41)
	$L_Host = GUICtrlCreateLabel("Host", 16, 10)
	$I_Host = GUICtrlCreateInput(_XML_Read('Profil/Plink/Ip', 0, "", $oXMLProfil), 96, 8, 129, 21)
	$L_Login = GUICtrlCreateLabel("Login", 16, 34)
	$I_Login = GUICtrlCreateInput(_XML_Read('Profil/Plink/Root', 0, "", $oXMLProfil), 96, 32, 129, 21)
	$L_Pwd = GUICtrlCreateLabel("Password", 16, 58)
	$I_Pwd = GUICtrlCreateInput(_XML_Read('Profil/Plink/Pswd', 0, "", $oXMLProfil), 96, 56, 129, 21)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_SSH)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				_LOG("SSH Parameter Canceled", 0, $iLOGPath)
				Return 0
			Case $B_CONFENREG
				_XML_Replace("Profil/Plink/Ip", GUICtrlRead($I_Host), 0, "", $oXMLProfil)
				_XML_Replace("Profil/Plink/Root", GUICtrlRead($I_Login), 0, "", $oXMLProfil)
				_XML_Replace("Profil/Plink/Pswd", GUICtrlRead($I_Pwd), 0, "", $oXMLProfil)

				_LOG("SSH Parameter Saved", 0, $iLOGPath)
				_LOG("------------------------", 1, $iLOGPath)
				_LOG("Host = " & GUICtrlRead($I_Host), 1, $iLOGPath)
				_LOG("Login = " & GUICtrlRead($I_Login), 1, $iLOGPath)
				_LOG("Password = " & GUICtrlRead($I_Pwd), 1, $iLOGPath)
				GUIDelete($F_SSH)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return 1
		EndSwitch
	WEnd
EndFunc   ;==>_GUI_Config_SSHParameter

Func _GUI_Refresh($oXMLProfil = -1, $ScrapIP = 0, $vScrapeOK = 0) ;Refresh GUI
	If $oXMLProfil <> -1 Then
		If $ScrapIP = 0 Then
			; GUI Picture
			Local $vSourcePicturePath = _XML_Read("Profil/General/Source_Image", 0, "", $oXMLProfil)
			If $vSourcePicturePath < 0 Then
				$vSourcePicturePath = $iScriptPath & "\ProfilsFiles\Ressources\empty.jpg"
			Else
				$vSourcePicturePath = $iScriptPath & "\ProfilsFiles\Ressources\" & $vSourcePicturePath
			EndIf

			GUICtrlSetImage($P_BACKGROUND, $vSourcePicturePath)

			;Overall Menu
			Local $vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
			$vSystem = $vSystem[UBound($vSystem) - 1]

			GUICtrlSetState($MC_Miximage, $GUI_DISABLE)
			If StringLower(_XML_Read('Profil/General/Mix', 0, "", $oXMLProfil)) = "true" Then GUICtrlSetState($MC_Miximage, $GUI_ENABLE)

			GUICtrlSetState($MF, $GUI_ENABLE)
			GUICtrlSetData($MF, _MultiLang_GetText("mnu_file"))
			GUICtrlSetData($MF_Exit, _MultiLang_GetText("mnu_file_exit"))

			GUICtrlSetState($MC, $GUI_ENABLE)
			GUICtrlSetData($MC, _MultiLang_GetText("mnu_cfg"))
			GUICtrlSetData($MC_Wizard, _MultiLang_GetText("mnu_cfg_Wizard"))
			GUICtrlSetData($MC_Config_LU, _MultiLang_GetText("mnu_cfg_config_LU"))
			GUICtrlSetData($MC_config_autoconf, _MultiLang_GetText("mnu_cfg_config_autoconf"))
			GUICtrlSetData($MC_config_Option, _MultiLang_GetText("mnu_cfg_config_Option"))
			GUICtrlSetData($MC_config_PIC, _MultiLang_GetText("mnu_cfg_config_PIC"))
			GUICtrlSetData($MC_config_MISC, _MultiLang_GetText("mnu_cfg_config_MISC"))
			GUICtrlSetData($MC_MixDownload, _MultiLang_GetText("mnu_cfg_download_miximage"))

			GUICtrlSetData($MC_Profil, _MultiLang_GetText("mnu_cfg_profil"))
			GUICtrlSetData($MC_Miximage, _MultiLang_GetText("mnu_cfg_miximage"))
			GUICtrlSetData($MC_Langue, _MultiLang_GetText("mnu_cfg_langue"))

			GUICtrlSetState($MS, $GUI_ENABLE)
			GUICtrlSetData($MS, _MultiLang_GetText("mnu_scrape"))
			GUICtrlSetData($MS_AutoConfig, _MultiLang_GetText("mnu_scrape_autoconf"))
			GUICtrlSetData($MS_Scrape, _MultiLang_GetText("mnu_scrape_solo") & " - " & $vSystem)
			GUICtrlSetData($MS_FullScrape, _MultiLang_GetText("mnu_scrape_fullscrape"))

			GUICtrlSetData($MP_Parameter, _MultiLang_GetText("mnu_ssh_Parameter"))

			;SSH Menu
			If _XML_NodeExists($oXMLProfil, "Profil/Plink/Ip") = $XML_RET_FAILURE Then
				_LOG("SSH Disable", 1, $iLOGPath)
				GUICtrlSetState($MP, $GUI_DISABLE)
				If IsArray($MP_) Then
					For $vBoucle = 1 To UBound($MP_) - 1
						GUICtrlDelete($MP_[$vBoucle])
					Next
				EndIf

			Else
				_LOG("SSH Enable", 1, $iLOGPath)
				GUICtrlSetState($MP, $GUI_ENABLE)
				GUICtrlSetData($MP, _MultiLang_GetText("mnu_ssh"))
				If IsArray($MP_) Then
					For $vBoucle = 1 To UBound($MP_) - 1
						GUICtrlDelete($MP_[$vBoucle])
					Next
				EndIf
				$aPlink_Command = _XML_ListNode("Profil/Plink/Command", "", $oXMLProfil)
				If IsArray($aPlink_Command) Then
					Dim $MP_[UBound($aPlink_Command)]
					For $vBoucle = 1 To UBound($aPlink_Command) - 1
						$MP_[$vBoucle] = GUICtrlCreateMenuItem(_MultiLang_GetText("mnu_ssh_" & $aPlink_Command[$vBoucle][0]), $MP)
					Next
				EndIf
			EndIf

			GUICtrlSetState($MH, $GUI_ENABLE)
			GUICtrlSetData($MH, _MultiLang_GetText("mnu_help"))
			GUICtrlSetData($MH_About, _MultiLang_GetText("mnu_help_about"))
			GUICtrlSetData($MH_Help, _MultiLang_GetText("mnu_help_wiki"))
			GUICtrlSetData($MH_Support, _MultiLang_GetText("mnu_help_support"))
			GUICtrlSetData($MH_Link, _MultiLang_GetText("mnu_help_link"))

			GUICtrlSetData($B_SCRAPE, _MultiLang_GetText("scrap_button"))
			_GUICtrlStatusBar_SetText($L_SCRAPE, "")

			_LOG("GUI Refresh", 1, $iLOGPath)

		Else
			_LOG("GUI Desactivated (Scrape in progress)", 1, $iLOGPath)
			GUICtrlSetState($MF, $GUI_DISABLE)
			GUICtrlSetState($MC, $GUI_DISABLE)
			GUICtrlSetState($MS, $GUI_DISABLE)
			GUICtrlSetState($MP, $GUI_DISABLE)
			GUICtrlSetState($MH, $GUI_DISABLE)
			GUICtrlSetData($B_SCRAPE, _MultiLang_GetText("scrap_cancel_button"))
		EndIf
	EndIf
	Return
EndFunc   ;==>_GUI_Refresh

Func _GUI_Update($iChangelogPath, $F_UniversalScraper = "")
	Local $fChangelog = StringReplace(FileRead($iChangelogPath), @LF, @CRLF)

	#Region ### START Koda GUI section ### Form=
	$F_Update = GUICreate(_MultiLang_GetText("mess_update_Title"), 605, 381, 192, 124)
	$P_Update = GUICtrlCreatePic($iScriptPath & "\Ressources\UXS.jpg", 0, 0, 604, 380)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$E_Changelog = GUICtrlCreateEdit($fChangelog, 8, 8, 585, 273, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)
	$B_UPDATE = GUICtrlCreateButton(_MultiLang_GetText("mess_update_Question"), 8, 296, 275, 25)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 320, 296, 275, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	If IsHWnd($F_UniversalScraper) Then GUISetState(@SW_DISABLE, $F_UniversalScraper)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_CONFANNUL
				GUIDelete($F_Update)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
			Case $B_UPDATE
				GUIDelete($F_Update)
				_LOG("Open GitHub Release Webpage", 0, $iLOGPath)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				ShellExecute("https://github.com/Universal-Rom-Tools/Universal-XML-Scraper/releases")
				Return
		EndSwitch
	WEnd

EndFunc   ;==>_GUI_Update

Func _GUI_Log($F_UniversalScraper = "")
	_LOG("When you clic 'CANCEL' Log will be ready to be paste in http://pastebin.com/", 0, $iLOGPath)
	Local $sDrive, $sDir, $sFileName, $sExtension, $vLogList = ""
	Local $flog = StringReplace(FileRead($iLOGPath), @LF, @CRLF)
	Local $aPathSplit = _PathSplit($iLOGPath, $sDrive, $sDir, $sFileName, $sExtension)
	$aLogList = _FileListToArrayRec($sDrive & $sDir, "*", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
	For $vBoucle = 1 To UBound($aLogList) - 1
		$vLogList = $vLogList & $aLogList[$vBoucle] & "|"
	Next

	#Region ### START Koda GUI section ### Form=
	$F_Log = GUICreate("Log", 605, 381, 192, 124)
	$P_Log = GUICtrlCreatePic($iScriptPath & "\Ressources\UXS.jpg", 0, 0, 604, 380)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$E_log = GUICtrlCreateEdit($flog, 8, 8, 585, 273, $ES_AUTOVSCROLL + $WS_VSCROLL + $ES_READONLY)
	$C_Log = GUICtrlCreateCombo("", 8, 296, 275, 25)
	GUICtrlSetData($C_Log, $vLogList, $iLOGPath)
	$B_CONFANNUL = GUICtrlCreateButton(_MultiLang_GetText("win_config_Cancel"), 320, 296, 275, 25)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	If IsHWnd($F_UniversalScraper) Then GUISetState(@SW_DISABLE, $F_UniversalScraper)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($F_Log)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return
			Case $C_Log
				Local $flog = StringReplace(FileRead(GUICtrlRead($C_Log)), @LF, @CRLF)
				GUICtrlSetData($E_log, $flog)
			Case $B_CONFANNUL
				GUIDelete($F_Log)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				ClipPut($flog)
				Return
		EndSwitch
	WEnd

EndFunc   ;==>_GUI_Log

Func _Check_autoconf($oXMLProfil)

	$vAutoconf_Use = IniRead($iINIPath, "LAST_USE", "$vAutoconf_Use", "-1")
	If $vAutoconf_Use = "-1" Then
		If MsgBox(BitOR($MB_ICONQUESTION, $MB_YESNO), _MultiLang_GetText("mess_autoconf_ask_Title"), _MultiLang_GetText("mess_autoconf_ask_Question")) = $IDYES Then
			$vAutoconf_Use = 1
		Else
			$vAutoconf_Use = 0
		EndIf
	EndIf
	IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", $vAutoconf_Use)

	Local $vSource_RootPath = _XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil)
	Local $vTarget_XMLName = _XML_Read("Profil/AutoConf/Target_XMLName", 0, "", $oXMLProfil)
	Local $vTarget_RomPath = _XML_Read("Profil/AutoConf/Target_RomPath", 0, "", $oXMLProfil)
	Local $vSource_ImagePath = _XML_Read("Profil/AutoConf/Source_ImagePath", 0, "", $oXMLProfil)
	Local $vTarget_ImagePath = _XML_Read("Profil/AutoConf/Target_ImagePath", 0, "", $oXMLProfil)

	If $vSource_RootPath = "" Or $vAutoconf_Use = 0 Then
		GUICtrlSetState($MS_AutoConfig, $GUI_DISABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_DISABLE)
		Return -1
	EndIf

	If IsHWnd($F_UniversalScraper) Then GUISetState(@SW_DISABLE, $F_UniversalScraper)
	SplashTextOn(_MultiLang_GetText("mnu_edit_autoconf"), _MultiLang_GetText("mess_autoconf"), 400, 50)
	If StringRight($vSource_RootPath, 1) = '\' Then $vSource_RootPath = StringTrimRight($vSource_RootPath, 1)
	$aDIRList = _FileListToArrayRec($vSource_RootPath, "*", $FLTAR_FOLDERS, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_RELPATH)
	If IsArray($aDIRList) Then
		If IsArray($MS_AutoConfigItem) Then
			For $B_ArrayDelete = 1 To UBound($MS_AutoConfigItem) - 1
				GUICtrlSetState($MS_AutoConfigItem[$B_ArrayDelete], $GUI_UNCHECKED)
				GUICtrlDelete($MS_AutoConfigItem[$B_ArrayDelete])
			Next
		EndIf

		GUICtrlSetState($MS_AutoConfig, $GUI_ENABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_ENABLE)
		Dim $MS_AutoConfigItem[UBound($aDIRList)]
		For $vBoucle = 1 To 5
			_ArrayColInsert($aDIRList, $vBoucle)
		Next
		For $vBoucle = 1 To UBound($aDIRList) - 1
			$aDIRList[$vBoucle][1] = $vSource_RootPath & "\" & $aDIRList[$vBoucle][0]
			$aDIRList[$vBoucle][2] = _ReplacePath($vTarget_RomPath, $aDIRList, $vBoucle, $vSource_RootPath)
			$aDIRList[$vBoucle][3] = _ReplacePath($vTarget_XMLName, $aDIRList, $vBoucle, $vSource_RootPath)
			$aDIRList[$vBoucle][4] = _ReplacePath($vSource_ImagePath, $aDIRList, $vBoucle, $vSource_RootPath)
			$aDIRList[$vBoucle][5] = _ReplacePath($vTarget_ImagePath, $aDIRList, $vBoucle, $vSource_RootPath)
			DirCreate($aDIRList[$vBoucle][4])
			If Not FileExists($aDIRList[$vBoucle][3]) Then _FileCreate($aDIRList[$vBoucle][3])
			$MS_AutoConfigItem[$vBoucle] = GUICtrlCreateMenuItem($aDIRList[$vBoucle][0], $MS_AutoConfig)
		Next
;~ 		_ArrayDisplay($aDIRList, "$aDIRList")
		GUISetState(@SW_ENABLE, $F_UniversalScraper)
		WinActivate($F_UniversalScraper)
		SplashOff()
		Return $aDIRList
	Else
		GUICtrlSetState($MS_AutoConfig, $GUI_DISABLE)
		GUICtrlSetState($MS_FullScrape, $GUI_DISABLE)
		GUISetState(@SW_ENABLE, $F_UniversalScraper)
		WinActivate($F_UniversalScraper)
		SplashOff()
		MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_autoconfPathRom"))
		IniWrite($iINIPath, "LAST_USE", "$vAutoconf_Use", 0)
		Return -1
	EndIf
EndFunc   ;==>_Check_autoconf

Func _ReplacePath($vPath, $aDIRList, $vBoucle, $vSource_RootPath)
	Local $sDrive, $sDir, $sFileName, $sExtension
	Local $aPathSplit = _PathSplit($aDIRList[$vBoucle][1], $sDrive, $sDir, $sFileName, $sExtension)
	Local $vPathOld = $vPath
	$vPath = StringReplace($vPath, "%host%", $sDrive)
	$vPath = StringReplace($vPath, "%SystemDir%", $aDIRList[$vBoucle][1])
	$vPath = StringReplace($vPath, "%System%", $aDIRList[$vBoucle][0])
	$vPath = StringReplace($vPath, "%Source_RootPath%", $vSource_RootPath)
	_LOG("ReplacePath : " & $vPathOld & " In : " & $vPath, 1, $iLOGPath)
	Return $vPath
EndFunc   ;==>_ReplacePath

Func _Check_Cancel()
	If GUIGetMsg() = $B_SCRAPE Or $vScrapeCancelled = 1 Then
		_LOG("Scrape Cancelled", 0, $iLOGPath)
		$vScrapeCancelled = 1
		Return False
	Else
		$vScrapeCancelled = 0
		Return True
	EndIf
EndFunc   ;==>_Check_Cancel

Func _RomList_Create($aConfig, $vFullScrape = 0, $oXMLProfil = "")
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit
	$vRechFiles = IniRead($iINIPath, "LAST_USE", "$vRechFiles ", "*.*z*")
	Local $vPicDir = StringSplit($aConfig[3], "\")
	$vPipeCount = StringSplit($vRechFiles, "|")
	If $vPipeCount[0] = 2 Then $vRechFiles = $vRechFiles & "|"

	If StringRight($vRechFiles, 1) = "|" Then
		$vRechFiles = $vRechFiles & $vPicDir[UBound($vPicDir) - 1]
	Else
		$vRechFiles = $vRechFiles & ";" & $vPicDir[UBound($vPicDir) - 1]
	EndIf
	_LOG("Listing ROM (" & $vRechFiles & ")", 1, $iLOGPath)
	$aRomList = _FileListToArrayRec($aConfig[1], $vRechFiles, $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT)

	If @error = 1 Then
		_LOG("Invalid Rom Path : " & $aConfig[1], 2, $iLOGPath)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_PathRom"))
		Return -1
	EndIf
	If @error = 4 Then
		_LOG("No rom in " & $aConfig[1], 2, $iLOGPath)
		If $vFullScrape = 0 Then MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_FillRomList"))
		Return -1
	EndIf

	For $vBoucle = 1 To 12
		_ArrayColInsert($aRomList, $vBoucle)
	Next

	_LOG(UBound($aRomList) - 1 & " Rom(s) found", 0, $iLOGPath)

	For $vBoucle = 1 To UBound($aRomList) - 1
		$aRomList[$vBoucle][1] = $aConfig[1] & "\" & $aRomList[$vBoucle][0] ; Full Path
		$aPathSplit = _PathSplit($aRomList[$vBoucle][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aRomList[$vBoucle][2] = $aPathSplit[3] ; Filename (without extension)
		$aRomList[$vBoucle][9] = -1 ;Rom Found
	Next

	$vSpecial = _XML_Read("Profil/General/Special", 0, "", $oXMLProfil)
	Switch StringLower($vSpecial)
		Case "folder"
			ConsoleWrite("!" & $vSpecial & @CRLF)
			For $vBoucle = 1 To UBound($aRomList) - 1
				$aPathSplit = StringSplit($aRomList[$vBoucle][1], '\')
				_ArrayAdd($aRomList, $aPathSplit[UBound($aPathSplit) - 2] & '|' & $aRomList[$vBoucle][1] & '|' & $aRomList[$vBoucle][2] & '|4||||||-1')
			Next
	EndSwitch

;~ 	_ArrayDisplay($aRomList, "$aRomList")

	Return $aRomList
EndFunc   ;==>_RomList_Create

Func _Check_Rom2Scrape($aRomList, $vNoRom, $aXMLRomList, $vTarget_RomPath, $vScrape_Mode, $aExtToHide = "", $aValueToHide = "")
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit

	If $aRomList[$vNoRom][3] > 0 Then Return $aRomList

	If IsArray($aExtToHide) Then
		$aPathSplit = _PathSplit($aRomList[$vNoRom][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aFindDuplicate = _ArrayFindAll($aRomList, $sFileName, 0, 0, 0, 0, 2)
		For $vBoucle = 1 To UBound($aExtToHide) - 1
			If StringLeft($aExtToHide[$vBoucle], 1) <> "." Then $aExtToHide[$vBoucle] = "." & $aExtToHide[$vBoucle]
			If UBound($aFindDuplicate) > 1 And $sExtension = $aExtToHide[$vBoucle] Then
				$aRomList[$vNoRom][3] = 2
				_LOG($aRomList[$vNoRom][2] & " To Hide", 1, $iLOGPath)
				Return $aRomList
			EndIf
		Next
	EndIf

	If IsArray($aValueToHide) Then
		For $vBoucle = 1 To UBound($aValueToHide) - 1
			If StringInStr($aRomList[$vNoRom][0], $aValueToHide[$vBoucle]) Then
				$aRomList[$vNoRom][3] = 3
				_LOG($aRomList[$vNoRom][2] & " To Hide", 1, $iLOGPath)
				Return $aRomList
			EndIf
		Next
	EndIf

	Switch $vScrape_Mode
		Case 0
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=0)", 1, $iLOGPath)
			If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 1
			Return $aRomList
		Case 2
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=2)", 1, $iLOGPath)
			If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 1
			Return $aRomList
		Case Else
			If IsArray($aXMLRomList) Then
				If _ArraySearch($aXMLRomList, $vTarget_RomPath & StringReplace($aRomList[$vNoRom][0], "\", "/"), 0, 0, 0, 0, 1, 2) <> -1 Then
					_LOG($aRomList[$vNoRom][2] & " NOT Scraped ($vScrape_Mode=1)", 1, $iLOGPath)
					If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 0
					Return $aRomList
				EndIf
			EndIf
			_LOG($aRomList[$vNoRom][2] & " To Scrape ($vScrape_Mode=1)", 1, $iLOGPath)
			If $aRomList[$vNoRom][3] < 2 Then $aRomList[$vNoRom][3] = 1
			Return $aRomList
	EndSwitch
	Return $aRomList
EndFunc   ;==>_Check_Rom2Scrape

Func _CalcHash($aRomList, $vNoRom, $oXMLProfil)
;~ 	_ArrayDisplay($aRomList, "$aRomList")
	Local $TimerHashCRC = "N/A", $TimerHashMD5 = "N/A", $TimerHashSHA1 = "N/A"
	If Not _Check_Cancel() Then Return $aRomList
	$TimerHash = TimerInit()
	_GUICtrlStatusBar_SetText($L_SCRAPE, "Hashing " & $aRomList[$vNoRom][2])
	$aRomList[$vNoRom][4] = FileGetSize($aRomList[$vNoRom][1])
	If IniRead($iINIPath, "LAST_USE", "$vHashOnPI", "0") = "1" Then
		$TimerHashMD5 = TimerInit()
		$vSysName = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
		$vSysName = $vSysName[UBound($vSysName) - 1]
		$vRootPathOnPI = IniRead($iINIPath, "LAST_USE", "$vRootPathOnPI", "/recalbox/share/roms")
		$vPathtoHash = $vRootPathOnPI & "/" & $vSysName & "/" & StringReplace($aRomList[$vNoRom][0], "\", "/")
		$vPlinkCommand = '"' & "md5sum " & StringReplace(StringReplace($vPathtoHash, " ", "\ "), "'", "\'") & '"'
		_LOG("$vPlinkCommand : " & $vPlinkCommand, 1, $iLOGPath)
		$aPlinkReturn = StringSplit(_Plink($oXMLProfil, $vPlinkCommand, 1), " ", $STR_NOCOUNT)
		$aRomList[$vNoRom][6] = $aPlinkReturn[0]
		$TimerHashMD5 = Round((TimerDiff($TimerHashMD5) / 1000), 2)
		_LOG("Rom Info (" & $aRomList[$vNoRom][0] & ") Hash in " & Round((TimerDiff($TimerHash) / 1000), 2) & "s", 0, $iLOGPath)
		_LOG("MD5 : " & $aRomList[$vNoRom][6] & "(" & $TimerHashMD5 & "s)", 1, $iLOGPath)
		Return $aRomList
	EndIf

	If IniRead($iINIPath, "LAST_USE", "$vScrapeSearchMode", "0") = "2" Then
		_LOG("QUICK Mode ", 1, $iLOGPath)
	Else
		$TimerHashMD5 = TimerInit()
		$aRomList[$vNoRom][6] = _MD5ForFile($aRomList[$vNoRom][1])
		$TimerHashMD5 = Round((TimerDiff($TimerHashMD5) / 1000), 2)
		If Int(($aRomList[$vNoRom][4] / 1048576)) < 500 Then
			$TimerHashSHA1 = TimerInit()
			$aRomList[$vNoRom][7] = _SHA1ForFile($aRomList[$vNoRom][1])
			$TimerHashSHA1 = Round((TimerDiff($TimerHashSHA1) / 1000), 2)
		EndIf
		If Int(($aRomList[$vNoRom][4] / 1048576)) < 50 Then
			$TimerHashCRC = TimerInit()
			$aRomList[$vNoRom][5] = StringRight(_CRC32ForFile($aRomList[$vNoRom][1]), 8)
			$TimerHashCRC = Round((TimerDiff($TimerHashCRC) / 1000), 2)
		EndIf
	EndIf
	_LOG("Rom Info (" & $aRomList[$vNoRom][0] & ") Hash in " & Round((TimerDiff($TimerHash) / 1000), 2) & "s", 0, $iLOGPath)
	_LOG("Size : " & $aRomList[$vNoRom][4], 1, $iLOGPath)
	_LOG("CRC32 : " & $aRomList[$vNoRom][5] & "(" & $TimerHashCRC & "s)", 1, $iLOGPath)
	_LOG("MD5 : " & $aRomList[$vNoRom][6] & "(" & $TimerHashMD5 & "s)", 1, $iLOGPath)
	_LOG("SHA1 : " & $aRomList[$vNoRom][7] & "(" & $TimerHashSHA1 & "s)", 1, $iLOGPath)
	Return $aRomList
EndFunc   ;==>_CalcHash

Func _XMLSystem_Create($vSSLogin = "", $vSSPassword = "")
	Local $oXMLSystem, $vXMLSystemPath = $iScriptPath & "\Ressources\systemlist.xml"
	$vXMLSystemPath = _DownloadWRetry($iURLScraper & "api/systemesListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vXMLSystemPath)
	If FileGetSize($vXMLSystemPath) < 100 Then
		$iURLScraper = $iURLSS
		IniWrite($iINIPath, "LAST_USE", "$vMirror", 0)
		$vXMLSystemPath = _DownloadWRetry($iURLScraper & "api/systemesListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vXMLSystemPath)
	EndIf
	Switch $vXMLSystemPath
		Case -1
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_Connection"))
			Return -1
		Case -2
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_TimeOut"))
			Return -1
		Case Else
			$oXMLSystem = _XML_Open($vXMLSystemPath)
			If $oXMLSystem = -1 Then
				MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_SystemList"))
				Return -1
			Else
				_LOG("systemlist.xml Opened", 1, $iLOGPath)
				Return $oXMLSystem
			EndIf
	EndSwitch
EndFunc   ;==>_XMLSystem_Create

Func _XMLCountry_Create($vSSLogin = "", $vSSPassword = "")
	Local $oXMLCountry, $vXMLCountryPath = $iScriptPath & "\Ressources\Countrylist.xml"
	$vXMLCountryPath = _DownloadWRetry($iURLScraper & "api/regionsListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vXMLCountryPath)
	If FileGetSize($vXMLCountryPath) < 100 Then
		$iURLScraper = $iURLSS
		IniWrite($iINIPath, "LAST_USE", "$vMirror", 0)
		$vXMLCountryPath = _DownloadWRetry($iURLScraper & "api/regionsListe.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=XML&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword, $vXMLCountryPath)
	EndIf
	Switch $vXMLCountryPath
		Case -1
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_Connection"))
			Return -1
		Case -2
			MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_TimeOut"))
			Return -1
		Case Else
			$oXMLCountry = _XML_Open($vXMLCountryPath)
			If $oXMLCountry = -1 Then
				MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_SystemList"))
				Return -1
			Else
				_LOG("Countrylist.xml Opened", 1, $iLOGPath)
				Return $oXMLCountry
			EndIf
	EndSwitch
EndFunc   ;==>_XMLCountry_Create

Func _DownloadROMXML($aRomList, $vBoucle, $vSystemID, $vSSLogin = "", $vSSPassword = "", $vScrapeSearchMode = 0)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = "", $aPathSplit
	FileDelete($aRomList[$vBoucle][8])
	If Not _Check_Cancel() Then Return $aRomList
	Local $vXMLRom = $iTEMPPath & "\" & StringRegExpReplace($aRomList[$vBoucle][2], '[\[\]/\|\:\?"\*\\<>]', "") & ".xml"
	$aPathSplit = _PathSplit($aRomList[$vBoucle][0], $sDrive, $sDir, $sFileName, $sExtension)
	$vRomName = _URIEncode($sFileName & $sExtension)
	If $vScrapeSearchMode = 0 Or $vScrapeSearchMode = 1 Then $aRomList[$vBoucle][8] = _DownloadWRetry($iURLScraper & "api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword & "&crc=" & $aRomList[$vBoucle][5] & "&md5=" & $aRomList[$vBoucle][6] & "&sha1=" & $aRomList[$vBoucle][7] & "&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $vRomName & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
	If (StringInStr(FileReadLine($aRomList[$vBoucle][8]), "Erreur") Or Not FileExists($aRomList[$vBoucle][8])) Then
		$vRomName = _URIEncode($sFileName)
		If $vScrapeSearchMode = 0 Or $vScrapeSearchMode = 2 Then $aRomList[$vBoucle][8] = _DownloadWRetry($iURLScraper & "api/jeuInfos.php?devid=" & $iDevId & "&devpassword=" & $iDevPassword & "&softname=" & $iSoftname & "&output=xml&ssid=" & $vSSLogin & "&sspassword=" & $vSSPassword & "&crc=&md5=&sha1=&systemeid=" & $vSystemID & "&romtype=rom&romnom=" & $vRomName & "&romtaille=" & $aRomList[$vBoucle][4], $vXMLRom)
		If (StringInStr(FileReadLine($aRomList[$vBoucle][8]), "Erreur") Or Not FileExists($aRomList[$vBoucle][8])) Then
			FileDelete($aRomList[$vBoucle][8])
			$aRomList[$vBoucle][8] = ""
			$aRomList[$vBoucle][9] = 0
			Return $aRomList
		EndIf
	EndIf
	$aRomList[$vBoucle][9] = 1
	Return $aRomList
EndFunc   ;==>_DownloadROMXML

Func _SelectSystem($oXMLSystem, $vFullScrape = 0)
	Local $vSystem, $vSystemID, $vSystemTEMP
	Local $aSystemListTXT, $aSystemListXML
	Local $vRechSYS = IniRead($iINIPath, "LAST_USE", "$vRechSYS", 1)

	$aSystemListXML = _XML_ListValue("Data/systeme/noms/*", "", $oXMLSystem)
;~ 	_ArrayDisplay($aSystemListXML, "$aSystemListXML") ;Debug
	_ArrayColInsert($aSystemListXML, 1)
	_ArrayColInsert($aSystemListXML, 1)
	_ArrayDelete($aSystemListXML, 0)

	For $vBoucle = 0 To UBound($aSystemListXML) - 1
		$aSystemListXML[$vBoucle][1] = _XML_Read('Data/systeme[noms/* = "' & $aSystemListXML[$vBoucle][0] & '"]/id', 0, "", $oXMLSystem)
		$aSystemListXML[$vBoucle][2] = $aSystemListXML[$vBoucle][1]
	Next
	_ArraySort($aSystemListXML)
;~ 	_ArrayDisplay($aSystemListXML, "$aSystemListXML") ;Debug

	If $vRechSYS = 1 Or $vFullScrape = 1 Then
		_FileReadToArray($iRessourcesPath & "\systemlist.txt", $aSystemListTXT, $FRTA_NOCOUNT, "|")
;~ 		_ArrayDisplay($aSystemListTXT, "$aSystemListTXT") ;Debug
		$vSystem = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
		$vSystem = StringLower($vSystem[UBound($vSystem) - 1])
		$iSystem = _ArraySearch($aSystemListTXT, $vSystem)
		If $iSystem > 0 Then
			$vSystemTEMP = $aSystemListTXT[$iSystem][1]
			$iSystem = _ArraySearch($aSystemListXML, $vSystemTEMP)
			If $iSystem > 0 Then
				_LOG("System detected : " & $aSystemListXML[$iSystem][0] & "(" & $aSystemListXML[$iSystem][1] & ")", 0, $iLOGPath)
				Return $aSystemListXML[$iSystem][1]
			EndIf
		EndIf
		_LOG("No system found for : " & $vSystem, 0, $iLOGPath)
		If $vFullScrape = 1 Then Return ""
	EndIf

	$vSystemID = _SelectGUI($aSystemListXML, "", "system")
	_LOG("System selected No " & $vSystemID, 0, $iLOGPath)
	Return $vSystemID

EndFunc   ;==>_SelectSystem

Func _Results($aRomList, $vNbThread, $vFullTimer, $vFullScrape = 0)
	Local $vTimeTotal, $vTimeMoy = 0, $vNbRom = 0, $vNbRomScraped = 0, $vNbRomOK = 0
	Local $vTitle
	For $vBoucle = 1 To UBound($aRomList) - 1
		$vTimeMoy += $aRomList[$vBoucle][10]
		If $aRomList[$vBoucle][9] = 1 And $aRomList[$vBoucle][12] = 1 Then $vNbRomOK += 1
		If $aRomList[$vBoucle][12] = 1 Then $vNbRomScraped += 1
	Next
	If $vNbRomScraped > 0 Then
		$vTimeMoy = Round($vTimeMoy / $vNbRomScraped, 2) & " sec."
	Else
		$vTimeMoy = 'N/A'
	EndIf
	$vTimeMax = _ArrayMax($aRomList, 1, 0, Default, 10)
	$vTimeTotal = _FormatElapsedTime(Round((TimerDiff($vFullTimer) / 1000), 2))
	If $vNbRomScraped > 0 Then
		$vNbRomOKRatio = Round($vNbRomOK / $vNbRomScraped * 100) & "%"
	Else
		$vNbRomOKRatio = 'N/A'
	EndIf
	If IsArray($aRomList) Then $vNbRom = UBound($aRomList) - 1

	_LOG("Results", 0, $iLOGPath)
	_LOG("Roms : = " & $vNbRom, 0, $iLOGPath)
	_LOG("Roms Found = " & $vNbRomOK & "/" & $vNbRomScraped, 0, $iLOGPath)
	_LOG("Average Time by Rom = " & $vTimeMoy, 0, $iLOGPath)
	_LOG("Max Time = " & $vTimeMax, 0, $iLOGPath)
	_LOG("Total Time = " & $vTimeTotal, 0, $iLOGPath)
	_LOG("Nb Thread = " & $vNbThread, 0, $iLOGPath)

	If $vFullScrape = 1 Then
		$vTitle = "FullScrape"
	Else
		$vTitle = StringSplit(IniRead($iINIPath, "LAST_USE", "$vSource_RomPath", ""), "\")
		$vTitle = $vTitle[UBound($vTitle) - 1]
	EndIf

	If $vScrapeCancelled = 1 Then $vTitle = $vTitle & " (" & _MultiLang_GetText("scrap_cancel_button") & ")"

	#Region ### START Koda GUI section ### Form=
	$F_Results = GUICreate(_MultiLang_GetText("win_Results_Title"), 538, 403, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE))
	$L_Results = GUICtrlCreateLabel($vTitle, 8, 8, 247, 29)
	GUICtrlSetFont(-1, 15, 800, 0, "MS Sans Serif")
	$L_NbRom = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_FilesFound"), 8, 56)
	$L_NbRomOK = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_RomsFound"), 8, 80)
	$L_NbRomOKRatio = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_PercentFound"), 8, 104)
	$L_TimeMoy = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_MoyTime"), 305, 56)
	$L_TimeTotal = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_FullTime"), 305, 80)
	$L_NbThread = GUICtrlCreateLabel(_MultiLang_GetText("win_Results_NbThread"), 305, 104)
	$L_NbRomValue = GUICtrlCreateLabel($vNbRom, 176, 56)
	$L_NbRomOKValue = GUICtrlCreateLabel($vNbRomOK & "/" & $vNbRomScraped, 176, 80)
	$L_NbRomOKRatioValue = GUICtrlCreateLabel($vNbRomOKRatio, 176, 104)
	$L_TimeMoyValue = GUICtrlCreateLabel($vTimeMoy, 448, 56)
	$L_TimeTotalValue = GUICtrlCreateLabel($vTimeTotal, 448, 80)
	$L_NbThreadValue = GUICtrlCreateLabel($vNbThread, 448, 104)
	$B_OK = GUICtrlCreateButton("OK", 104, 128, 147, 25)
;~ 	$B_Missing = GUICtrlCreateButton("Generer le fichier Missing", 288, 128, 147, 25)
	$G_Time = _GraphGDIPlus_Create($F_Results, 25, 160, 500, 190, 0xFF000000, 0xFF34495c)
	$L_Xmin = GUICtrlCreateLabel("1", 26, 355, 10, 17)
	$L_Xmax = GUICtrlCreateLabel($vNbRom, 325, 355, 200, 17, $SS_RIGHT)
	$L_Ymin = GUICtrlCreateLabel("0s", 0, 340, 24, 17, $SS_RIGHT)
	$L_Ymax = GUICtrlCreateLabel(Round($vTimeMax, 1) & "s", 0, 160, 24, 17, $SS_RIGHT)
;~ 	$G_Time = _GraphGDIPlus_Create($F_Results, 50, 160, 200, 150, 0xFF000000, 0xFF34495c)
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	$vXTicks = 50
	If $vNbRom <= 50 Then $vXTicks = $vNbRom
	_GraphGDIPlus_Set_RangeX($G_Time, 1, Round($vNbRom), Round($vXTicks), 0)
	_GraphGDIPlus_Set_RangeY($G_Time, 0, Round($vTimeMax * 10) + 2, ((Round($vTimeMax)) * 10) + 2, 0)
	_GraphGDIPlus_Set_GridX($G_Time, 1, 0xFF6993BE)
	_GraphGDIPlus_Set_GridY($G_Time, 1, 0xFF6993BE)
	_GraphGDIPlus_Plot_Start($G_Time, 0, 0)
	_GraphGDIPlus_Set_PenColor($G_Time, 0xFFff0000)
	_GraphGDIPlus_Set_PenSize($G_Time, 2)

	For $vBoucle = 1 To $vNbRom
		_GraphGDIPlus_Plot_Line($G_Time, $vBoucle, $aRomList[$vBoucle][10] * 10)
	Next
	_GraphGDIPlus_Refresh($G_Time)

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $B_OK
				_GraphGDIPlus_Delete($F_Results, $G_Time)
				GUIDelete($F_Results)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return

		EndSwitch
	WEnd

EndFunc   ;==>_Results

Func _ScrapeZipContent($aRomList, $vBoucle)
	Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
	Local $aPathSplit = _PathSplit($aRomList[$vBoucle][0], $sDrive, $sDir, $sFileName, $sExtension)

	; check if it is a ZIP
	If $sExtension <> ".zip" Then
		Return $aRomList
	EndIf

	_LOG("File '" & $aRomList[$vBoucle][1] & "' is a ZIP. Scraping contents...", 1, $iLOGPath)

	; now unzip it to a temp folder
	Local $vZipDir = @TempDir & "\" & "UXS_ZIP_Temp_" & $aRomList[$vBoucle][2]
	Local $vZipDirEx = $vZipDir & "\" & "_extract"
	Local $vSrcPath = $vZipDir & "\" & $aRomList[$vBoucle][0]
	DirRemove($vZipDir, 1)
	FileCopy($aRomList[$vBoucle][1], $vSrcPath, $FC_CREATEPATH)
;~ 	_LOG("Unzipping file '" & $vSrcPath & "' to temp directory: " & $vZipDirEx, 1, $iLOGPath)
;~ 	Local $vResult = _Zip_UnzipAll($vSrcPath, $vZipDirEx, 1)
;~ 	If @error <> 0 Then
;~ 		_LOG("Error #" & @error & " unzipping file '" & $aRomList[$vBoucle][1] & "' to temp directory: " & $vZipDirEx, 1, $iLOGPath)
;~ 		Return $aRomList
;~ 	EndIf

	$vResult = _Unzip($vSrcPath, $vZipDirEx)
	If $vResult < 0 Then
		Switch $vResult
			Case 1
				_LOG("not a Zip file", 2, $iLOGPath)
				Return $aRomList
			Case 2
				_LOG("Impossible to unzip", 2, $iLOGPath)
				Return $aRomList
			Case Else
				_LOG("Unknown Zip Error (" & @error & ")", 2, $iLOGPath)
				Return $aRomList
		EndSwitch
	EndIf

	; get a list of all unzipped files
	Local $aZipRomList = _FileListToArrayRec($vZipDirEx, "*", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT)
	_LOG("Read files from ZIP: " & _ArrayToString($aZipRomList), 1, $iLOGPath)

	For $vIdx = 1 To 12
		_ArrayColInsert($aZipRomList, $vIdx)
	Next

	For $vIdx = 1 To UBound($aZipRomList) - 1
		$aZipRomList[$vIdx][1] = $vZipDirEx & "\" & $aZipRomList[$vIdx][0]
		$aPathSplit = _PathSplit($aZipRomList[$vIdx][0], $sDrive, $sDir, $sFileName, $sExtension)
		$aZipRomList[$vIdx][2] = $aPathSplit[3]
		$aZipRomList[$vIdx][9] = -1
	Next

	; iterate over them and check if we can match one
	For $vBoucleZip = 1 To UBound($aZipRomList) - 1
		_LOG("Scraping ZIP content file: " & $aZipRomList[$vBoucleZip][0], 1, $iLOGPath)
		If $aZipRomList[$vBoucleZip][3] < 2 Then
			$aZipRomList = _CalcHash($aZipRomList, $vBoucleZip, 0)
		EndIf
		$aZipRomList = _DownloadROMXML($aZipRomList, $vBoucleZip, $aConfig[12], $aConfig[13], $aConfig[14])
		If ($aZipRomList[$vBoucleZip][9] = 1) Then
			_LOG("Found match for ZIP content file: " & $aZipRomList[$vBoucleZip][0], 1, $iLOGPath)
			; we found a match so copy the match result to the original ZIP and stop
			$aRomList[$vBoucle][8] = $aZipRomList[$vBoucleZip][8]
			$aRomList[$vBoucle][9] = $aZipRomList[$vBoucleZip][9]
			ExitLoop
		EndIf
	Next
	DirRemove($vZipDir, 1)
	Return $aRomList
EndFunc   ;==>_ScrapeZipContent

Func _SCRAPE($oXMLProfil, $vNbThread = 1, $vFullScrape = 0)
	Local $sMailSlotCheckEngine = "\\.\mailslot\CheckEngine"
	While ProcessExists($iScraper)
		ProcessClose($iScraper)
	WEnd

	DirRemove($iTEMPPath, 1)
	DirCreate($iTEMPPath)
	FileSetAttrib($iTEMPPath, "+H")
	DirCreate($iTEMPPath & "\scraped")
;~ 	$nMsg = ""

	If $aConfig <> 0 Then
		_GUI_Refresh($oXMLProfil, 1)

		Local $vScrapeCancelled = 0
		Local $aConfig = _LoadConfig($oXMLProfil)
		Local $aExtToHide = StringSplit(_XML_Read('/Profil/Element[Source_Value="%AutoHide%"]/AutoHideEXT', 0, "", $oXMLProfil), "|")
		Local $aValueToHide = StringSplit(_XML_Read('/Profil/Element[Source_Value="%AutoHide%"]/AutoHideValue', 0, "", $oXMLProfil), "|")
		Local $vSendTimerLeft = 0, $vCreateTimerLeft = 0, $vSendTimerMoy = 0, $vCreateTimerMoy = 0, $vSendTimerTotal = 0, $vSendTimerTotalbyRom = 0, $vCreateTimerTotal = 0, $PercentProgression = 0
		Local $vMissingRom_Mode = $aConfig[6]
		Local $vThreadUsed = 1
		Local $vScrapeSearchMode = IniRead($iINIPath, "LAST_USE", "$vScrapeSearchMode", 0)
		$aConfig[8] = "0000"

		If StringLeft($aConfig[0], 2) = "\\" And $vFullScrape = 0 Then _Plink($oXMLProfil, "killall") ; Ask to kill ES

		;Checking NbThread
		$vTEMPPathSSCheck = _DownloadWRetry($iURLScraper & "api/ssuserInfos.php?devid=xxx&devpassword=yyy&softname=zzz&output=XML&ssid=" & $aConfig[13] & "&sspassword=" & $aConfig[14], $iScriptPath & "\Ressources\SSCheck.xml")
		$vSSParticipation = Number(_XML_Read("/Data/ssuser/uploadsysteme", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadinfos", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/romasso", 0, $vTEMPPathSSCheck)) + Number(_XML_Read("/Data/ssuser/uploadmedia", 0, $vTEMPPathSSCheck))
		$vSSContrib = Number(_XML_Read("/Data/ssuser/contribution", 0, $vTEMPPathSSCheck))
		$vSSLevel = Number(_XML_Read("/Data/ssuser/niveau", 0, $vTEMPPathSSCheck))
		If $vSSParticipation < 1 Then $vSSParticipation = 0
		Switch $vSSParticipation
			Case 0
				$vNbThreadMax = 1
			Case 1
				$vNbThreadMax = 2
			Case 2 To 49
				$vNbThreadMax = 3
			Case 50 To 199
				$vNbThreadMax = 4
			Case 200 To 499
				$vNbThreadMax = 5
			Case 500 To 749
				$vNbThreadMax = 6
			Case 750 To 999
				$vNbThreadMax = 7
			Case 999 To 9999999
				$vNbThreadMax = 8
			Case Else
				$vNbThreadMax = 1
		EndSwitch
		Switch $vSSContrib
			Case 2
				$vNbThreadMax = $vNbThreadMax + 1
			Case 3 To 999999
				$vNbThreadMax = $vNbThreadMax + 5
		EndSwitch
		If $vNbThread > $vNbThreadMax Then
			_LOG("Are you a cheater ? BAD NbThread in INI : " & $vNbThread & "(MAX = " & $vNbThreadMax & ")", 0, $iLOGPath)
			$vNbThread = 1
			IniWrite($iINIPath, "LAST_USE", "$vNbThread", $vNbThread)
		EndIf

		;Creating the romlist
		$aConfig[12] = _SelectSystem($oXMLSystem, $vFullScrape)
		If $aConfig[12] = "" Then
			$aRomList = -1
		Else
			$aRomList = _RomList_Create($aConfig, $vFullScrape, $oXMLProfil)
		EndIf

		If IsArray($aRomList) And _Check_Cancel() Then

			;Starting Scrape Engine
			For $vBoucle = 1 To $vNbThread
				ShellExecute($iScriptPath & "\" & $iScraper, $vBoucle)
				_LOG("Start Scrape Engine Number " & $vBoucle, 1, $iLOGPath)
			Next

			;Creating gamelist.xml
			If $aConfig[5] = 0 Or ($aConfig[5] > 0 And FileGetSize($aConfig[0]) < 100) Then
				_FileCreate($aConfig[0])
				FileDelete($aConfig[0])
				_LOG("vScrape_Mode = " & $aConfig[5] & " And " & $aConfig[0] & " = " & FileGetSize($aConfig[0]) & " ---> _XML_Make", 1, $iLOGPath)
				$oXMLTarget = _XML_Make($aConfig[0], _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil))
			EndIf

			;Checking existing gamelist.xml
			$vXpath2RomPath = "/" & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & "/" & _XML_Read("Profil/Element[@Type='RomPath']/Target_Value", 0, "", $oXMLProfil)
			If FileGetSize($aConfig[0]) > 100 And _Check_Cancel() Then $aXMLRomList = _XML_ListValue($vXpath2RomPath, $aConfig[0])

			;Checking Scrape Engine
			Local $vEngineLaunched = 0
			Local $vEngineTimer = TimerInit()
			While 1
				If _MailSlotGetMessageCount($hMailSlotCheckEngine) >= 1 Then
					$vEngineLaunched += 1
					_LOG("Engine Number " & _ReadMessage($hMailSlotCheckEngine) & " OK", 1, $iLOGPath)
					If $vEngineLaunched >= $vNbThread Then ExitLoop
				EndIf
				If Not _Check_Cancel() Then Return $aRomList
				If (TimerDiff($vEngineTimer) / 1000) > 5 Then
					_LOG("Scrape Engine seems to not launch, check Antivirus and firewall", 2, $iLOGPath)
					MsgBox($MB_ICONERROR, _MultiLang_GetText("err_title"), _MultiLang_GetText("err_UXSGlobal") & @CRLF & _MultiLang_GetText("err_ScrapeEngine"))
					Return -1
				EndIf
			WEnd

			_ITaskBar_SetProgressState($F_UniversalScraper, 2)

			Local $vBoucle = 0, $vRomSend = 0, $vRomReceived = 0
			While 1
				If $vBoucle < UBound($aRomList) - 1 Then
					$vSendTimer = TimerInit()
					$vBoucle += 1
					$aRomList = _Check_Rom2Scrape($aRomList, $vBoucle, $aXMLRomList, $aConfig[2], $aConfig[5], $aExtToHide, $aValueToHide) ;Check if rom need to be scraped
					If $aRomList[$vBoucle][3] >= 1 And _Check_Cancel() Then
						If $aRomList[$vBoucle][3] < 2 Then
							$aRomList = _CalcHash($aRomList, $vBoucle, $oXMLProfil) ;Hash calculation
						EndIf
						$aRomList = _DownloadROMXML($aRomList, $vBoucle, $aConfig[12], $aConfig[13], $aConfig[14], $vScrapeSearchMode) ; Download the XML file from API

						; check if the ROM could be found otherwise try to scrape inside ZIP
						If ($aRomList[$vBoucle][9] = 0) Then
							$aRomList = _ScrapeZipContent($aRomList, $vBoucle)
						EndIf

;~ 						MsgBox(0, "PAUSE", "PAUSE")

						;If found (or missingRom_Mode = 1 or Rom to Hide) Send it to the scrape Engine
						If ($aRomList[$vBoucle][9] = 1 Or $vMissingRom_Mode = 1 Or $aRomList[$vBoucle][3] > 1) And _Check_Cancel() Then
							If $aRomList[$vBoucle][3] = 4 Then
								_XML_Make($iTEMPPath & "\scraped\" & $vBoucle & ".xml", _XML_Read("Profil/FolderRoot/Target_Value", 0, "", $oXMLProfil))
							Else
								_XML_Make($iTEMPPath & "\scraped\" & $vBoucle & ".xml", _XML_Read("Profil/Game/Target_Value", 0, "", $oXMLProfil))
							EndIf
							$sMailSlotName = "\\.\mailslot\Son" & $vThreadUsed
							$vMessage = _ArrayToString($aRomList, '{Break}', $vBoucle, $vBoucle, '{Break}')
							$vResultSM = _SendMail($sMailSlotName, $vMessage)
							$vResultSM = _SendMail($sMailSlotName, $vBoucle)
							$vMessage = _ArrayToString($aConfig, '{Break}')
							$vResultSM = _SendMail($sMailSlotName, $vMessage)
							$vResultSM = _SendMail($sMailSlotName, $vProfilsPath)
							If $vResultSM = 1 Then ; Check Scrape Engine
								$aRomList[$vBoucle][11] = 1
								$vRomSend += 1
								$vThreadUsed += 1
								If $vThreadUsed > $vNbThread Then $vThreadUsed = 1
							Else ; Try to relaunch scrape engine
								_LOG("Error Thread No " & $vThreadUsed & " Doesn't exist anymore Try to Relaunch", 2, $iLOGPath)
								ShellExecute($iScriptPath & "\" & $iScraper, $vThreadUsed)
								$vBoucle -= 1
							EndIf
						EndIf
					EndIf

					;Check Cancel
					If Not _Check_Cancel() Then
						For $vBoucle2 = 1 To $vNbThread
							_SendMail($sMailSlotCancel & $vBoucle2, "CANCELED")
						Next
						$vBoucle = UBound($aRomList) - 1
					EndIf
					$aRomList[$vBoucle][10] = Round(TimerDiff($vSendTimer) / 1000, 2)
				EndIf

				If _MailSlotGetMessageCount($hMailSlotMother) >= 1 Then
					$vMessageFromChild = _ReadMessage($hMailSlotMother)
					$aMessageFromChild = StringSplit($vMessageFromChild, '|', $STR_ENTIRESPLIT + $STR_NOCOUNT)
					ReDim $aMessageFromChild[2]
					_LOG("Receveid Message Rom no " & $aMessageFromChild[0] & " in " & $aMessageFromChild[1] & "s", 1, $iLOGPath)
					$aRomList[$aMessageFromChild[0]][10] += $aMessageFromChild[1]
					$aRomList[$aMessageFromChild[0]][12] = 1
					$vRomReceived += 1

					;Timers
;~ 					$vSendTimerTotal = Round(TimerDiff($vEngineTimer) / 1000, 2)
					$vSendTimerTotal += $aRomList[$aMessageFromChild[0]][10]
					$vSendTimerMoy = Round(Round($vSendTimerTotal / $vRomReceived, 2) / $vNbThread, 2)
					$vSendTimerLeft = $vSendTimerMoy * (((UBound($aRomList) - 1 - $vBoucle) * ($vBoucle / $vRomSend)) + ($vRomSend - $vRomReceived))

					$PercentProgression = Round(($vRomReceived * 100) / UBound($aRomList) - 1)
					GUICtrlSetData($PB_SCRAPE, $PercentProgression)
					_ITaskBar_SetProgressValue($F_UniversalScraper, $PercentProgression)
					_GUICtrlStatusBar_SetText($L_SCRAPE, $aRomList[$aMessageFromChild[0]][2])
					_GUICtrlStatusBar_SetText($L_SCRAPE, "Time Left  : " & _FormatElapsedTime($vSendTimerLeft), 1)
					_GUICtrlStatusBar_SetText($L_SCRAPE, @TAB & @TAB & $vRomReceived & "/" & UBound($aRomList) - 1, 2)

				EndIf

				If Not _Check_Cancel() Or ($vRomReceived = $vRomSend And $vBoucle = UBound($aRomList) - 1) Then ExitLoop
			WEnd

			;Reading Target xml
			Dim $aXMLTarget
			_FileReadToArray($aConfig[0], $aXMLTarget)
			_ArrayDelete($aXMLTarget, 0)
			FileDelete($aConfig[0])
			$vBoucle = UBound($aXMLTarget) - 1
			While $vBoucle <> 0 ;Grabing last line (without "" )
				If $aXMLTarget[$vBoucle] = "" Then
					_ArrayDelete($aXMLTarget, $vBoucle)
				Else
					$vLastLine = $aXMLTarget[$vBoucle]
					_ArrayDelete($aXMLTarget, $vBoucle)
					ExitLoop
				EndIf
				$vBoucle -= 1
			WEnd

			If $vLastLine = '<' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '/>' Then
				_ArrayAdd($aXMLTarget, '<' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '>')
				$vLastLine = '</' & _XML_Read("Profil/Root/Target_Value", 0, "", $oXMLProfil) & '>'
			EndIf

			For $vBoucle = 1 To UBound($aRomList) - 1
				Dim $aXMLSource
				If $aRomList[$vBoucle][12] = 1 Then
					_FileReadToArray($iTEMPPath & "\scraped\" & $vBoucle & ".xml", $aXMLSource)
					For $vBoucle2 = 1 To UBound($aXMLSource) - 1
						_ArrayAdd($aXMLTarget, $aXMLSource[$vBoucle2])
					Next
				EndIf
			Next

			_ArrayAdd($aXMLTarget, $vLastLine)
			_FileWriteFromArray($aConfig[0], $aXMLTarget)

			Local $oXMLAfterTidy = _XML_CreateDOMDocument(Default)
			$oToTidy = _XML_Open($aConfig[0])
			Local $vXMLAfterTidy = _XML_TIDY($oToTidy, -1)
			_XML_LoadXML($oXMLAfterTidy, $vXMLAfterTidy)
			FileDelete($aConfig[0])
			_XML_SaveToFile($oXMLAfterTidy, $aConfig[0])

			GUICtrlSetData($PB_SCRAPE, 0)
			_ITaskBar_SetProgressState($F_UniversalScraper)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 0)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 1)
			_GUICtrlStatusBar_SetText($L_SCRAPE, "", 2)
			_CreateMissing($aRomList, $aConfig)

		EndIf
	EndIf
	While ProcessExists($iScraper)
		ProcessClose($iScraper)
	WEnd
	For $vBoucle = 1 To $vNbThread
		DirRemove($iTEMPPath & $vBoucle, 1)
	Next
	Return $aRomList
EndFunc   ;==>_SCRAPE

Func _CreateMissing($aRomList, $aConfig)
	Local $vMaxNameLen = 68
	$vSysName = _XML_Read('/Data/systeme[id=' & $aConfig[12] & ']/noms/nom_eu', 0, $iScriptPath & "\Ressources\systemlist.xml")
;~ 	_ArrayDisplay($aConfig, "$aConfig")
	If Not _FileCreate($aConfig[1] & '\_' & $vSysName & "_missing.txt") Then MsgBox(4096, "Error", " Erreur creation du Fichier missing      error:" & @error)
	For $vBoucle = 1 To UBound($aRomList) - 1
		If $aRomList[$vBoucle][9] = 0 Then
			$tCur = _Date_Time_GetLocalTime()
			If StringLen($aRomList[$vBoucle][0]) > 68 Then $vMaxNameLen = StringLen($aRomList[$vBoucle][0]) + 1
			$vMissing_Line1 = StringLeft($aRomList[$vBoucle][0] & "                                                                     ", $vMaxNameLen)
			$vMissing_Line2 = $aRomList[$vBoucle][5]
			$vMissing_Line3 = StringRight("                  " & StringRegExpReplace($aRomList[$vBoucle][4], '\G(\d+?)(?=(\d{3})+(\D|$))', '$1 '), 17) & "    "
			$hFile = _WinAPI_CreateFile($aRomList[$vBoucle][1], 2)
			$aTime = _Date_Time_GetFileTime($hFile)
			_WinAPI_CloseHandle($hFile)
			$vTime = _Date_Time_FileTimeToStr($aTime[2])
			$vTime = StringMid($vTime, 12, 5) & ".00 " & StringMid($vTime, 7, 4) & "-" & StringLeft($vTime, 2) & "-" & StringMid($vTime, 4, 2)
			$vMissing_Line4 = "    " & $aRomList[$vBoucle][6]
			FileWrite($aConfig[1] & '\_' & $vSysName & "_missing.txt", $vMissing_Line1 & $vMissing_Line2 & $vMissing_Line3 & $vTime & $vMissing_Line4 & @CRLF)
		EndIf
	Next
EndFunc   ;==>_CreateMissing

Func _WizardWindow($vTitle, $vDescription, $vInputValue, $vInputDefault = "", $vInputType = 0, $vNext = 1, $vBack = 1, $vCancel = 1)
	Local $vReturnValue
	$vDescription = StringReplace($vDescription, "|!|", @CRLF)
	#Region ### START Koda GUI section ### Form=
	$F_WIZARD = GUICreate($vTitle, 426, 314)
	$P_UXS = GUICtrlCreatePic($iScriptPath & "\Ressources\UXS Wizard.jpg", 8, 6, 200, 300)
	$G_DESC = GUICtrlCreateGroup("", 216, 0, 200, 244)
	$L_DESC = GUICtrlCreateLabel($vDescription, 224, 8, 185, 233)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$I_INPUT = GUICtrlCreateInput("", 216, 248, 161, 21)
	$B_BROWSE = GUICtrlCreateButton("...", 384, 248, 27, 21)
	$B_BACK = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_Back"), 296, 280, 59, 25)
	$B_CANCEL = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_Cancel"), 216, 280, 75, 25)
	$B_NEXT = GUICtrlCreateButton(_MultiLang_GetText("win_Wizard_Next"), 360, 280, 59, 25)
	$C_COMBO = GUICtrlCreateCombo("", 216, 248, 201, 25, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_SIMPLE))
	GUISetState(@SW_SHOW)
	GUISetState(@SW_DISABLE, $F_UniversalScraper)
	#EndRegion ### END Koda GUI section ###

	Switch $vInputType
		Case 1 ; Combo
			GUICtrlSetState($I_INPUT, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
			GUICtrlSetData($C_COMBO, $vInputValue, $vInputDefault)
		Case 2 ; Input + Browse Button
			GUICtrlSetData($I_INPUT, $vInputDefault)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
		Case 3 ; Input
			GUICtrlSetData($I_INPUT, $vInputDefault)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
		Case Else ;Nothing
			GUICtrlSetState($I_INPUT, $GUI_HIDE)
			GUICtrlSetState($B_BROWSE, $GUI_HIDE)
			GUICtrlSetState($C_COMBO, $GUI_HIDE)
	EndSwitch

	If $vNext = 0 Then GUICtrlSetState($B_NEXT, $GUI_HIDE)
	If $vBack = 0 Then GUICtrlSetState($B_BACK, $GUI_HIDE)
	If $vCancel = 0 Then GUICtrlSetState($B_CANCEL, $GUI_HIDE)
	If $vCancel = 2 Then GUICtrlSetData($B_CANCEL, _MultiLang_GetText("win_Wizard_End"))

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $B_BROWSE
				$vBrowse = FileSelectFolder("", GUICtrlRead($I_INPUT), $FSF_CREATEBUTTON, GUICtrlRead($I_INPUT), $F_WIZARD)
				GUICtrlSetData($I_INPUT, $vBrowse)
			Case $B_NEXT
				Switch $vInputType
					Case 1
						$vReturnValue = GUICtrlRead($C_COMBO)
					Case 2
						$vReturnValue = GUICtrlRead($I_INPUT)
					Case 3
						$vReturnValue = GUICtrlRead($I_INPUT)
					Case Else
						$vReturnValue = 1
				EndSwitch
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return $vReturnValue
			Case $B_BACK
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return -1
			Case $B_CANCEL
				GUIDelete($F_WIZARD)
				GUISetState(@SW_ENABLE, $F_UniversalScraper)
				WinActivate($F_UniversalScraper)
				Return -2
		EndSwitch
	WEnd

EndFunc   ;==>_WizardWindow

Func _WizardProfil($vWizCancel)
	; Loading profils list
	Local $vProfilDefault, $vProfilList = ""
	Local $aProfilList = _FileListToArrayRec($iProfilsPath, "*.xml", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
	If Not IsArray($aProfilList) Then
		_LOG("No Profils found", 2, $iLOGPath)
		Exit
	EndIf
	_ArrayColInsert($aProfilList, 0)
	_ArrayColInsert($aProfilList, 0)
	_ArrayDelete($aProfilList, 0)
	For $vBoucle = 0 To UBound($aProfilList) - 1
		$aProfilList[$vBoucle][0] = _XML_Read("Profil/Name", 1, $aProfilList[$vBoucle][2])
		If StringInStr($aProfilList[$vBoucle][0], $vProfilsPath) Then $vProfilsPath = $aProfilList[$vBoucle][2]
		$vProfilList = $vProfilList & $aProfilList[$vBoucle][0] & "|"
	Next

	$vProfilDefault = IniRead($iINIPath, "LAST_USE", "$vProfilsPath", "")
	If $vProfilDefault = "" Then
		$vProfilDefault = $aProfilList[0][0]
	Else
		For $vBoucle = 0 To UBound($aProfilList) - 1
			If StringInStr($aProfilList[$vBoucle][2], $vProfilDefault) Then $vProfilDefault = $aProfilList[$vBoucle][0]
		Next
	EndIf

	$vResultWZ = _WizardWindow(_MultiLang_GetText("win_Wizard_Profil_Title"), _MultiLang_GetText("win_Wizard_Profil_Desc"), $vProfilList, $vProfilDefault, 1, 1, 0, $vWizCancel)
	If $vResultWZ < 0 Then Return $vResultWZ
	For $i = 0 To UBound($aProfilList) - 1
		If StringInStr($aProfilList[$i][0], $vResultWZ) Then $vProfilsPath = $aProfilList[$i][2]
	Next
	Return $vProfilsPath
EndFunc   ;==>_WizardProfil

Func _WizardAutoconf($vWizCancel)
	; Autoconf
	$vResultWZ = _WizardWindow(_MultiLang_GetText("win_Wizard_Autoconf_Title"), _MultiLang_GetText("win_Wizard_Autoconf_Desc"), "", _XML_Read("Profil/AutoConf/Source_RootPath", 0, "", $oXMLProfil), 2, 1, 1, $vWizCancel)
	If $vResultWZ < 0 Then Return $vResultWZ
	_LOG("Wizard - Autoconf Path : " & $vResultWZ, 0, $iLOGPath)
	If (StringRight($vResultWZ, 1) = '\') Then StringTrimRight($vResultWZ, 1)
	Return $vResultWZ
EndFunc   ;==>_WizardAutoconf

;~ 	$aPicParameters[0] = Target_Width
;~ 	$aPicParameters[1] = Target_Height
;~ 	$aPicParameters[2] = Target_TopLeftX
;~ 	$aPicParameters[3] = Target_TopLeftY
;~ 	$aPicParameters[4] = Target_TopRightX
;~ 	$aPicParameters[5] = Target_TopRightY
;~ 	$aPicParameters[6] = Target_BottomLeftX
;~ 	$aPicParameters[7] = Target_BottomLeftY
;~ 	$aPicParameters[8] = Target_Maximize
;~ 	$aPicParameters[9] = Target_OriginX
;~ 	$aPicParameters[10] = Target_OriginY
;~ 	$aPicParameters[11] = Target_BottomRightX
;~ 	$aPicParameters[12] = Target_BottomRightY

;~ 	$aConfig[0]=$vTarget_XMLName
;~ 	$aConfig[1]=$vSource_RomPath
;~ 	$aConfig[2]=$vTarget_RomPath
;~ 	$aConfig[3]=$vSource_ImagePath
;~ 	$aConfig[4]=$vTarget_ImagePath
;~ 	$aConfig[5]=$vScrape_Mode (0 = NEW, 1 = Update XML & Picture, [2 = Update Picture only To ADD])
;~ 	$aConfig[6]=$vMissingRom_Mode (0 = No missing Rom, 1 = Adding missing Rom)
;~ 	$aConfig[7]=$vCountryPic_Mode (0 = Language Pic, 1 = Rom Pic, 2 = Language Pic Strict, 3 = Rom Pic Strict)
;~ 	$aConfig[8]=$oTarget_XML
;~ 	$aConfig[9]=$aLangPref
;~ 	$aConfig[10]=$aCountryPref
;~ 	$aConfig[11]=$aMatchingCountry
;~ 	$aConfig[12]=$vSystemId
;~ 	$aConfig[13]=$vSSLogin
;~ 	$aConfig[14]=$vSSPassword

;~ 	$aRomList[][0]=Relative Path
;~ 	$aRomList[][1]=Full Path
;~ 	$aRomList[][2]=Filename (without extension)
;~ 	$aRomList[][3]=XML to Scrape (0 = No, 1 = Yes, 2 = To hide, 3 = To hide, 4 = Folder)
;~ 	$aRomList[][4]=File Size
;~ 	$aRomList[][5]=File CRC32
;~ 	$aRomList[][6]=File MD5
;~ 	$aRomList[][7]=File SHA1
;~ 	$aRomList[][8]=XML File Scraped
;~ 	$aRomList[][9]=Rom Found
;~ 	$aRomList[][10]=Time By Rom
;~ 	$aRomList[][11]=Send to the scraper
;~ 	$aRomList[][12]=Return from the scraper

;~ $aDIRList[][0] = Source System directory
;~ $aDIRList[][1] = Source System full directory Local path
;~ $aDIRList[][2] = Target System directory full Local path
;~ $aDIRList[][3] = Target gamelist.xml full Local path
;~ $aDIRList[][4] = Source Image directory full Local path
;~ $aDIRList[][5] = Target Image directory full Local path
