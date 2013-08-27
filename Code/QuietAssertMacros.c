//
//  QuietAssertMacros.c
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

// Xcode5-DP5 and DP6 spam the console like crazy. This is a workaround.
// https://gist.github.com/OdNairy/6219906

#include <stdio.h>
#include <string.h>

typedef int (*writer)(void *, const char *, int);
static writer _oldWriter;

static int quiet_writer(void *fd, const char *buffer, int size)
{
    if (strncmp(buffer, "AssertMacros: queueEntry", 24) == 0) {
        return size;
    }
    return _oldWriter(fd, buffer, size);
}

__attribute__((constructor)) void QuietAssertMacros(void)
{
    _oldWriter = stderr->_write;
    stderr->_write = quiet_writer;
}
