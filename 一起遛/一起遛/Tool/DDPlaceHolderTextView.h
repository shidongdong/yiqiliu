//
//  DDPlaceHolderTextView.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/25.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface DDPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
