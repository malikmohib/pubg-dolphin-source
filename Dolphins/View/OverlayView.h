//
//  DrawView.h
//  PubgDolphins
//
//  Created by XBK on 2022/4/24.
//
#import "UIView+YYAdd.h"


#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <DrawWindow.h>
#import <MenuWindow.h>

#include "imgui_impl_metal.h"

#include "module_tools.h"

#include "imgui_tools.h"

NS_ASSUME_NONNULL_BEGIN

@interface OverlayView : MTKView <MTKViewDelegate>

@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) MTKTextureLoader *loader;

@property (nonatomic, assign) ModuleControl *moduleControl;

@property (nonatomic, strong) DrawWindow *drawWindow;
@property (nonatomic, strong) MenuWindow *menuWindow;

- (instancetype)initWithFrame:(CGRect)frame :(ModuleControl*)control :(DrawWindow*)draw :(MenuWindow*)menu;

@end

NS_ASSUME_NONNULL_END
