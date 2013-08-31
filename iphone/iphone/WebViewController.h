//
//  WebViewController.h
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-11.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebViewController : UIViewController<UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActivityIndicatorView *activityIndicatorView;
    NSString *JSCallBackFunction;
    
    // 图片上传
    int selectImageFromType;
    int selectImageCallBack;
    NSString *selector;
    NSString *imageName;
    NSArray *uploadFiles;
    NSArray *uploadKeys;
    NSDictionary *uploadParams;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRigerst;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet NSMutableDictionary *cacheFileURLDictionary;


- (void)btnLoginEvent:(id)sender;

- (void)btnRigerstEvent:(id)sender;

- (void)clickBackground;

@end