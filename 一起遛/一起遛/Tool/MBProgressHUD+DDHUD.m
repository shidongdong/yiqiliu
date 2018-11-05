//
//  MBProgressHUD+DDHUD.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "MBProgressHUD+DDHUD.h"

@implementation MBProgressHUD (DDHUD)

+ (void) ShowTips:(NSString*)strTips  delayTime:(NSTimeInterval)delay  atView:(UIView*)pView
{
    if (strTips == nil || strTips.length == 0)
    {
        return;
    }

    if (pView == NULL)
    {
        pView = [[UIApplication sharedApplication] keyWindow];
    }
    MBProgressHUD* hud = [self showHUDAddedTo:pView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = strTips;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

@end
