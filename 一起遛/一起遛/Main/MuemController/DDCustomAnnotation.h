//
//  DDCustomAnnotation.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/10.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "DDAllCircleAck.h"
@interface DDCustomAnnotation : MAPointAnnotation
@property(nonatomic,strong)DDAllCircleContent * content;
@property(nonatomic,strong)NSMutableArray * userAnnotations;
@end
