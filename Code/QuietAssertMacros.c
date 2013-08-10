//
//  QuietAssertMacros.c
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

// Xcode5-DP5 spams the console like crazy. This is a workaround.
// https://devforums.apple.com/message/861797 see post #11 by 0xced

#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "fishhook.h"

int quiet_fprintf(FILE * restrict stream, const char * restrict format, ...)
{
    if (strncmp(format, "AssertMacros:", 13) == 0) {
        return 0;
    }
    va_list args;
    va_start(args, format);
    int result = vfprintf(stream, format, args);
    va_end(args);
    return result;
}

__attribute__((constructor)) void QuietAssertMacros(void)
{
    rebind_symbols((struct rebinding[1]){{ "fprintf", quiet_fprintf }}, 1);
}
