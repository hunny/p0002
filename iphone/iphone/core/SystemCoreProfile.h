//
//  SystemCoreProfile.h
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-11.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#ifndef viewFirst_SystemCoreProfile_h
#define viewFirst_SystemCoreProfile_h

//新项目测试
//#define ACCP_MAIN_PAGE @"http://rs.fengzhangyu.com:8080/xone-app/"

#define ACCP_MAIN_PAGE @"http://192.168.1.72:8080/xone-app/"

//#define ACCP_MAIN_PAGE @"http://116.228.131.213/cpicmobile_ft/pages/iphone/v3/carNewChange.html"

//太保项目测试
//#define ACCP_MAIN_PAGE @"http://116.228.131.213/cpicmobile_ft/pages/iphone/v3/home/indexWithTopBar.html"
//
//#define ACCP_MAIN_PAGE @"http://116.228.131.213/cpicmobile_ft/mobilePolicy/portal.html"

//#define ACCP_MAIN_PAGE @"http://www.csdn.net"

#define ACCP_MAIN_PAGE_INPUT @""

#define USER_LOGIN_ID @"user_login_id"

#define DEVICE_ID @"device_id"


#define SHARE_NOTIFICATIONS @"shareNotifications"

// 设置最后一次定时时间
#define TIME_INTERVAL_NAME @"timeIntervalName"

// 设置最后一次通知的毫秒数
#define TIME_INTERVAL_VALUE @"timeIntervalValue"

// 24小时日期格式
#define DATEFORMAT24 @"yyyy-MM-dd HH:ss:mm"

// 24小时日期格式
#define DATEFORMAT12 @"yyyy-MM-dd hh:ss:mm"

// 设置每天早晨9点推送消息
#define TIME_INTERVAL_HOUR 9

#define TIME_INTERVAL 10      //设置定时器的执行间隔为1天

#define TIME_INTERVAL_HALF 5*60       //模拟数据使用 设置半小时增加2条记录

#define NOTIFICATION_PAGE @"/product/listProduct.html"

#ifndef CACHEFILE_MEMORY_CAPACITY
#define CACHEFILE_MEMORY_CAPACITY 5*1024*1024       //缓存文件的容量
#endif

#ifndef UPLOAD_PHOTO_MAXSIZE
#define UPLOAD_PHOTO_MAXSIZE 6*1024*1024            //证照上传允许的最大值
#endif

#ifndef DISTRIBUTION_VERSION
#define DISTRIBUTION_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]          //客户端版本号
#endif

#ifndef PARAM_CLIENT_VERSION
#define PARAM_CLIENT_VERSION @"version"		//客户端版本
#endif

/************ 系统功能 ************/
//平台判断
#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CPIC_IPAD
#else
#define IS_IPAD NO
#endif

#ifndef IS_IOS6
#define IS_IOS6  [[UIDevice currentDevice].systemVersion doubleValue]
#endif

#endif
