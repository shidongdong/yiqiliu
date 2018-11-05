//
//  UIViewController+Customize.m
//  GuanHealth
//
//  Created by hermit on 15/2/28.
//  Copyright (c) 2015年 wensihaihui. All rights reserved.
//

#import "UIViewController+Customize.h"

@implementation UIViewController (Customize)

- (void)addDefaultLeftBarItem
{
    [self addLeftBarItemWithImageName:@"topic_back_n" highlightImageName:@"topic_back_p"];
}

- (void)addLeftBarItemWithTitle:(NSString*)title
{
    UIButton *barButton = [self buttonWithTitle:title];
    [barButton addTarget:self action:@selector(leftBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:barButton];
    [[self HFNavigationItem]setLeftBarButtonItem:item];
}

- (void)addLeftBarItemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName
{
    UIButton *barButton = [self buttonWithImage:imageName highlightImageName:highlightImageName];
    [barButton addTarget:self action:@selector(leftBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:barButton];
    [[self HFNavigationItem]setLeftBarButtonItem:item];
}

- (void)addLeftBarItemWithCustomView:(UIView *)view
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    [[self HFNavigationItem]setLeftBarButtonItem:item];
}

- (void)leftBarItemAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addRightBarItemWithTitle:(NSString*)title
{
    UIButton *btn = [self buttonWithTitle:title];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self HFNavigationItem]setRightBarButtonItem:item];
}

- (void)addRightBarItemWithTitle:(NSString*)title color:(UIColor *)color
{
    UIButton *btn = [self buttonWithTitle:title];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [[self HFNavigationItem]setRightBarButtonItem:item];
}

- (void)addRightBarItemWithImageName:(NSString *)imageName
{
    UIButton *btn = [self buttonWithImage:imageName highlightImageName:imageName];
    [btn addTarget:self action:@selector(rightBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [[self HFNavigationItem]setRightBarButtonItem:item];
}

- (void)addRightBarItemWithCustomView:(UIView *)view
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    [[self HFNavigationItem]setRightBarButtonItem:item];
}

- (void)rightBarItemAction:(id)sender
{
    
}

- (void)addNavigationTitle:(NSString*)title
{
    [[self HFNavigationItem]setTitleView:nil];
    [[self HFNavigationItem]setTitle:title];
}

- (void)setNavigationTitleView:(UIView *)titleView
{
    [[self HFNavigationItem]setTitleView:titleView];
}

- (UINavigationItem *)HFNavigationItem
{
    if (self.tabBarController)
    {
        return self.tabBarController.navigationItem;
    }
    else
    {
        return self.navigationItem;
    }
}

- (UIButton *)buttonWithTitle:(NSString *)title
{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [title sizeWithAttributes:attributes];
    CGFloat width = size.width<30?30:size.width;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
    [btn setTitle:title forState:UIControlStateNormal];
    [[btn titleLabel]setFont:[UIFont systemFontOfSize:16]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    return btn;
}

- (UIButton *)buttonWithImage:(NSString *)imageName highlightImageName:(NSString *)highlightImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightImage forState:UIControlStateHighlighted];
    return btn;
}

@end
