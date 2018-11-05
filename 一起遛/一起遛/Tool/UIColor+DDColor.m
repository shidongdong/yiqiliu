//
//  UIColor+DDColor.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/23.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "UIColor+DDColor.h"

@implementation UIColor (DDColor)

+ (UIColor *)hexChangeFloat:(NSString *)hexColor withAlpha:(CGFloat)alpha
{
    if ([hexColor length]<6) {
        return nil;
    }
    
    unsigned int red_, green_, blue_;
    NSRange exceptionRange;
    exceptionRange.length = 2;
    
    //red
    exceptionRange.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:exceptionRange]]scanHexInt:&red_];
    
    //green
    exceptionRange.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:exceptionRange]]scanHexInt:&green_];
    
    //blue
    exceptionRange.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:exceptionRange]]scanHexInt:&blue_];
    
    UIColor *resultColor = [UIColor colorWithRed:(CGFloat)red_/255. green:(CGFloat)green_/255. blue:(CGFloat)blue_/255. alpha:alpha];
    return resultColor;
}

+ (UIColor *)hexChangeFloat:(NSString *)hexColor
{
    return [self hexChangeFloat:hexColor withAlpha:1];
}

+ (UIColor *)mainColor
{
    return [UIColor hexChangeFloat:@"4FAAD8"];
}

+ (UIColor *)bgGrayColor
{
    return [UIColor hexChangeFloat:@"E5E5E5"];
}

+ (UIColor *)bgColor
{
    return [UIColor hexChangeFloat:@"F5F5F5"];
}

+ (UIColor *)textColor
{
    return [UIColor hexChangeFloat:@"060606"];
}

+ (UIColor *)text2Color
{
    return [UIColor hexChangeFloat:@"888888"];
}

+ (UIColor *)text4Color
{
    return [UIColor hexChangeFloat:@"DCDCDC"];
}

+ (UIColor *)text3Color
{
    return [UIColor hexChangeFloat:@"2e2d2d"];
}

+ (UIColor *)imageborderColor
{
    return [UIColor hexChangeFloat:@"18FFFF"];
}

@end
