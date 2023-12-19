@echo off
REM    Source of this example here : https://mottosso.gitbooks.io/clang/content/building_a_dynamic_library.html
SET PATHINIT=%PATH%
echo.  ******************      Debut de la generation avec CLANG 32 bits + VS2022 + Kits Windows          *******************
REM      MANDATORY : add binary path of version CLANG + VS2022 + Kits Windows and binary path to tools gnu ported on Windows
set PATH=%LLVM%\bin;C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x86;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx86\x86;C:\GetGnuWin32\bin;%PATH%
REM 	Affichage de la version de CLANG 	-> to see "real" version of CLANG compiler (just one time, at beginning of this script)
clang --version | grep "clang version"
REM Options used with CLANG/LLVM compiler 32 bits (very similar with syntax of Visual C/C++ compiler) :
REM 	/Dxxxxxxx								-> add a define variable used by preprocessor, here to advise compiler about generation of DLL
REM 		/D_WINDLL 									-> signifie que la compilation est destinée à une DLL
REM			/D_USRDLL 									-> signifie que vous créez une DLL MFC standard 
REM		/MT                     				-> Use static run-time
REM 	/link xxxxx yyyyy .... 					-> set options to the linker. Two options are passed to linker :
REM 		  /DLL										-> set option to indicate generation of DLL
REM 		  /OUT:helloworld.dll 						-> name of output file, here name of DLL 
echo.  ***************   Compilation et edition de liens de la DLL avec CLANG 32 bits + VS2022 + Kits Windows   *****************
clang-cl /D_USRDLL /D_WINDLL helloworld.cpp /MT /link /DLL /OUT:helloworld.dll
echo.  ***************                    Listage des fonctions exportees de la DLL                            *******************
REM  dump result of command "dumpbin" to stdout
dumpbin.exe /exports helloworld.dll
REM        Lancement du test de la DLL en Python 
echo.  ***************                    Lancement du script python de test de la DLL                         *******************
REM 	Affichage de la version de PYTHON 	-> to see "real" version of PYTHON (just one time, at the end of this script)
%PYTHON32% version.py
%PYTHON32% testdll_cdecl_init.py helloworld.dll
:FIN
SET PATH=%PATHINIT%
