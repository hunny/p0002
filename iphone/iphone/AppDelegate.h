//
//  AppDelegate.h
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-8.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
     NSMutableDictionary *cacheFileURLDictionary;
     UIBackgroundTaskIdentifier _bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) NSMutableDictionary *cacheFileURLDictionary;
@property (nonatomic, retain) NSTimer *nstimer60s;

#pragma mark -
#pragma mark common method
+(AppDelegate *)appDelegate;

+(void)addCommonAnimation:(UIView*)view;

- (void)cancelLocalNotification;
- (void)createLocalNotificationInfo;

@end
