//
//  DDModifyCircleNoticeViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCircleDetailAck.h"

@protocol DDModifyCircleNoticeViewControllerDelegate <NSObject>

- (void)updateNoticeToUserInfo:(NSString *)notice;

@end

@interface DDModifyCircleNoticeViewController : UIViewController

@property (nonatomic,strong) DDCircleDetailContent * content;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,weak)id<DDModifyCircleNoticeViewControllerDelegate>delegate;

@end
