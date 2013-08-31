//
//  ViewController.m
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-8.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "ViewController.h"
#import "SystemCoreProfile.h"
#import "AlertViewUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_btnLogin addTarget:self  action:@selector(btnLoginEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //[_txtUserName resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void)clickBackground
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


- (IBAction)doEditFieldDone:(id)sender {
    // 取消目前是第一回应者（键盘消失）
    [sender resignFirstResponder];
}

// 点击背景
- (IBAction)onBackgroungHit:(id)sender {
    //取消目前是第一回应者（键盘消失）
    //[_txtUserName resignFirstResponder];
    NSLog(@"backGroundHit=====");
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)UtilTimer:(id) sender
{
    NSTimer *myTimer = [NSTimer  timerWithTimeInterval:3.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];

    [[NSRunLoop  currentRunLoop] addTimer:myTimer forMode:NSDefaultRunLoopMode];
    
    
}


- (void)btnRigerstEvent:(id)sender
{
    
}

- (void)btnLoginEvent:(id)sender
{
    NSString *userName= self.txtUserName.text;
    NSString *password= self.txtPassword.text;
    
    NSLog(@"hell butn1111 userName:%@ password:%@",userName,password);
    
    
    //AlertViewUtil *alert=[[AlertViewUtil alloc] init];
    
    //[[alert utildelegate] myalertviewbuttonclik:2];
    
    //[alert alertviewutilone:@"提示" addmessage:@"保存成功！"];

    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功！"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    [alterview setTag:0];
    
    [alterview show];
    
//    UIAlertView *alterview2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录成功2！"  delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定是否成功", nil];
//    
//    [alterview2 setTag:1];
//    
//    [alterview2 show];
    
}

#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"clickButtonAtIndex:%d",buttonIndex);
//    if(alertView.tag==0 && buttonIndex==0){
//        NSLog(@"点击的是第一个alert的OK按钮");
//    }
//    
//    if(alertView.tag==1 && buttonIndex==0){
//        NSLog(@"点击的是第2个alert的OK按钮");
//    }
}

//AlertView已经消失时执行的事件
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"didDismissWithButtonIndex");
}

//ALertView即将消失时的事件
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
}

//AlertView的取消按钮的事件
-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

//AlertView已经显示时的事件
-(void)didPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"didPresentAlertView");
}

//AlertView即将显示时
-(void)willPresentAlertView:(UIAlertView *)alertView
{
    NSLog(@"willPresentAlertView");
}


- (void)viewDidUnload {
    [self setBtnLogin:nil];
    [self setBtnRigerst:nil];
    [super viewDidUnload];
}
@end
