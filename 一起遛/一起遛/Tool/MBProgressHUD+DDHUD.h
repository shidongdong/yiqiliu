//
//  MBProgressHUD+DDHUD.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (DDHUD)

+ (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView;

@end
