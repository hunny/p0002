//
//  AlertViewUtil.m
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-11.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "AlertViewUtil.h"

@implementation AlertViewUtil

@synthesize utildelegate;

//实现系统对话筐协议中的button点击方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //点击的是第一个alertview
    if (alertView == myonealertview) {
        if (buttonIndex == 0) {
            [self.utildelegate myalertviewbuttonclik:11];
        }
    }
    //点击的是第二个alertview
    else if (alertView == mytwoalertview) {
        if (buttonIndex == 0) {
            [self.utildelegate myalertviewbuttonclik:21];
        }
        else if(buttonIndex == 1){
            [self.utildelegate myalertviewbuttonclik:22];
        }
    }
    //点击的是第三个alertview
    else if (alertView == mythreealertview) {
        if (buttonIndex == 0) {
            [self.utildelegate myalertviewbuttonclik:31];
        }
        else if(buttonIndex == 1){
            [self.utildelegate myalertviewbuttonclik:32];
        }
        else if(buttonIndex == 2){
            [self.utildelegate myalertviewbuttonclik:33];
        }
    }
}
//只有一个按钮 的alertview
-(void)alertviewutilone:(NSString *)buttontitleone addmessage:(NSString *)message
{
    myonealertview = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:buttontitleone, nil];
    [myonealertview show];
}

//两个按钮 的alertview
-(void)alertviewutiltwo:(NSString *)buttontitleone twobutton:(NSString *)buttontitletwo addmessage:(NSString *)message{
    mytwoalertview = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:buttontitleone,buttontitletwo, nil];
    [mytwoalertview show];
}

//三个按钮 的alertview
-(void)alertviewutilthree:(NSString *)buttontitleone twobutton:(NSString *)buttontitletwo threebutton:(NSString *)buttontitlethree addmessage:(NSString *)message{
    mythreealertview = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:buttontitleone,buttontitletwo,buttontitlethree, nil]; 
    [mythreealertview show]; 
}
@end
