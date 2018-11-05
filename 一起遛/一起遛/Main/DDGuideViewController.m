//
//  DDGuideViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDGuideViewController.h"
#import "UIColor+DDColor.h"
#import "GlobData.h"
#import "AppDelegate.h"
#define GiudePageNum  3

@interface DDGuideViewController()<UIScrollViewDelegate>
{
    UIPageControl * pageControl;
}
@end


@implementation DDGuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * GiudePageNum, self.view.frame.size.height);
    [self.view addSubview:scrollView];
    
    //page1
    for (int i = 0; i < GiudePageNum; i++)
    {
        UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSString * guideName = [NSString stringWithFormat:@"guide_%d",i + 1];
        view.image = [UIImage imageNamed:guideName];
        [scrollView addSubview:view];
        
        if (i == GiudePageNum - 1)
        {
            view.userInteractionEnabled = YES;
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"beginuse"] forState:UIControlStateNormal];
            button.frame = CGRectMake(self.view.frame.size.width / 2 - 42, self.view.frame.size.height - 80, 83, 31);
            [button addTarget:self action:@selector(beginUseAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
    }
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 20, self.view.frame.size.height - 30, 40, 10)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.tintColor = [UIColor blueColor];
    [self.view addSubview:pageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}

- (void)beginUseAction
{
    [[GlobData shareInstance] saveVersionGuide];
    AppDelegate * app = [[UIApplication sharedApplication] delegate];
    [app goLoginViewController];
}

@end
