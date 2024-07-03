//
//  MenuWindow.h
//  Dolphins
//
//  Created by XBK on 2022/4/25.
//

#import <UIKit/UIKit.h>



#include "imgui.h"

#include "module_tools.h"

#include "imgui_tools.h"

#include "ini_rw.h"

@class OverlayView;

NS_ASSUME_NONNULL_BEGIN

@interface MenuWindow : NSObject

@property (nonatomic, assign) ModuleControl *moduleControl;

- (instancetype)initWithFrame:(ModuleControl*)control;

-(void)setOverlayView:(OverlayView*)ov;
//绘制菜单窗口
-(void)drawMenuWindow;
//显示系统信息页面
-(void)showSystemInfo;
//人物功能控制
-(void) showPlayerControl;
//物资功能控制
-(void) showMaterialControl;
//自瞄控制
-(void) showAimbotControl;
//读Ini配置
-(void)readIniConfig;

@end

NS_ASSUME_NONNULL_END
