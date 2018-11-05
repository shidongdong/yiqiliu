//
//  DDDogKindViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogKindViewController.h"
#import "DDHTTPClient.h"
#import "DDDogKindArg.h"

#import "UIViewController+Customize.h"
static NSString * cellId = @"DogKindViewControllerCell";

@interface DDDogKindViewController()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)NSMutableArray * sourceArray;
@property(nonatomic,strong)NSMutableArray * sections;
@property(nonatomic,strong)NSMutableArray * sectionIndexs;
@property(nonatomic,strong)NSMutableArray * searchList;
@end

@implementation DDDogKindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sourceArray = [[NSMutableArray alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    self.sectionIndexs = [[NSMutableArray alloc] init];
    
    [self addDefaultLeftBarItem];
    self.title = @"狗狗品种";
    
    DDDogKindArg * arg = [[DDDogKindArg alloc] init];
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDDogKindAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        DDDogKindAck * ack = (DDDogKindAck *)response;
        [self.sourceArray addObjectsFromArray:ack.content];
        //整理数据
        [self prepareDataForReload:self.sourceArray];
    }];
}

- (void)searchDog:(NSString *)name
{
    if (!self.searchList)
    {
        self.searchList = [[NSMutableArray alloc] init];
    }
    
    [self.searchList removeAllObjects];
    
    for (int i = 0; i < self.sourceArray.count; i++)
    {
        DDDog * dog = [self.sourceArray objectAtIndex:i];
        
        if ([[dog.shortName lowercaseString] isEqualToString:[name lowercaseString]] || [dog.name containsString:name])
        {
            [self.searchList addObject:dog];
        }
        
    }
    [self prepareDataForReload:self.searchList];
    
}

- (void)prepareDataForReload:(NSArray * )sources
{
    [self.sections removeAllObjects];
    [self.sectionIndexs removeAllObjects];
    NSString * indexString;
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < sources.count; i++)
    {
        DDDog * dog = [sources objectAtIndex:i];
        if (i == 0)
        {
            indexString = dog.shortName;
            [self.sectionIndexs addObject:indexString];
        }
        
        if ([dog.shortName isEqualToString:indexString])
        {
            [tmpArray addObject:dog];
        }
        else
        {
            indexString = dog.shortName;
            [self.sections addObject:tmpArray];
            tmpArray = [[NSMutableArray alloc] init];
            [tmpArray addObject:dog];
            [self.sectionIndexs addObject:indexString];
        }
    }
    if ([tmpArray count] > 0)
    {
        [self.sections addObject:tmpArray];
    }
    
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * rows = [self.sections objectAtIndex:section];
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSArray * rows = [self.sections objectAtIndex:indexPath.section];
    DDDog * dog = [rows objectAtIndex:indexPath.row];
    cell.textLabel.text = dog.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionIndexs objectAtIndex:section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexs;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray * rows = [self.sections objectAtIndex:indexPath.section];
    DDDog * dog = [rows objectAtIndex:indexPath.row];
    self.dog = dog;
    [self performSegueWithIdentifier:self.backSegue sender:dog];
}

#pragma mark -
#pragma mark UISearchBarDelegate
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    [self searchDog:searchBar.text];
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    return YES;
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        [self prepareDataForReload:self.sourceArray];
    }
    else
    {
        [self searchDog:searchText];
    }
    
}

//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    [self prepareDataForReload:self.sourceArray];
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    [self searchDog:searchBar.text];
//}

@end
