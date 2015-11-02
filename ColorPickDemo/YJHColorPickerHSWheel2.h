//
//  YJHColorPickerHSWheel2.h
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/11/2.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

// 选好色块的回调block
typedef void (^ColorBoardConfirmBlock)(UIColor *color);

@interface YJHColorPickerHSWheel2 : UIView

@property (nonatomic, copy) ColorBoardConfirmBlock confirmBlock;

@end
