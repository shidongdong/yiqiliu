//
//  GlobConfig.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#ifndef GlobConfig_h
#define GlobConfig_h

//一些比较方便的宏定义
#define  IMG(x)          [UIImage imageNamed:x]
//请求地址定义
//#define  kBaseURL        @"http://121.41.16.13:8080"
#define  kBaseURL        @"https://www.dogtogether.cn"
#define  kPicBaseURL     @"http://img.dogtogether.cn"
//是否采用HTTPS请求
#define TURN_ON_HTTPS    1

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* GlobConfig_h */
