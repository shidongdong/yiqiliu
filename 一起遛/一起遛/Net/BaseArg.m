//
//  BaseArg.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@implementation BaseArg

- (NSString *)reqURL
{
    return @"www.fartherClass";
}

- (NSString *)reqMethod
{
    return @"POST";
}

- (BOOL)reqLoading
{
    return YES;
}

- (BOOL)reqErrorToast
{
    return YES;
}

- (NSTimeInterval)reqTimeOut
{
    return 20.0;
}


@end
