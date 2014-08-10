#import "SystemBinding.h"

void _DoSomething(CallbackTestDelegate cb) {
    NSLog(@"do something in ios");
    cb();
}

unsigned int _GetMemoryUsage() {
	struct task_basic_info info;
	mach_msg_type_number_t size = sizeof(info);
	kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
	if( kerr == KERN_SUCCESS ) {
		return info.resident_size;
	} else {
		return 0;
	}
}

unsigned int _GetFreeMemory() {
	mach_port_t host_port;
	mach_msg_type_number_t host_size;
	vm_size_t pagesize;
	host_port = mach_host_self();
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
	host_page_size(host_port, &pagesize);
	vm_statistics_data_t vm_stat;
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
		return 0;
	}
	natural_t mem_free = vm_stat.free_count * pagesize;
	return mem_free;
}
