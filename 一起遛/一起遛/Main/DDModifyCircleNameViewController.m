//
//  DDModifyCircleNameViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDModifyCircleNameViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "DDModifyCircleArg.h"
#import "DDUserAck.h"
#import "GlobData.h"
@implementation DDModifyCircleNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    [self addRightBarItemWithImageName:@"confirm_n"];
    self.title = @"地盘名称";
    self.textField.text = self.content.name;
}

- (void)rightBarItemAction:(id)sender{
    
    [self.textField resignFirstResponder];
    
    DDModifyCircleArg * arg = [[DDModifyCircleArg alloc] init];
    arg.userId = [[GlobData shareInstance] user].content.id;
    arg.id = self.content.id;
    arg.name = self.textField.text;
    arg.announcement = self.content.announcement;
    arg.pic = self.content.pic;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(updateUserName:)])
            {
                [_delegate updateUserName:self.textField.text];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CirCleNameUpdateNotify" object:self.textField.text];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
