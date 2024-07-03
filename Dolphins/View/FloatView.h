//
//  SmallButton.h
//  PubgDolphins
//
//  Created by XBK on 2022/4/24.
//
#import "UIView+YYAdd.h"
#include "module_tools.h"
NS_ASSUME_NONNULL_BEGIN

@interface FloatView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint didMoveLocation;

@property (nonatomic, assign) ModuleControl *moduleControl;

- (instancetype)initWithFrame:(CGRect)frame :(ModuleControl*)control;

- (void)iconOnClick;

@end

NS_ASSUME_NONNULL_END
