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
Name "AppHotel"

; The file to write
OutFile "AppHotelSetup.exe"

; Request application privileges for Windows Vista and higher
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES\AppHotel

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\AppHotel" ""

;estilo
XPStyle on

;--------------------------------

; Pages

!define MUI_WELCOMEPAGE_TITLE  "Insalador de AppHotel"
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
Section "AppHotel (required)"

  SectionIn RO
  
  ; Set output path to the installation directory. AppHotel
  SetOutPath $INSTDIR
  
  ; Put file there
  File "AppHotel.7z"

  Nsis7z::ExtractWithDetails "$INSTDIR\AppHotel.7z" "Instalando..."
	Delete "$OUTDIR\AppHotel.7z"

  
  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\AppHotel "Install_Dir" "$INSTDIR"
  
  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "DisplayName" "NSIS AppHotel"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"
  
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

  CreateDirectory "$SMPROGRAMS\AppHotel"
  CreateShortcut "$SMPROGRAMS\AppHotel\Uninstall.lnk" "$INSTDIR\uninstall.exe"
  CreateShortcut "$SMPROGRAMS\AppHotel\AppHotel.lnk" "$INSTDIR\signedAppHotel.jar"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"
  
  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\AppHotel"
  DeleteRegKey HKLM SOFTWARE\NSIS_AppHotel

  ; Remove files and uninstaller
  Delete $INSTDIR\AppHotel.nsi
  Delete $INSTDIR\signedAppHotel.jar
  Delete $INSTDIR\*
  Delete $INSTDIR\lib\*
  Delete $INSTDIR\uninstall.exe

  ; Remove shortcuts, if any
  Delete "$SMPROGRAMS\AppHotel\*"

  ; Remove directories
  RMDir "$SMPROGRAMS\AppHotel"
  RMDir "$INSTDIR\lib"
  RMDir "$INSTDIR"

SectionEnd
