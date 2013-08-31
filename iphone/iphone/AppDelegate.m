//
//  AppDelegate.m
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-8.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "WebViewController.h"
#import "SystemCoreProfile.h"
#import "StringUtil.h"
#import "ConnectedToNetwork.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import <AVFoundation/AVAudioSession.h>
#import "NotificationDAO.h"



@implementation AppDelegate

@synthesize cacheFileURLDictionary=_cacheFileURLDictionary;

- (void)getDeviceAndOtherInfo
{
    //获取设备的udid
    NSString *uuid = [[UIDevice currentDevice] uniqueIdentifier];
    NSLog(@"uuid=====%@",uuid);
    NSLog(@"timeIntervalSince1970 ==%d",(int)[[NSDate date] timeIntervalSince1970]);
    
}

- (void)testXml
{ 
    //获取工程目录的xml文件
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"notification" ofType:@"xml"];
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    //使用NSData对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData  options:0 error:nil];
    
    //获取根节点（Users）
    GDataXMLElement *rootElement = [doc rootElement];
    
    //<item identify="001" market="" key="user001" saleType="type001" credit="杨国旗">龙虾</item>
    
    //获取根节点下的节点（User）
    NSArray *infos = [rootElement elementsForName:@"info"];
    GDataXMLElement *myInfo = [infos objectAtIndex:0];
    // 获取name节点的值
    NSString *infoname = [myInfo stringValue];
    NSLog(@"myInfo nodeNameValue is:%@",infoname);
    
    //获取根节点下的节点（User）
    NSArray *items = [rootElement elementsForName:@"items"];
    GDataXMLElement *item = [items objectAtIndex:0];
    NSArray *itemNodes = [item elementsForName:@"item"];
    for (GDataXMLElement *node in itemNodes) {
        NSString *identify = [[node attributeForName:@"identify"] stringValue];
        NSLog(@"item identify is:%@",identify);
    
        NSString *key = [[node attributeForName:@"key"] stringValue];
        NSLog(@"item key is:%@",key);
    
        // 获取name节点的值
        NSString *name = [node stringValue];
        NSLog(@"item name is:%@",name);
    } 
}



- (void)test
{
    NSDateFormatter *dateFormatter=[NSDateFormatter new];
    // 24小时时间
    [dateFormatter setDateFormat:DATEFORMAT24];
    
    NSDate *date1=[StringUtil dateString2Date:@"2012-03-04 12:23:03" dateFormat:dateFormatter];
    NSDate *date2=[StringUtil dateString2Date:@"2013-03-04 12:23:03" dateFormat:dateFormatter];
    
    [date2 dateByAddingTimeInterval:20];
    if([date1 compare:date2] == NSOrderedAscending){
        
    }
    if([date1 compare:date2] == NSOrderedAscending){
        
    }
    
    NSString *urlPath=@"http://192.168.1.3:8080/xone-app/assistant/subscribe.html?id=2&_m=B99FD091ACED234EB4FA35CDA17FD448";
    
    NSURL *url = [NSURL URLWithString:urlPath];
    
     __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    //使用OC中新增的bolck语法（块语法），可以实现并行编程
    //以下方法是在请求完成后会被调用的块
    [request setCompletionBlock:^{
        //获取请求返回结果
        NSString *response = [request responseString];
         NSLog(@"response ==== %@",response);
        //GDataXMLNode *xmlParse=[GDataXMLNode textWithStringValue:response];
        
        GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:response options:0 error:nil];
        GDataXMLElement *root = [xmlDoc rootElement];
        NSArray *array = [root children];
        NSLog(@"count : %d", [array count]);
 
        //获取根节点下的节点（User）
        NSArray *info = [root elementsForName:@"info"];
        for(GDataXMLElement *user in info) {
            //User节点的id属性
//            NSString *userId = [[user attributeForName:@"id"] stringValue];
//            NSLog(@"User id is:%@",userId);
            
            //获取name节点的值
            GDataXMLElement *nameElement = [[user elementsForName:@"titile"] objectAtIndex:0];
            NSString *titile = [nameElement stringValue];
            NSLog(@"info->title is:%@",titile);
        }
        
        //如果是数据集，可以使用以下方式返回结果
        //        NSData *responseData = [request responseData];
        
    }];
    
    //如果请求失败，可以在这里进行处理
    [request setFailedBlock:^{
        //        NSError *error = [request error];
        
    }];
    
    //开启一个异步请求（这里只说明了异步请求的使用，因为一般情况下的网络请求都采用异步的方式，否则会阻塞UI）
    [request startAsynchronous];
  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"AppDelegate start.....");
    NSUserDefaults *shareUserMap = [NSUserDefaults standardUserDefaults];
    [shareUserMap setObject:ACCP_MAIN_PAGE forKey:ACCP_MAIN_PAGE_INPUT];
    [shareUserMap synchronize];

    application.applicationIconBadgeNumber = 0;
    // 开启iphone网络开关 打开或者关闭可以指示页面是否正在加载
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
 
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationErr];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 本地通知接收
    if (launchOptions != nil) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (userInfo != nil) {
            NSLog(@"local notification==================:%@",userInfo);
        }
    }
    
    //self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];

    self.viewController = [[WebViewController alloc] initWithNibName:@"LoadRemoteHtml" bundle:nil];
    
    [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{
        //执行你想要执行的任务，同时可以配合第一种任务，以增加某些同步方法的执行时间，比如说下载数据等
        NSLog(@"循环执行事件===========");
        [self notificationTimer];
    }];
  
    self.window.rootViewController = self.viewController;
   
    [self.window makeKeyAndVisible];
    
    
    // 测试时 没小时执行一次 项目实际每天执行一次
    //[NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(createLocalNotificationInfo) userInfo:nil repeats:YES];
    
    // 模拟数据库数据 没小时增加2条记录
    //self.nstimer60s=[NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL_HALF target:self selector:@selector(notificationTimer) userInfo:nil repeats:YES];
    
    return YES;
}

