//
//  UIColor+Convert.h
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Convert)

/**
 *  根据十六进制字符串转换为UIColor
 *
 *  @param hex 十六进制字符串
 *  @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hex alpha:(CGFloat)alpha;

@end
