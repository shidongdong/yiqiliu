//
//  DDModifyCircleNoticeViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDModifyCircleNoticeViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "DDModifyCircleArg.h"
#import "DDUserAck.h"
#import "GlobData.h"
@interface DDModifyCircleNoticeViewController()<UITextViewDelegate>

@end

@implementation DDModifyCircleNoticeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    [self addRightBarItemWithImageName:@"confirm_n"];
    self.title = @"地盘公告";
    self.textView.text = self.content.announcement;
    
}

- (void)rightBarItemAction:(id)sender
{
    
    [self.textView resignFirstResponder];
    
    DDModifyCircleArg * arg = [[DDModifyCircleArg alloc] init];
    arg.userId = [[GlobData shareInstance] user].content.id;
    arg.name = self.content.name;
    arg.announcement = self.textView.text;
    arg.pic = self.content.pic;
    arg.id = self.content.id;
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            if (_delegate && [_delegate respondsToSelector:@selector(updateNoticeToUserInfo:)])
            {
                [_delegate updateNoticeToUserInfo:self.textView.text];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length > 300 && text.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
