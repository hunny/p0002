//
//  iphoneTests.m
//  iphoneTests
//
//  Created by 杨 国旗 on 13-8-18.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "iphoneTests.h"
#import "NotificationDAO.h"
#import "SystemCoreProfile.h"

@implementation iphoneTests

- (void)setUp
{
    [super setUp];
    
    NSLog(@" I am yangguoqi ");
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSample
{
    NSLog(@"hello world !!!");
    
    NSString *id=[NSString stringWithFormat:@"100%zi",(arc4random() % 10000)];
    NSDictionary *dictionary =[NSDictionary dictionaryWithObjectsAndKeys:
                               @"001",@"identify"
                               ,@"水果",@"key"
                               ,@"罗汉果",@"name"
                               ,@"全部",@"credit"
                               ,@"2013-08-25 00:38:06",@"time"
                               ,@"全部",@"saleType"
                               ,nil];
    
    
    id=[NSString stringWithFormat:@"100%zi",(arc4random() % 10000)];
    NSDictionary *dictionary2 =[NSDictionary dictionaryWithObjectsAndKeys:
                                @"002",@"identify"
                                ,@"水果",@"key"
                                ,@"龙虾",@"name"
                                ,@"全部",@"credit"
                                ,@"2013-08-24 00:38:06",@"time"
                                ,@"全部分类",@"saleType"
                                ,nil];
    
    
    
    NotificationDAO *notificationDao=[NotificationDAO new];
    [notificationDao getLocalNotificationInfo];
}



@end
