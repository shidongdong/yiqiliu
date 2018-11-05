//
//  DDUserCenterCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDUserCenterCell.h"

@implementation DDUserCenterCell
- (IBAction)followBtnClick:(UIButton *)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(followBtnAction:)])
    {
        [_delegate followBtnAction:sender];
    }
}

- (IBAction)headerClick:(BaseHeaderButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(headerBtnAction)])
    {
        [_delegate headerBtnAction];
    }
}

- (IBAction)sexBtnClick:(UIButton *)sender {
    
    NSInteger dogsex;
    if (sender.tag == 100)
    {
        self.womanBtn.selected = YES;
        self.manBtn.selected = NO;
        dogsex = 0;
    }
    else
    {
        self.womanBtn.selected = NO;
        self.manBtn.selected = YES;
        dogsex = 1;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateDogSex:)])
    {
        [_delegate updateDogSex:dogsex];
    }
}

@end
