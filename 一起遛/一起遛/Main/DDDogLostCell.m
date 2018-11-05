//
//  DDDogLostCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/31.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogLostCell.h"

@interface DDDogLostCell()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation DDDogLostCell


- (IBAction)sexClick:(UIButton *)sender
{
    NSInteger sex = 0;
    
    if (sender.tag == 100)
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
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateLostDogSex:)])
    {
        [_delegate updateLostDogSex:sex];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.reuseIdentifier isEqualToString:@"lostDogNameID"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateNickName:)])
        {
            [_delegate updateNickName:textField.text];
        }
    }
    if ([self.reuseIdentifier isEqualToString:@"lostDogPhoneID"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(updatePhone:)])
        {
            [_delegate updatePhone:textField.text];
        }
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.reuseIdentifier isEqualToString:@"lostDogContentID"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateLostInfo:)])
        {
            [_delegate updateLostInfo:textView.text];
        }
    }
}

@end
