//
//  AlertViewUtil.h
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-11.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol myAlertviewutilDelegate <NSObject>

-(void)myalertviewbuttonclik:(int)num;

@end

@interface AlertViewUtil : NSObject<UIAlertViewDelegate> {
    //自定义的对话筐协议
    id<myAlertviewutilDelegate> utildelegate;
    
    UIAlertView *myonealertview;//一个按钮的对话筐
   
    UIAlertView *mytwoalertview;//两个按钮的对话筐
  
    UIAlertView *mythreealertview;//三个按钮的对话筐
    
}

@property(nonatomic,retain) id<myAlertviewutilDelegate> utildelegate;

-(void)alertviewutilone:(NSString *)buttontitleone addmessage:(NSString *)message;
-(void)alertviewutiltwo:(NSString *)buttontitleone twobutton:(NSString *)buttontitletwo addmessage:(NSString *)message;
-(void)alertviewutilthree:(NSString *)buttontitleone twobutton:(NSString *)buttontitletwo threebutton:(NSString *)buttontitlethree addmessage:(NSString *)message;
@end