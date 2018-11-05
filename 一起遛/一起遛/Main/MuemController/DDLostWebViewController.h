//
//  DDLostWebViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/28.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDLostWebViewController : UIViewController

@property(nonatomic,copy)NSString * lostURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
