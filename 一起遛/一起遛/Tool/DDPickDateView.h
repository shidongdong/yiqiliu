//
//  DDPickDateView.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDPickDateViewDelegate <NSObject>

- (void)uploadBirthdayInfo:(NSDate *)date;

@end

@interface DDPickDateView : UIView

@property(nonatomic,weak)id<DDPickDateViewDelegate>delegate;

- (void)showPickView;

- (void)hidePickView;

@end
