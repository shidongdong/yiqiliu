//
//  DDDBCenter.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDBCenter.h"
#import "FMDB.h"

@interface DDDBCenter()
{
    FMDatabase * fmdb;
}
@end

@implementation DDDBCenter

+ (instancetype)shareInstance
{
    static DDDBCenter* share = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        share = [[self alloc] init];
        
    });
    return share;
}

- (NSString *)dateBasePath
{
    NSArray * pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * dir = [pathArray objectAtIndex:0];
    NSString * dbPath = [dir stringByAppendingPathComponent:@"yiqi6.sqlite"];
    return dbPath;
}

- (void)getLocalDBdatebase
{
    
    fmdb = [FMDatabase databaseWithPath:[self dateBasePath]];
}

- (void)createDBTables
{
    if (![fmdb open]) {
        NSLog(@"打开数据库失败!");
    }
    
    if (![fmdb tableExists:@"MESSAGELIST"]) {
        if (![fmdb executeUpdate:@"CREATE TABLE MESSAGELIST (ID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE INTEGER,UID INTEGER, CID INTEGER,CNAME TEXT, PID INTEGER, PNICK TEXT, PPIC TEXT, G INTEGER, T INTEGER, AD TEXT, URL TEXT, B TEXT, CONTENT TEXT)"]) {
            NSLog(@"创建messagelist table 失败！");
        }
    }
    
    [fmdb close];
}


- (NSArray *)getDDMessageList
{
    //先去获取本地数据库->打开数据库->取出table的数值
    if (!fmdb) {
        [self getLocalDBdatebase];
        
        if (!fmdb)
        {
            NSLog(@"无法获取本地数据库!");
            return nil;
        }
    }
    
    [self createDBTables];
    
    if (![fmdb open])
    {
        NSLog(@"打开数据库失败!");
        return nil;
    }
    //增加查询效率
    [fmdb setShouldCacheStatements:YES];
    
    NSMutableArray * messageList = [[NSMutableArray alloc] init];
    FMResultSet * habitSet = [fmdb executeQuery:@"SELECT * FROM MESSAGELIST"];
    while ([habitSet next]) {
        DDMessage * message = [[DDMessage alloc] init];
        message.type = [habitSet intForColumnIndex:1];
        message.uId = [habitSet intForColumnIndex:2];
        message.cId = [habitSet intForColumnIndex:3];
        message.cName = [habitSet stringForColumnIndex:4];
        message.pId = [habitSet intForColumnIndex:5];
        message.pNick = [habitSet stringForColumnIndex:6];
        message.pPic = [habitSet stringForColumnIndex:7];
        message.g = [habitSet intForColumnIndex:8];
        message.t = [habitSet stringForColumnIndex:9];
        message.ad = [habitSet stringForColumnIndex:10];
        message.url = [habitSet stringForColumnIndex:11];
        message.b = [habitSet stringForColumnIndex:12];
        message.content = [habitSet stringForColumnIndex:13];
    }
    [fmdb close];
    return messageList;
}

- (void)addDDMessage:(DDMessage *)message
{
    if (!fmdb) {
        [self getLocalDBdatebase];
        
        if (!fmdb)
        {
            NSLog(@"无法获取本地数据库!");
            return;
        }
    }
    
    [self createDBTables];
    
    if (![fmdb open])
    {
        NSLog(@"打开数据库失败!");
    }
    
    
    
}

- (void)deleteDDMessage:(DDMessage *)message
{
    if (![fmdb open]) {
        NSLog(@"打开数据库失败!");
    }
    
    if ([fmdb tableExists:@"MESSAGELIST"])
    {
        [fmdb executeUpdate:@"DELETE FROM MESSAGELIST WHERE ID = "];
    }
}

@end
