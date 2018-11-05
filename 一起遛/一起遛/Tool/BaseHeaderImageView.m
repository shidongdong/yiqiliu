//
//  BaseHeaderImageView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseHeaderImageView.h"

@implementation BaseHeaderImageView


- (void)layoutSubviews
{
    self.layer.cornerRadius = self.frame.size.width / 2;
     self.clipsToBounds= YES;
}

@end
