//
//  DDCheckPhoneViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"
typedef NS_ENUM(NSInteger,checkPhoneType) {
    DD_ForgetPwd_Type = 0,
    DD_Register_Type,
};


@interface DDCheckPhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet BaseTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet BaseTextField *passwordTextField;
@property(nonatomic)checkPhoneType type;

@end
