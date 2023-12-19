#include <stdio.h>
// #include <wchar.h>

extern "C" {

__declspec(dllexport)
void print_hello(const char* u, int i) {
    wprintf(L"Hello, %s\n", u);
}

} // extern "C"