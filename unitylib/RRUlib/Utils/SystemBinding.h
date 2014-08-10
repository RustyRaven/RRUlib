#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <mach/mach_host.h>

typedef void (*CallbackTestDelegate)();

void _DoSomething(CallbackTestDelegate cb);
unsigned int _GetMemoryUsage();
unsigned int _GetFreeMemory();
