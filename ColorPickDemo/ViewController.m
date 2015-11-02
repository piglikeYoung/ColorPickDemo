//
//  ViewController.m
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import "ViewController.h"
#import "YJHColorPickerHSWheel.h"

@interface ViewController ()

@property (nonatomic, weak) YJHColorPickerHSWheel *colorWheel;

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
    YJHColorPickerHSWheel *wheel = [[YJHColorPickerHSWheel alloc] initWithFrame:CGRectMake(40, 15, 240, 240)];
    
    [wheel addTarget:self action:@selector(colorWheelColorChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:wheel];
    self.colorWheel = wheel;
}

- (void) colorWheelColorChanged:(YJHColorPickerHSWheel *)wheel {
    // 根据取到的颜色设施背景颜色
    self.view.backgroundColor = self.colorWheel.currentColor;
    
}


@end
