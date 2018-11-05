//
//  DDModifyCircleNameViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCircleDetailAck.h"

@protocol DDModifyCircleNameViewControllerDelegate <NSObject>

- (void)updateUserName:(NSString *)name;

@end

@interface DDModifyCircleNameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) DDCircleDetailContent * content;

@property(nonatomic, weak)id<DDModifyCircleNameViewControllerDelegate>delegate;

@end
