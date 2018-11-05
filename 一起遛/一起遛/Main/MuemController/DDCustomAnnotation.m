//
//  DDCustomAnnotation.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/10.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCustomAnnotation.h"

@implementation DDCustomAnnotation


- (NSMutableArray *)userAnnotations
{
    if (!_userAnnotations)
    {
        _userAnnotations = [[NSMutableArray alloc] init];
    }
    return _userAnnotations;
}


@end
