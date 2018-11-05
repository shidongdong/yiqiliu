//
//  DDUserAnnotation.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface DDUserAnnotation : MAPointAnnotation

@property(nonatomic)NSInteger userID;
@property(nonatomic)NSString * header;
@end
