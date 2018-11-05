//
//  DDCircleCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCircleCell.h"

@implementation DDCircleCell

- (IBAction)showAllAction:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(showAllPetsAction)])
    {
        [_delegate showAllPetsAction];
    }
}

@end
