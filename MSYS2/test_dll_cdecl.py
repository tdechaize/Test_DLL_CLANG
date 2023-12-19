#    file : testdll_cdecl.py 

import ctypes, ctypes.util
from ctypes import *
import os
import sys
if len( sys.argv ) == 1:
    print( "testdll_cdecl.py script wrote by Thierry DECHAIZE, thierry.dechaize@gmail.com" )
    print( "\tusage: python3 testdll_cdecl.py Name_Dll." )
    exit()

cwd = os.getcwd()
dll_name = cwd + '\\' + sys.argv[1]
print(dll_name)
mydll_path = ctypes.util.find_library(dll_name)
if not mydll_path:
    print("Unable to find the specified DLL.")
    sys.exit()
    
os.add_dll_directory(cwd)
# mydll = ctypes.CDLL(dll_name)          # load the dll __cdecl    
try:    
    mydll = ctypes.WinDLL(dll_name)      # load the dll __stdcall
except OSError:
    print(f"Unable to load the specified DLL : {dll_name}.")
    sys.exit()

# Our 'ctypes' wrapper around the DLL function -- this is where we
# convert Python types to C types and call the DLL function.
def print_hello(w,i):
    func = mydll.print_hello
    func.argtypes = [ctypes.c_char_p, ctypes.c_int]
    p = create_string_buffer(i)
    p.value = bytes(w, 'utf-8')
    func(p, i)

string = 'my name is Thierry DECHAIZE ...'
print_hello(string, len(string))