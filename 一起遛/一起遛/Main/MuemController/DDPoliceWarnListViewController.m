//
//  DDPoliceWarnListViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/2.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDPoliceWarnListViewController.h"
#import "DDPoliceWarnCell.h"
#import "UIViewController+Customize.h"
#import "DDPetCircleArg.h"
#import "DDHTTPClient.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDPetCircleAck.h"
#import "UIImageView+WebCache.h"
#import "GlobConfig.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDPoliceWarnViewController.h"
@interface DDPoliceWarnListViewController()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray * pets;
@property(nonatomic,strong)NSMutableArray * selectCircles;
@property(nonatomic,strong)NSIndexPath * lastIndexPath;
@end


@implementation DDPoliceWarnListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"城管报警";
    self.nextBtn.enabled = NO;
    DDPetCircleArg * arg = [[DDPetCircleArg alloc] init];
    DDUserAck * ack = [[GlobData shareInstance] user];
    arg.userId = ack.content.id;
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDPetCircleAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        
        DDPetCircleAck * ack = (DDPetCircleAck *)response;
        [self.pets addObjectsFromArray:ack.content];
        [self.collectionView reloadData];
    }];
    
    [self.collectionView registerClass:[DDPoliceWarnCell class] forCellWithReuseIdentifier:@"newPoliceWarnCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DDPetCircleContent * content = [self.pets objectAtIndex:indexPath.row];
    DDPoliceWarnCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newPoliceWarnCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,content.pic]] placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    cell.nameLabel.text = content.name;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.collectionView.frame.size.width - 45 - 66) / 4;
    CGFloat height = 110;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 33, 0, 33);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDPetCircleContent * content = [self.pets objectAtIndex:indexPath.row];
    if (self.selectCircles.count == 1)
    {
        if ([self.selectCircles containsObject:content])
        {
            DDPoliceWarnCell * cell =  (DDPoliceWarnCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.seletedImageView.hidden = YES;
            [self.selectCircles removeObject:content];
            self.nextBtn.enabled = NO;
            return;
        }
        else
        {
            [self.selectCircles removeAllObjects];
            DDPoliceWarnCell * cell =  (DDPoliceWarnCell *)[collectionView cellForItemAtIndexPath:self.lastIndexPath];
            cell.seletedImageView.hidden = YES;
        }
        
    }
    self.nextBtn.enabled = YES;
    self.lastIndexPath = indexPath;
    DDPoliceWarnCell * cell =  (DDPoliceWarnCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.seletedImageView.hidden = NO;
    [self.selectCircles addObject:content];
}

- (IBAction)nextAction:(UIButton *)sender {
    
    if (self.selectCircles.count == 0)
    {
        [MBProgressHUD ShowTips:@"请选择通知1个圈子" delayTime:2.0 atView:nil];
        return;
    }
    [self performSegueWithIdentifier:@"PoliceWarnSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PoliceWarnSegue"])
    {
        DDPoliceWarnViewController * viewcontroller = segue.destinationViewController;
        viewcontroller.content = [self.selectCircles objectAtIndex:0];
        viewcontroller.coordinate = self.coordinate;
    }
}


#pragma mark -
#pragma mark getter

- (NSMutableArray *)pets
{
    if (!_pets)
    {
        _pets = [[NSMutableArray alloc] init];
    }
    return _pets;
}

- (NSMutableArray *)selectCircles
{
    if (!_selectCircles)
    {
        _selectCircles = [[NSMutableArray alloc] init];
    }
    return _selectCircles;
}

@end
