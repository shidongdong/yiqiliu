//
//  DDAdviseViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDAdviseViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "DDAdviseArg.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "MBProgressHUD+DDHUD.h"
@interface DDAdviseViewController()<UITextFieldDelegate>

@end

@implementation DDAdviseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    [self addRightBarItemWithImageName:@"confirm_n"];
    self.title = @"意见反馈";
}

- (void)rightBarItemAction:(id)sender
{
    [self.textField resignFirstResponder];
    
    if (self.textField.text.length == 0)
    {
        [MBProgressHUD ShowTips:@"请输入反馈内容" delayTime:2.0 atView:nil];
        return;
    }
    
    
    DDAdviseArg * arg = [[DDAdviseArg alloc] init];
    DDUserAck * user = [[GlobData shareInstance] user];
    arg.content = self.textField.text;
    arg.userId = user.content.id;
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
