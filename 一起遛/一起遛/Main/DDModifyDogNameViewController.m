//
//  DDModifyDogNameViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDModifyDogNameViewController.h"
#import "UIViewController+Customize.h"
@implementation DDModifyDogNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"修改昵称";
    [self addRightBarItemWithImageName:@"confirm_n"];
    self.textField.text = self.name;
}

- (void)rightBarItemAction:(id)sender
{
    [self.textField resignFirstResponder];
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateDogName:)])
    {
        [_delegate updateDogName:self.textField.text];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
