//
//  DDModifyUserNameViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDModifyUserNameViewController.h"
#import "UIViewController+Customize.h"
#import "DDModifyUserNameCell.h"
@interface DDModifyUserNameViewController()<UITableViewDelegate,UITableViewDataSource,DDModifyUserNameCellDelegate>
{
    
}
@end

@implementation DDModifyUserNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人信息";
    [self addDefaultLeftBarItem];
    [self addRightBarItemWithImageName:@"confirm_n"];
}

- (void)rightBarItemAction:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateUserName:withUserSex:)])
    {
        [_delegate updateUserName:self.name withUserSex:self.sex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDModifyUserNameCell * cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"modifyUserNameID"];
        cell.textField.text = self.name;
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"modifyUserSexID"];
        cell.delegate  = self;
        if (self.sex == 0)
        {
            cell.womanBtn.selected = YES;
            cell.manBtn.selected = NO;
        }
        else
        {
            cell.womanBtn.selected = NO;
            cell.manBtn.selected = YES;
        }
    }
    return cell;
}

- (void)updateUserName:(NSString *)name
{
    self.name = name;
}

- (void)updateUserSex:(NSInteger)sex
{
    self.sex = sex;
}

@end
