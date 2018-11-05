//
//  DDUploadLocationArg.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/23.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDUploadLocationArg.h"

@implementation DDUploadLocationArg

- (NSString *)reqURL
{
    return @"/circle/sendDogLocation";
}

- (BOOL)reqLoading
{
    return NO;
}

- (BOOL)reqErrorToast
{
    return NO;
}

@end
