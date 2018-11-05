//
//  DDDogInfoCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogInfoCell.h"

@interface DDDogInfoCell()<UITextFieldDelegate>

@end

@implementation DDDogInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerClick)];
//        [self.headerImageView addGestureRecognizer:tap];
//        
//        self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.width / 2;
//        self.headerImageView.layer.borderWidth = 2.0;
//        self.headerImageView.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (void)awakeFromNib
{
    
}


- (IBAction)headerClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showPhonoTool)])
    {
        [_delegate showPhonoTool];
    }
}

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
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateDogSex:)])
    {
        [_delegate updateDogSex:sex];
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(updateDogName:)])
    {
        [_delegate updateDogName:textField.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
