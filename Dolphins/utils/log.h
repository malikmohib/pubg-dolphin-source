//
//  log.hpp
//  Dolphins
//
//  Created by XBK on 2022/4/26.
//

#ifndef log_hpp
#define log_hpp

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

void selfLog(const char* format,...);
//将串s1中的子串s2替换成串s3
char* replace(char*s1,char*s2,char*s3=NULL);
#endif /* log_hpp */
