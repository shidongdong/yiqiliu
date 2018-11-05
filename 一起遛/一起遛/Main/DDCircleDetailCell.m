//
//  DDCircleDetailCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCircleDetailCell.h"

@implementation DDCircleDetailCell

- (IBAction)headerClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showPicTool)])
    {
        [_delegate showPicTool];
    }
}

@end
