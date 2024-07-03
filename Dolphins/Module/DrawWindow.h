//
//  DrawWindow.h
//  Dolphins
//
//  Created by XBK on 2022/4/24.
//

#import <UIKit/UIKit.h>

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#include <vector>

#include "stb_image.h"

#include "module_tools.h"

#include "imgui_tools.h"

#include "dolphins.h"

#include "log.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawWindow : NSObject

@property (nonatomic, assign) ModuleControl *moduleControl;

- (instancetype)initWithFrame:(ModuleControl*)control;

-(void)drawDrawWindow;

-(void)initImageTexture: (id<MTLDevice>)device;

-(id<MTLTexture>)loadImageTexture:(id<MTLDevice>)device :(void*) imageData :(size_t) fileDataSize;

@end

NS_ASSUME_NONNULL_END
