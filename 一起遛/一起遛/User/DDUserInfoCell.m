//
//  DDUserInfoCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDUserInfoCell.h"

@interface DDUserInfoCell()<UITextFieldDelegate>

@end


@implementation DDUserInfoCell

- (IBAction)sexbtnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    
    NSInteger sex = 0;
    
    if (btn.tag == 100)
    {
        sex = 1;
        self.manBtn.selected = YES;
        self.womanBtn.selected = NO;
    }
    else
    {
        sex = 0;
        self.manBtn.selected = NO;
        self.womanBtn.selected = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateSex:)])
    {
        [_delegate updateSex:sex];
    }
    
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(updateNickName:)])
    {
        [_delegate updateNickName:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
