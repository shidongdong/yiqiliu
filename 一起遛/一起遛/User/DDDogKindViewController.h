//
//  DDDogKindViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDogKindAck.h"

@interface DDDogKindViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,copy) NSString * backSegue;

@property (nonatomic ,strong)DDDog * dog;

@end
