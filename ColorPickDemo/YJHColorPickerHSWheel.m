//
//  YJHColorPickerHSWheel.m
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//  方法一：使用UIControl的beginTrackingWithTouch，continueTrackingWithTouch和endTrackingWithTouch来获取颜色

#import "YJHColorPickerHSWheel.h"
#import "UIImage+ColorAtPixel.h"
#import "HSV.h"
#import "UIColor+Convert.h"

@interface YJHColorPickerHSWheel()

@property (nonatomic, weak) UIImageView *wheelImageView;

@property (nonatomic, weak) UIImageView *wheelKnobView;

@property (nonatomic, assign) HSVType currentHSV;

@end

@implementation YJHColorPickerHSWheel

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
        
        self.userInteractionEnabled = YES;
        self.currentHSV = HSVTypeMake(0, 0, 1);
        
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
    
    // 发送值改变通知
    [self sendActionsForControlEvents:UIControlEventValueChanged];
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
 *  获取当前点的color值
 *
 *  @param mousepoint 当前点
 */
- (void) p_getCurrentColorWithPoint:(CGPoint) mousepoint {
    RGBType rgba = [self.wheelImageView.image colorAtPixel2:mousepoint];
    NSInteger hex = RGB_to_HEX(rgba.r, rgba.g, rgba.b);
    NSLog(@"r-%f,g-%f,b-%f", rgba.r, rgba.g, rgba.b);
    NSString *hexString = [NSString stringWithFormat:@"0x%06lx", (long)hex];
    NSLog(@"%@", hexString);
    self.currentColor = [UIColor colorWithHexString:hexString alpha:1];
}


#pragma mark - Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint mousepoint = [touch locationInView:self];
    
    // 如果不在圆内，直接返回
    if (!CGRectContainsPoint(self.wheelImageView.frame, mousepoint)) {
        return NO;
    }
    
    [self p_mapPointToColor:[touch locationInView:self.wheelImageView]];
    [self p_getCurrentColorWithPoint:mousepoint];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint mousepoint = [touch locationInView:self];
    [self p_mapPointToColor:[touch locationInView:self.wheelImageView]];
    [self p_getCurrentColorWithPoint:mousepoint];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self continueTrackingWithTouch:touch withEvent:event];
}


@end
