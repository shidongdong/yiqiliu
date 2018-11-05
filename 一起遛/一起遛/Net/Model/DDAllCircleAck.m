//
//  DDAllCircleAck.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/10.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDAllCircleAck.h"

@implementation DDAllCircleUser

@end

@implementation DDAllCirclePet

@end

@implementation DDAllCircleContent

- (BOOL)isEqualContnet:(DDAllCircleContent *)content
{
//    if (![self.address isEqualToString:content.address])
//    {
//        return NO;
//    }
    
//    if (self.id != content.id)
//    {
//        return NO;
//    }
    
    if (self.isJoin != content.isJoin)
    {
        return NO;
    }
    
    if (self.latitude != content.latitude)
    {
        return NO;
    }
    
    if (self.longitude != content.longitude)
    {
        return NO;
    }
    
//    if (![self.name isEqualToString:content.name])
//    {
//        return NO;
//    }
//    
//    if (self.petNum != content.petNum)
//    {
//        return NO;
//    }
    
    
    
    return YES;
}

@end

@implementation DDAllCircleAck

@end
