//
//  log.cpp
//  Dolphins
//
//  Created by XBK on 2022/4/26.
//

#include "log.h"

void selfLog(const char* format,...){
    char text[10240];
    va_list argList;
    va_start(argList, format);
    vsprintf(text, format,argList);
    va_end(argList);
    NSLog(@"[%s] %s","Dolphins",text);
}


//将串s1中的子串s2替换成串s3
char* replace(char*s1,char*s2,char*s3){
    char *p,*from,*to,*begin=s1;
    int c1,c2,c3,c;         //串长度及计数
    c2=strlen(s2);
    c3=(s3!=NULL)?strlen(s3):0;
    if(c2==0)return s1;     //注意要退出
    while(true)             //替换所有出现的串
    {
        c1=strlen(begin);
        p=strstr(begin,s2); //出现位置
        if(p==NULL)         //没找到
            return s1;
        if(c2>c3)           //串往前移
        {
            from=p+c2;
            to=p+c3;
            c=c1-c2+begin-p+1;
            while(c--)
                *to++=*from++;
        }
        else if(c2<c3)      //串往后移
        {
            from=begin+c1;
            to=from-c2+c3;
            c=from-p-c2+1;
            while(c--)
                *to--=*from--;
        }
        if(c3)              //完成替换
        {
            from=s3,to=p,c=c3;
            while(c--)
                *to++=*from++;
        }
        begin=p+c3;         //新的查找位置
    }
}
