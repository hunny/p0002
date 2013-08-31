//
//  ViewController.h
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-8.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewUtil.h"

@interface ViewController : UIViewController<UIWebViewDelegate,UIAlertViewDelegate>
{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
}
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRigerst;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

- (void)btnLoginEvent:(id)sender;

- (void)btnRigerstEvent:(id)sender;

- (void)clickBackground;

@end
