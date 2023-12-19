@echo off
REM    Source of this example here : https://mottosso.gitbooks.io/clang/content/building_a_dynamic_library.html
SET PATHINIT=%PATH%
echo.  ******************      Debut de la generation avec MSYS2 / CLANG 64 bits    *******************
REM      MANDATORY : add binary path of version CLANG included in MSYS2 
set PATH=C:\msys64\mingw64\bin;C:\GetGnuWin32\bin;%PATH%
REM 	Affichage de la version de CLANG 	-> to see "real" version of CLANG compiler (just one time, at beginning of this script)
clang++ --version | grep "clang version"
REM Options used with CLANG/LLVM compiler 64 bits (very similar with syntax of gcc compiler) :
REM 	-Wall									-> set all warning during compilation
REM		-c 										-> compile and assemble only, not call of linker
REM 	-o helloworld64.obj 					-> output of object file indicated just after this option 
REM 	-Dxxxxxx								-> define variable xxxxxx used by preprocessor of compiler CLANG C/C++
REM		-m64									-> set compilation to X64 Architecture (64 bits)
REM 	-IC:\msys64\mingw64\lib\clang\17\include -> set the include path directory (you can add many option -Ixxxxxxx to adapt your list of include path directories)  
REM 				Remark 1 : You can replace option -m32 by -m64 to "force" compilation or linkage to X64 architecture
echo.  ***************       Compilation seule de la DLL avec MSYS2 / CLANG 64 bits      *****************
clang++ -Wall -c -o helloworld.obj helloworld.cpp -DNDEBUG -D_USRDLL -D_WINDLL -m64 -IC:\msys64\mingw64\lib\clang\17\include -IC:\msys64\mingw64\x86_64-w64-mingw32\include
REM Options used with linker CLANG/LLVM :
REM 	-s 										-> "s[trip]", remove all symbol table and relocation information from the executable. 
REM		-shared									-> generate a shared library => on Window, generate a DLL (Dynamic Linked Library)
REM 	-LC:\msys64\mingw32\lib					-> -Lxxxxxxxxxx set library path directory to xxxxxxxxxxx (you can add many option -Ixxxxxxx to adapt your list of library path directories)  
REM		-Wl,--output-def=dll_clang.def  		-> set the output definition file, normal extension is xxxxx.def
REM		-Wl,--out-implib=helloworldlibadd.a 	-> set the output library file. On Window, you can choose library name beetween "normal name" (xxxxx.lib), or gnu library name (libxxxxx.a)
REM		-Wl,--dll								-> -Wl,... set option ... to the linker, here determine subsystem to windows DLL
REM 	-o helloworld.dll						-> output of executable file indicated just after this option, here relative name of DLL
REM		-m64									-> set linkage to X64 Architecture (64 bits)
REM		-lkernel32 -luser32						-> -lxxxxxxxx set library used by linker to xxxxxxxxx
echo.  ***************          Edition de liens de la DLL avec MSYS2 / CLANG 64 bits        *******************
clang++ -s -shared -LC:\msys64\mingw64\lib -LC:\msys64\mingw64\x86_64-w64-mingw32\lib -Wl,--output-def=dll_clang64.def -Wl,--out-implib=libhelloworld.a -Wl,--dll -o helloworld.dll -m64 -lkernel32 -luser32 helloworld.obj 
type dll_clang64.def
echo.  ***************              Listage des fonctions exportees de la DLL              *******************
REM  dump result of command "gendef" to stdout, here, with indirection of output ">", generate file dll_clang64_2.def
gendef - helloworld.dll > dll_clang64_2.def
type dll_clang64_2.def
REM        Lancement du test de la DLL en Python 
echo.  ***************            Lancement du script python de test de la DLL             *******************
REM 	Affichage de la version de PYTHON 	-> to see "real" version of PYTHON (just one time, at the end of this script)
%PYTHON64% version.py
%PYTHON64% testdll_cdecl_init.py helloworld.dll
:FIN
SET PATH=%PATHINIT%
