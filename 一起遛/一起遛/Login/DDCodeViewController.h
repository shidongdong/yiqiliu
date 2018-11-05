//
//  DDCodeViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTextField.h"

@interface DDCodeViewController : UIViewController
@property (weak, nonatomic) IBOutlet BaseTextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (nonatomic)BOOL isRegister;

@property (nonatomic,strong)NSString * mobile;
@property (nonatomic,strong)NSString * password;

@end
