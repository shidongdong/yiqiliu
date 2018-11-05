//
//  DDOSSArg.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDOSSArg.h"

@implementation DDOSSArg

- (NSString *)reqURL
{
    return @"/common/ossbucket";
}

- (BOOL)reqErrorToast
{
    return NO;
}

- (BOOL)reqLoading
{
    return NO;
}

@end
