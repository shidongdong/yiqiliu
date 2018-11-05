//
//  DDMessage.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDJSONModel.h"
@interface DDMessage : DDJSONModel

@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger type;
@property(nonatomic)NSInteger uId;
@property(nonatomic)NSInteger cId;
@property(nonatomic,copy)NSString * cName;
@property(nonatomic)NSInteger pId;
@property(nonatomic,copy)NSString * pNick;
@property(nonatomic,copy)NSString * pPic;
@property(nonatomic)NSInteger g;
@property(nonatomic,copy)NSString * t;
@property(nonatomic,copy)NSString * ad;
@property(nonatomic,copy)NSString * url;
@property(nonatomic,copy)NSString * b;
@property(nonatomic,copy)NSString * content;

@end