#pragma mark 通知定时器
- (void)notificationTimer
{
     NSUserDefaults *shareUserMap = [NSUserDefaults standardUserDefaults];
     int lastTimeInterval=[shareUserMap integerForKey:TIME_INTERVAL_VALUE];
    
    int currentTimeInterval= (int)[[NSDate date] timeIntervalSince1970];
    bool isTrue=((currentTimeInterval-lastTimeInterval-(TIME_INTERVAL)) >= 0);
    
    NSLog(@"lastTimeInterval: %d,currentTimeInterval:%d 差：%d",(lastTimeInterval+(TIME_INTERVAL)),currentTimeInterval,(currentTimeInterval-lastTimeInterval-(TIME_INTERVAL)));
    
    bool isConnect= [[NSString stringWithFormat:@"%i",[[ConnectedToNetwork new] connectedToNetwork]] isEqualToString:@"1"];
    NSLog(@"isTrue: %d,isConnect:%d",isTrue,isConnect);
    
    // 判断网络是否联通
    if(isConnect && isTrue)
    {
        NSLog(@"网络连接良好");
        
        // 获取通知数据
        NotificationDAO *notificationDao=[NotificationDAO new];
        [notificationDao getLocalNotificationInfo];
        
        NSInteger count=[[shareUserMap objectForKey:SHARE_NOTIFICATIONS] count];
        if(count==0)
            return;
        
        // 创建本地通知
        [self createLocalNotificationInfo];
        
        // 存放本次通知时间
        NSDateFormatter *dateFormatter=[NSDateFormatter new];
        // 24小时时间
        [dateFormatter setDateFormat:DATEFORMAT24];
        // 获取当前时间
        NSString *currentDateStr=[StringUtil date2DateString:[NSDate date] dateFormat:dateFormatter];
        [shareUserMap setObject:currentDateStr forKey:TIME_INTERVAL_NAME];
        // 设置自1970年来的毫秒数
        [shareUserMap setInteger:(int)[[NSDate date] timeIntervalSince1970] forKey:TIME_INTERVAL_VALUE];

        [shareUserMap synchronize];

        // 设置每天执行一次的长定时器 
        [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(notificationTimer) userInfo:nil repeats:NO];
 
    }
}

# pragma mark -
# pragma mark 半小时填充2条模拟数据到通知信息中
- (void)fullLocalNotificationRecords
{
    NSUserDefaults *shareNotifications = [NSUserDefaults standardUserDefaults];
    //从内存中取出记录
    [shareNotifications removeObjectForKey:SHARE_NOTIFICATIONS];
    // 初始化可变数组 相当于java众ArrayList对象
    //NSMutableArray *arr=[NSMutableArray new];
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
    
   NSMutableArray *shareArr= [NSMutableArray arrayWithObjects:dictionary,dictionary2, nil];
    
    //添加新记录到老记录中
    [shareNotifications setObject:shareArr forKey:SHARE_NOTIFICATIONS];
    NSLog(@"full records==== count=%zi",[shareArr count]);
    [shareNotifications synchronize];
}


- (void)createLocalNotificationInfo
{
    NSLog(@"开始调用createLocalNotificationInfo函数");
    // 创建一个本地推送
    UILocalNotification *notification = nil;

    // 延迟10秒执行推送
    NSDate *pushDate = [NSDate dateWithTimeIntervalSinceNow:10]; 

    NSUserDefaults *shareUserMap = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArr=[shareUserMap valueForKey:SHARE_NOTIFICATIONS];
    
    NSLog(@"notification count===%d",[mutableArr count]);
    
    for(NSDictionary *objUserInfo in mutableArr)
    {
        notification = [UILocalNotification new];
        [self setOneRecordNotifiction:notification pushDate:pushDate userInfo:objUserInfo];
    }
}

