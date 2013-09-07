//
//  NotificationDAO.m
//  iphone
//
//  Created by 杨 国旗 on 13-8-24.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "NotificationDAO.h"
#import "SystemCoreProfile.h"
#import "StringUtil.h"
#import "UrlParamUtil.h"
#import "NSData+Base64.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"

@implementation NotificationDAO


- (void)getLocalNotificationInfo
{
    NSUserDefaults *shareMap = [NSUserDefaults standardUserDefaults];

    // 判断id和deviceId是否有值
    //bool isHasValue=(nil != [shareMap valueForKey:USER_LOGIN_ID]) && (nil != [shareMap valueForKey:DEVICE_ID]);
    if (nil == [shareMap valueForKey:USER_LOGIN_ID] || nil == [shareMap valueForKey:USER_LOGIN_ID]) {
        return;
    }
    NSString *request_url=[NSString stringWithFormat:@"%@/assistant/subscribe.html?id=%@&_m=%@",[shareMap valueForKey:ACCP_MAIN_PAGE_INPUT],[shareMap valueForKey:USER_LOGIN_ID],[shareMap valueForKey:DEVICE_ID]];
    
    //NSLog(@"%@ ====  deviceId%@  %d",[shareMap valueForKey:USER_LOGIN_ID],[shareMap valueForKey:DEVICE_ID],isHasValue);
    
    
    NSLog(@"notification data =============== request %@",request_url);
    
    //"http://192.168.1.82:8080/xone-app/assistant/subscribe.html?id=2&_m=1E8283A655F8E349D49EF2B287621AF1"
    
    ASIHTTPRequest *loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:request_url]];
                                    
    loginRequest.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [loginRequest setDidFailSelector:@selector(loginRequestDidFailedSelector:)];
    [loginRequest setDidStartSelector:@selector(loginRequestDidStartSelector:)];
    [loginRequest setDidFinishSelector:@selector(loginRequestDidFinishSelector:)];
    [loginRequest addRequestHeader:@"User-Agent" value:[StringUtil getUserAgent:@""]];
    [loginRequest setDelegate:self];
    [loginRequest startSynchronous];
}

- (void)loginRequestDidFailedSelector:(ASIHTTPRequest *)loginRequest
{
    NSLog(@"loginRequestDidFailedSelector=================");
}

- (void)loginRequestDidStartSelector:(ASIHTTPRequest *)loginRequest
{
    NSLog(@"loginRequestDidStartSelector===============");
}

- (void) loginRequestDidFinishSelector:(ASIHTTPRequest *)loginRequest
{
    NSLog(@"loginRequestDidFinishSelector===============");
    NSString *responseStr=[loginRequest responseString];
    
    //NSLog(@"responseStr===============%@",responseStr);
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseStr options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //<item identify="001" market="" key="user001" saleType="type001" credit="杨国旗">龙虾</item>
    
    //获取根节点下的节点（User）
    NSArray *infos = [rootElement elementsForName:@"date"];
    GDataXMLElement *myInfo = [infos objectAtIndex:0];
    // 获取name节点的值
    NSString *time = [myInfo stringValue];
    NSLog(@"myInfo date is:%@",time);
    
    //获取根节点下的节点（User）
    NSArray *items = [rootElement elementsForName:@"items"];
    GDataXMLElement *item = [items objectAtIndex:0];
    NSArray *itemNodes = [item elementsForName:@"item"];
    NSDictionary *dict=nil;
    NSUserDefaults *shareMap=[NSUserDefaults standardUserDefaults];
    NSString *identify=nil;
    NSString *key=nil;
    NSString *market=nil;
    NSString *credit=nil;
    NSString *saleType=nil;
    NSString *name=nil;
    
    NSMutableArray *arrTemp=[shareMap objectForKey:SHARE_NOTIFICATIONS];
    
    NSMutableArray *arrNotification=[NSMutableArray new];
    
    for (int i=0; i<[arrTemp count]; i++) {
        [arrNotification addObject:(NSDictionary *)[arrTemp objectAtIndex:i]];
    }
    
    //NSMutableArray *arrNotification=[[shareMap objectForKey:SHARE_NOTIFICATIONS] mutableCopy];

    for (GDataXMLElement *node in itemNodes) {
        identify=[[node attributeForName:@"identify"] stringValue];
        key=[[node attributeForName:@"key"] stringValue];
        market=[[node attributeForName:@"market"] stringValue];
        credit=[[node attributeForName:@"credit"] stringValue];
        saleType=[[node attributeForName:@"saleType"] stringValue];
        name=[node stringValue];
        
        dict=[NSDictionary dictionaryWithObjectsAndKeys:
              identify,@"identify"
              ,name,@"name"
              ,key,@"key"
              ,market,@"market"
              ,credit,@"credit"
              ,time,@"time"
              ,saleType,@"saleType"
              ,nil];
        NSLog(@"%@",[StringUtil nsDictionaryToString:dict]);
        [arrNotification addObject:dict];
        NSLog(@"arrNotification============ count:%d",[arrNotification count]);
    }
    
    [shareMap setValue:arrNotification forKey:SHARE_NOTIFICATIONS];
    [shareMap synchronize];
    
    NSLog(@"SHARE_NOTIFICATIONS All============ count:%d",[arrNotification count]);

}

@end
