//
//  memory_tools.hpp
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#ifndef memory_tools_hpp
#define memory_tools_hpp

#include<dlfcn.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

class MemoryTools {
private:
    int pageSize = getpagesize();
public:
    int isMincore(uintptr_t,size_t);
    
    bool memoryMove(void *dst, const void *src, size_t count);
    
    bool memoryCopy(void *dst, const void *src, size_t count);
    
    bool readMemory(uintptr_t addr, size_t size, void *buffer);
    
    bool writeMemory(uintptr_t address, size_t size, void *buffer);
    
    uintptr_t readPtr(uintptr_t addr);
    
    int readInt(uintptr_t addr);
    
    float readFloat(uintptr_t addr);
    
    void writePtr(uintptr_t addr, uintptr_t wAddr);
    
    void writeFloat(uintptr_t addr, float value);
};

#endif /* memory_tools_hpp */
