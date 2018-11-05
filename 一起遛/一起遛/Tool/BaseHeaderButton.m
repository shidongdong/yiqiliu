//
//  BaseHeaderButton.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseHeaderButton.h"

@implementation BaseHeaderButton

- (void)drawRect:(CGRect)rect
{
    self.imageView.layer.cornerRadius = self.frame.size.width / 2;
}

@end