# pragma mark 创建本地通知 设置一条记录
- (void)setOneRecordNotifiction:(UILocalNotification *)notification pushDate:(NSDate *)pushDate userInfo:(NSDictionary *)userInfo
{
    if (notification != nil) {
        // 设置推送时间
        notification.fireDate = pushDate;
        // 设置时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置重复间隔 kCFCalendarUnitDay 每天执行一次 0代表不重复
        notification.repeatInterval = 0;
        // 推送声音
        notification.soundName = UILocalNotificationDefaultSoundName;

        NSString *body=[NSString stringWithFormat:@"%@有新的订阅消息\n类型:%@,信誉:%@",[userInfo valueForKey:@"key"],[userInfo valueForKey:@"saleType"],[userInfo valueForKey:@"credit"]];
        // 推送内容
        notification.alertBody = body;
        
        //[NSString stringWithFormat:@"推送内容  %i", (arc4random() % 100)];
        
        notification.alertAction = NSLocalizedString(@"显示的推送信息", nil);
        notification.hasAction=YES;
        
        //显示在icon上的红色圈中的数子
        //notification.applicationIconBadgeNumber += 1;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        //NSDictionary *info = [NSDictionary dictionaryWithObject:@"1002" forKey:@"usernotification"];
        notification.userInfo = userInfo;
        //添加推送到UIApplication
        UIApplication *app = [UIApplication sharedApplication];
        app.applicationIconBadgeNumber += 1;
        [app scheduleLocalNotification:notification];
        
    }
}

- (void)cancelLocalNotification
{
    // 获得 UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    //获取本地推送数组
    NSArray *localArray = [app scheduledLocalNotifications];
    //声明本地通知对象
    UILocalNotification *localNotification;
    if (localArray) {
        for (UILocalNotification *noti in localArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                app.applicationIconBadgeNumber -= 1;
                [app cancelLocalNotification:noti];
                NSLog(@"id=%@",[dict valueForKey:@"id"]);
//                NSString *inKey = [dict objectForKey:@"notificationType"];
//                if ([inKey isEqualToString:@"usernotifi"]) {
//                    if (localNotification){
//                        localNotification = nil;
//                    }
//                    localNotification = noti;
//                    break;
//                }
            }
        }
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)localNotification{
     NSLog(@"usernotification  didReceiveLocalNotification start");
    
    // 判断应用程序是在后台才执行推送到
    if(localNotification != nil && application.applicationState == UIApplicationStateActive){
        
        NSDictionary  *dict = localNotification.userInfo;
        if (dict) {
            NSLog(@"dict identify 主键：%@",[dict objectForKey:@"identify"]);
           
            NSString *inValue = [dict objectForKey:@"identify"];
            if(inValue != nil){
                // 取消该通知
                [application cancelLocalNotification:localNotification];
                
                NSLog(@"didReceiveLocalNotification method");
                
                //从本地存储对象中移除当前通知信息
                NSUserDefaults *shareMap=[NSUserDefaults standardUserDefaults];
                NSMutableArray *mutableArr=[[shareMap valueForKey:SHARE_NOTIFICATIONS] mutableCopy];
                [mutableArr removeObject:dict];
                [shareMap setObject:mutableArr forKey:SHARE_NOTIFICATIONS];
                [shareMap synchronize];
            
                application.applicationIconBadgeNumber -= 1;
                
                localNotification = nil;
                
                WebViewController *webViewController = self.viewController;
                NSString *params=[NSString stringWithFormat:@"?_pu=%@&_pm=%@&_pd=%@&_=%d",[shareMap valueForKey:USER_LOGIN_ID],[shareMap valueForKey:DEVICE_ID],[dict valueForKey:@"identify"],(int)[[NSDate date] timeIntervalSince1970]];
                
                NSString *reqeustUrl=[NSString stringWithFormat:@"%@%@%@",[shareMap objectForKey:ACCP_MAIN_PAGE_INPUT],NOTIFICATION_PAGE,params];
                
                NSLog(@"requestUrl:%@",reqeustUrl);
                
                //NSURL *url =[NSURL URLWithString:@"http://www.baidu.com"];
                NSURL *url =[NSURL URLWithString:reqeustUrl];
                
                NSURLRequest *request =[NSURLRequest requestWithURL:url];
                [webViewController.webView loadRequest:request];
            }
            
        }

    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary*)dict
{
    NSLog(@"remote   didReceiveRemoteNotification======= sta");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication*   app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
