//
//  DDDogLostPicView.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/31.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDDogLostPicItemDelegate <NSObject>

- (void)reSelectImage;

@end


@interface DDDogLostPicItem : UIView

@property(nonatomic,weak)id<DDDogLostPicItemDelegate>delegate;
- (void)setItem:(UIImage *)image;

@end


@protocol DDDogLostPicViewDelegate <NSObject>

- (void)uploadPics:(NSArray *)pics;

@end

@interface DDDogLostPicView : UIView

@property(nonatomic,weak)id<DDDogLostPicViewDelegate>delegate;
@property(nonatomic,strong)UIViewController * presentViewController;

@end
