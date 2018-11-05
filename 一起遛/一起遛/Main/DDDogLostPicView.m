//
//  DDDogLostPicView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/31.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogLostPicView.h"
#import "Masonry.h"
#import "GlobConfig.h"
#import "MBProgressHUD+DDHUD.h"
#import "TKPicSelectTool.h"
#import "DDHTTPClient.h"
@interface DDDogLostPicItem()
{
    
}
@property(nonatomic,strong)UIImageView * dogView;
@end

@implementation DDDogLostPicItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    WS(weakSelf)
    self.dogView = [[UIImageView alloc] init];
    [self addSubview:self.dogView];
    [self.dogView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    UIButton * tapBtn = [[UIButton alloc] init];
    tapBtn.backgroundColor = [UIColor clearColor];
    [tapBtn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tapBtn];
    [tapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
}

- (void)tapClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(reSelectImage)])
    {
        [_delegate reSelectImage];
    }
}

- (void)setItem:(UIImage *)image
{
    self.dogView.image = image;
}

@end


@interface DDDogLostPicView()<TKPicSelectDelegate,DDDogLostPicItemDelegate>
{
    UIButton * addButton;
    
    TKPicSelectTool * tool;
}
@property(nonatomic,strong)NSMutableArray * images;
@end

@implementation DDDogLostPicView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self iniDefultUI];
    }
    return self;
}

- (void)iniDefultUI
{
    tool = [[TKPicSelectTool alloc] init];
    tool.selectDelegate = self;
    
    
    for (int i = 0; i < 1; i++) {
        DDDogLostPicItem * item =[[DDDogLostPicItem alloc] initWithFrame:CGRectZero];
        item.tag = 100 + i;
        item.delegate = self;
        [self addSubview:item];
    }
    
    
    if (!addButton)
    {
        WS(weakSelf)
        addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addButton setImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addButton];
        [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(63, 63));
            make.left.equalTo(weakSelf.mas_left).with.offset(23);
            make.top.equalTo(weakSelf.mas_top).with.offset(0);
        }];
    }
}

- (void)setPresentViewController:(UIViewController *)presentViewController
{
    tool.viewController = presentViewController;
}

- (void)deleteItem:(UIImage *)image
{
    [self.images removeObject:image];
}

- (void)addAction
{
//    if ([self.images count] == 1)
//    {
//        [MBProgressHUD ShowTips:@"照片已达上限" delayTime:2.0 atView:nil];
//        return;
//    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [tool doSelectPic:@"选择图片来源" clipping:NO maxSelect:1];
}

#pragma mark -
#pragma mark TKPicSelectDelegate
- (void)onImagesSelect:(NSArray *)images
{
    if (self.images.count == 0)
    {
        for (NSInteger i = 0; i < images.count; i++)
        {
            UIImage * image = [images objectAtIndex:i];
            DDDogLostPicItem * item = [self viewWithTag:100 +self.images.count];
            item.dogView.image = image;
            item.frame = CGRectMake(23 +  self.images.count * (63 + 10), 0, 63, 63);
            [self.images addObject:image];
        }
    }
    else
    {
        [self.images removeAllObjects];
        for (NSInteger i = 0; i < images.count; i++)
        {
            UIImage * image = [images objectAtIndex:i];
            DDDogLostPicItem * item = [self viewWithTag:100 +self.images.count];
            item.dogView.image = image;
            [self.images addObject:image];
        }
    }
    
    
   // addButton.frame = CGRectMake(15 + self.images.count * (63 + 10), 0, 63, 63);
    
    if (self.images.count > 0)
    {
        addButton.hidden = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(uploadPics:)])
    {
        [_delegate uploadPics:self.images];
    }
}

-(void)onImageSelect:(UIImage *)image
{
    if (self.images.count == 0)
    {
        DDDogLostPicItem * item = [self viewWithTag:100 + self.images.count];
        item.dogView.image = image;
        item.frame = CGRectMake(23 + self.images.count * (63 + 10), 0, 63, 63);
        [self.images addObject:image];
    }
    else
    {
        [self.images removeAllObjects];
        DDDogLostPicItem * item = [self viewWithTag:100 + self.images.count];
        item.dogView.image = image;
        [self.images addObject:image];
        
    }
    
  //  addButton.frame = CGRectMake(15 + self.images.count * (63 + 10), 0, 63, 63);
    
    if (self.images.count > 0)
    {
        addButton.hidden = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(uploadPics:)])
    {
        [_delegate uploadPics:self.images];
    }
    
}

//- (void)deleteItemWithImage:(UIImage *)image
//{
//    NSInteger index = [self.images indexOfObject:image];
//    DDDogLostPicItem * item = [self viewWithTag:100 + index];
//    item.frame = CGRectZero;
//    [self.images removeObject:image];
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(uploadPics:)])
//    {
//        [_delegate uploadPics:self.images];
//    }
//}

- (void)reSelectImage
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [tool doSelectPic:@"选择图片来源" clipping:NO maxSelect:1];
}

#pragma mark -
#pragma mark getter

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}


@end
