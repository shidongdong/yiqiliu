//
//  BaseTextField.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/23.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseTextField.h"
#import "UIColor+DDColor.h"
@implementation BaseTextField

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self drawBroder];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self drawBroder];
    }
    return self;
}


- (void)drawBroder
{
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [UIColor mainColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
