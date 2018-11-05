//
//  DDModifyUserNameCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDModifyUserNameCell.h"

@interface DDModifyUserNameCell()<UITextFieldDelegate>

@end

@implementation DDModifyUserNameCell


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(updateUserName:)])
    {
        [_delegate updateUserName:textField.text];
    }
}

- (IBAction)sexBtnClick:(UIButton *)sender
{
    NSInteger sex;
    if (sender.tag == 100)
    {
        self.womanBtn.selected = YES;
        self.manBtn.selected = NO;
        sex = 0;
    }
    else
    {
        self.manBtn.selected = YES;
        self.womanBtn.selected = NO;
        sex = 1;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUserSex:)])
    {
        [_delegate updateUserSex:sex];
    }
}

@end
