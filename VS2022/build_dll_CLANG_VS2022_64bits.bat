@echo off
REM    Source of this example here : https://mottosso.gitbooks.io/clang/content/building_a_dynamic_library.html
SET PATHINIT=%PATH%
echo.  ******************      Debut de la generation avec CLANG 64 bits + VS2022 + Kits Windows          *******************
REM      MANDATORY : add binary path of version LLVM/CLANG binaries, and Software Development Kit of Windows and Visual Studio 2022 Community. 
set PATH=%LLVM64%\bin;C:\Program Files (X86)\Windows Kits\%KIT_WIN_VERSION%\bin\%KIT_WIN_NUM%\x64;C:\Program Files\Microsoft Visual Studio\%VS_VERSION%\Community\VC\Tools\MSVC\%VS_NUM%\bin\Hostx64\x64;C:\GetGnuWin32\bin;%PATH%
REM 	Affichage de la version de CLANG 	-> to see "real" version of CLANG compiler (just one time, at beginning of this script)
clang --version | grep "clang version"
REM Options used with CLANG/LLVM compiler 64 bits, here clone of "CL" command of Visual C/C++ (very similar with syntax of Visual C/C++ compiler) :
REM 	/Dxxxxxxx								-> add a define variable used by preprocessor, here to advise compiler about generation of DLL
REM 		/D_WINDLL 									-> signifie que la compilation est destinée à une DLL
REM			/D_USRDLL 									-> signifie que vous créez une DLL MFC standard 
REM		/MT                     				-> Use static run-time
REM 	-target x86_64-pc-windows-msvc			-> option specific at CLANG compiler to design target of generation, here a triplet (x86_64, pc-windows, msvc), not compatible with VC/VC++
REM 	/link xxxxx yyyyy .... 					-> set options to the linker. Two options are passed to linker :
REM 		  /DLL										-> set option to indicate generation of DLL
REM 		  /OUT:helloworld64.dll 					-> name of output file, here name of DLL 
echo.  ***************   Compilation et edition de liens de la DLL avec CLANG 64 bits + VS2022 + Kits Windows   *****************
clang-cl /D_USRDLL /D_WINDLL helloworld.cpp /MT -target x86_64-pc-windows-msvc /link /DLL /OUT:helloworld64.dll
echo.  ***************                    Listage des fonctions exportees de la DLL                            *******************
REM  dump result of command "dumpbin" to stdout
dumpbin.exe /exports helloworld64.dll
REM        Lancement du test de la DLL en Python 
echo.  ***************            Lancement du script python de test de la DLL             *******************
REM 	Affichage de la version de PYTHON 	-> to see "real" version of PYTHON (just one time, at the end of this script)
%PYTHON64% version.py
%PYTHON64% testdll_cdecl_init.py helloworld64.dll
:FIN
SET PATH=%PATHINIT%
