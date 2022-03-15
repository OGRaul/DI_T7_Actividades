#Usar La Interfaz Moderna
!include "MUI2.nsh"
#################
!include "FileFunc.nsh"
#############
!include "Library.nsh"
#Tipo De Compresion--algoritmo de compresion?
SetCompressor lzma
#Sobreescribir
SetOverwrite on
#Optimizar
SetDatablockOptimize on
#Version
!define VERSION "1.0"
  
;--------------------------------

; The name of the installer
Name "LanzaAyuda"

; The file to write
OutFile "LanzaAyudaSetup.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\LanzaAyuda

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\LanzaAyuda" ""

;estilo
XPStyle on

;--------------------------------

; Pages

!define MUI_WELCOMEPAGE_TITLE  "Insalador de LanzaAyuda"
!define MUI_WELCOMEPAGE_TEXT "Esto solo llevaras unos minutos"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_UNPAGE_WELCOME
Page components
Page directory
Page instfiles

;!insertmacro MUI_UNPAGE_WELCOME
UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------
;idiomas
!insertmacro MUI_LANGUAGE "English"

; The stuff to install
Section "LanzaAyuda (required)"

  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  ; Put file there
  File "LanzaAyuda.7z"

  Nsis7z::ExtractWithDetails "$INSTDIR\LanzaAyuda.7z" "Instalando..."
	Delete "$OUTDIR\LanzaAyuda.7z"

  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\LanzaAyuda "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LanzaAyuda" "DisplayName" "NSIS LanzaAyuda"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LanzaAyuda" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LanzaAyuda" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LanzaAyuda" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\LanzaAyuda"
  CreateShortcut "$SMPROGRAMS\LanzaAyuda\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$SMPROGRAMS\LanzaAyuda\LanzaAyuda.lnk" "$INSTDIR\LanzaAyuda.jar"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\LanzaAyuda"
  DeleteRegKey HKLM SOFTWARE\NSIS_LanzaAyuda

  ; Remove files and uninstaller
  Delete $INSTDIR\LanzaAyuda.nsi
  Delete $INSTDIR\LanzaAyuda.jar
  Delete $INSTDIR\lib\*
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\LanzaAyuda\*"

  ; Remove directories
  RMDir "$SMPROGRAMS\LanzaAyuda"
  RMDir "$INSTDIR\lib"
  RMDir "$INSTDIR"

SectionEnd
