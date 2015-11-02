//
//  ViewController.m
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "ViewController.h"
#import "YJHColorPickerHSWheel.h"
#import "YJHColorPickerHSWheel2.h"

@interface ViewController ()

@property (nonatomic, weak) YJHColorPickerHSWheel *colorWheel;
@property (nonatomic, weak) YJHColorPickerHSWheel2 *colorWheel2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_SetUpWheel];
    
}

/**
 *  初始化圆形取色板
 */
- (void) p_SetUpWheel{
    // 方法一：使用UIControl的beginTrackingWithTouch，continueTrackingWithTouch和endTrackingWithTouch来获取颜色
//    YJHColorPickerHSWheel *wheel = [[YJHColorPickerHSWheel alloc] initWithFrame:CGRectMake(40, 15, 240, 240)];
//    [wheel addTarget:self action:@selector(colorWheelColorChanged:) forControlEvents:UIControlEventValueChanged];
//    self.colorWheel = wheel;
    
    // 方法二：使用拖拽手势和敲击手势来做移动获取颜色
    YJHColorPickerHSWheel2 *wheel2 = [[YJHColorPickerHSWheel2 alloc] initWithFrame:CGRectMake(40, 15, 240, 240)];
    self.colorWheel2 = wheel2;
    wheel2.confirmBlock = ^(UIColor *color) {
        self.view.backgroundColor = color;
    };
    [self.view addSubview:wheel2];
    
}

- (void) colorWheelColorChanged:(YJHColorPickerHSWheel *)wheel {
    // 根据取到的颜色设施背景颜色
    self.view.backgroundColor = self.colorWheel.currentColor;
    
}


@end
