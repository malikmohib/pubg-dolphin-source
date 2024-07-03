//
//  memory_tools.cpp
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#include "memory_tools.h"

bool MemoryTools::memoryMove(void *dst, const void *src, size_t count) {
    // 容错处理
    if (src == NULL || dst == NULL) {
        return false;
    }
    unsigned char *pdst = (unsigned char *) dst;
    const unsigned char *psrc = (const unsigned char *) src;
    if (psrc == NULL) {
        return false;
    }
    //判断内存是否重叠
    bool flag1 = (pdst >= psrc && pdst < psrc + count);
    bool flag2 = (psrc >= pdst && psrc < pdst + count);
    if (flag1 || flag2) {
        // 倒序拷贝
        while (count) {
            *(pdst + count - 1) = *(psrc + count - 1);
            count--;
        }//while
    } else {
        // 拷贝
        while (count--) {
            *pdst = *psrc;
            pdst++;
            psrc++;
        }//while
    }
    return true;
}

bool MemoryTools::memoryCopy(void *dst, const void *src, size_t count) {
    if (src == NULL || dst == NULL) {
        return false;
    }
    char *tmp_dst = (char *) dst;
    char *tmp_src = (char *) src;
    if (tmp_src == NULL) {
        return false;
    }
    while (count--) {
        *tmp_dst++ = *tmp_src++;
    }
    
    return true;
}
/* 读内存 */
bool MemoryTools::readMemory(uintptr_t address, size_t size, void *buffer) {
    memset(buffer, 0, size);
    if (address <= 0x100000000 || address >= 0x2000000000 /*||address % PointSize != 0)*/) {
        return false;
    }
   // if (isMincore(address, size) != 1) {
   //     return false;
   // }
    return memoryMove(buffer, (void *) address, size);
  //  return pvm(reinterpret_cast<void *>(address), buffer, size, false);
}

/* 读内存 */
bool MemoryTools::writeMemory(uintptr_t address, size_t size, void *buffer) {
    if (address <= 0x100000000 || address >= 0x2000000000) {
        return false;
    }
   // if (isMincore(address, size) != 1) {
   //     return false;
   // }
    return memcpy((void *) address, buffer, size);
}

uintptr_t MemoryTools::readPtr(uintptr_t addr) {
    uintptr_t value = 0;
    readMemory(addr, sizeof(uintptr_t), &value);
    return value;
}

int MemoryTools::readInt(uintptr_t addr) {
    int value = 0;
    readMemory(addr, sizeof(int), &value);
    return value;
}

float MemoryTools::readFloat(uintptr_t addr) {
    float value = 0;
    readMemory(addr, sizeof(float), &value);
    return value;
}

void MemoryTools::writePtr(uintptr_t addr, uintptr_t wAddr) {
    writeMemory(addr, sizeof(uintptr_t), &wAddr);
}

void MemoryTools::writeFloat(uintptr_t addr, float value) {
    writeMemory(addr, sizeof(float), &value);
}
