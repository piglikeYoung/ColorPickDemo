//
//  UIColor+Convert.h
//  ColorPickDemo
//
//  Created by piglikeyoung on 15/10/26.
//  Copyright © 2015年 pikeYoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Convert)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
