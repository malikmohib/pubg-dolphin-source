//
//  PictureQuality.m
//  Patch
//
//  Created by yiming on 2022/5/25.
//

#import "PictureQuality.h"

static NSString *kPictureCoding = @"";
static NSString *kfile = @"/Documents/ShadowTrackerExtra/Saved/Config/IOS/UserCustom.ini";
static NSString *k120 = @"\n+CVars=r.PUBGDeviceFPSLow=6\n+CVars=r.PUBGDeviceFPSMid=6\n+CVars=r.PUBGDeviceFPSHigh=6\n+CVars=r.PUBGDeviceFPSHDR=6";

@implementation PictureQuality

+ (void)load
{
    // 仅次于iPad 测试使用 120刷新率
    if (![self isiPad]) return;
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kfile];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isExistence = [fileManager fileExistsAtPath:filePath];
    if (isExistence) {
        NSLog(@"[yiming] UserCustom.ini 文件存在");
        
        // 保存原来配置内容
        kPictureCoding = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];

        // 写入新的配置内容
        NSString *content = [NSString stringWithFormat:@"%@%@", kPictureCoding, k120];
        [[content dataUsingEncoding:NSUTF8StringEncoding] writeToFile:filePath atomically:YES];
    }
}

+ (BOOL)isiPad
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
        return YES;
    }
    return NO;
}

@end
