//
//  DDModifyDogNameViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDModifyDogNameViewControllerDelegate <NSObject>

- (void)updateDogName:(NSString *)dogName;

@end

@interface DDModifyDogNameViewController : UIViewController

@property(nonatomic,weak)id<DDModifyDogNameViewControllerDelegate>delegate;
@property(nonatomic,copy)NSString * name;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
