//
//  UIImage+ColorAtPixel.h
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"

@interface UIImage (ColorAtPixel)

/**
 *  获取当前点的颜色，直接返回颜色
 *
 *  @param point 当前点
 *
 *  @return 颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

/**
 *  获取当前点的颜色
 *
 *  @param point 当前点
 *
 *  @return 颜色RGB
 */
- (RGBType)colorAtPixel2:(CGPoint)point;

@end
