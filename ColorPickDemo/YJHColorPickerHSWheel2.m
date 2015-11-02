//
//  YJHColorPickerHSWheel2.m
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/11/2.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  方法二：使用拖拽手势和敲击手势来做移动获取颜色

#import "YJHColorPickerHSWheel2.h"
#import "UIImage+ColorAtPixel.h"
#import "HSV.h"
#import "UIColor+Convert.h"

@interface YJHColorPickerHSWheel2()

@property (nonatomic, weak) UIImageView *wheelImageView;

@property (nonatomic, weak) UIImageView *wheelKnobView;

@property (nonatomic, assign) HSVType currentHSV;

// 旧的颜色十六进制
@property (nonatomic, copy) NSString *oldColorHex;

// 当前选中的颜色十六进制
@property (nonatomic, copy) NSString *currentColorHex;

@end

@implementation YJHColorPickerHSWheel2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 初始化取色板图片
        //        UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pickerColorWheel.png"]];
        UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"color.png"]];
        wheel.contentMode = UIViewContentModeTopLeft;
        wheel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:wheel];
        self.wheelImageView = wheel;
        
        UIImageView *wheelKnob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
        [self addSubview:wheelKnob];
        self.wheelKnobView = wheelKnob;
        
        self.currentHSV = HSVTypeMake(0, 0, 1);
        
        // 拖拽手势
        UIPanGestureRecognizer *panGestureRecognizer;
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.wheelImageView addGestureRecognizer:panGestureRecognizer];
        
        // 敲击手势
        UITapGestureRecognizer *tapGestureRecognizer;
        tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.wheelImageView addGestureRecognizer:tapGestureRecognizer];
        self.wheelImageView.userInteractionEnabled = YES;
        
    }
    
    return self;
}

/**
 *  根据移动的点计算currentHSV
 *
 *  @param point 移动到的点
 */
- (void) p_mapPointToColor:(CGPoint) point {
    CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
                                 self.wheelImageView.bounds.size.height * 0.5);
    double radius = self.wheelImageView.bounds.size.width * 0.5;
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
    if (isnan(angle))
        angle = 0.0;
    
    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist/radius, 1.0);
    
    if (dist < 10)
        saturation = 0; // snap to center
    
    if (point.x < center.x)
        angle = M_PI - angle;
    
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
    
    // 设置currentHSV的值
    self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);

}

/**
 *  根据hsv移动色块
 *
 */
- (void) setCurrentHSV:(HSVType)hsv {
    _currentHSV = hsv;
    _currentHSV.v = 1.0;
    double angle = _currentHSV.h * 2.0 * M_PI;
    CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
                                 self.wheelImageView.bounds.size.height * 0.5);
    double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
    radius *= _currentHSV.s;
    
    CGFloat x = center.x + cosf(angle) * radius;
    CGFloat y = center.y - sinf(angle) * radius;
    
    x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
    y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
    self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
}


/**
 *  拖动手势
 *
 */
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self.wheelImageView];
        [self p_mapPointToColor:tapPoint];
        
        RGBType rgba = [self.wheelImageView.image colorAtPixel2:tapPoint];
        NSInteger hex = RGB_to_HEX(rgba.r, rgba.g, rgba.b);
        self.oldColorHex = [NSString stringWithFormat:@"0x%06lx", (long)hex];
        
        // 当颜色不一样时才回调
        if (![self.oldColorHex isEqualToString:self.currentColorHex]) {
            self.confirmBlock([UIColor colorWithHexString:_oldColorHex alpha:1.f]);
            self.currentColorHex = self.oldColorHex;
        }
        
        
        
    }
}


/**
 *  轻触手势
 *
 */
- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self.wheelImageView];
        [self p_mapPointToColor:tapPoint];
        
        RGBType rgba = [self.wheelImageView.image colorAtPixel2:tapPoint];
        NSInteger hex = RGB_to_HEX(rgba.r, rgba.g, rgba.b);
        self.oldColorHex = [NSString stringWithFormat:@"0x%06lx", (long)hex];
        
        // 当颜色不一样时才回调
        if (![self.oldColorHex isEqualToString:self.currentColorHex]) {
            self.confirmBlock([UIColor colorWithHexString:_oldColorHex alpha:1.f]);
            self.currentColorHex = self.oldColorHex;
        }
    }
}

@end
