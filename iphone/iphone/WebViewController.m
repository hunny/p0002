//
//  WebViewController.m
//  viewFirst
//
//  Created by 杨 国旗 on 13-8-11.
//  Copyright (c) 2013年 cpic.wondertek.cpic. All rights reserved.
//

#import "WebViewController.h"
#import "SystemCoreProfile.h"
#import "StringUtil.h"
#import "UrlParamUtil.h"
#import "NSData+Base64.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "NotificationDAO.h"
#import "ConnectedToNetwork.h"
#import "UIDevice+IdentifierAddition.h"

@interface WebViewController ()

@end

@implementation WebViewController

+ (void)initialize {
    // Set user agent (the only problem is that we can't modify the User-Agent later in the program)

    NSString *userAgentString=[StringUtil getUserAgent:@""];

    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgentString, @"UserAgent", nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //清除UIWebView的缓存
    //[self.webView rem];
    //self.webView.setBackgroundColor(Color.parseColor("#000000"));
    //self.webView.backgroundColor=Color.parseColor("#000000");
    
    self.webView.backgroundColor = [UIColor blackColor];
    self.view.backgroundColor=[UIColor blackColor];
    
    self.webView.delegate = self;   
    self.webView.scalesPageToFit = YES;
    self.webView.detectsPhoneNumbers  =  YES;
    self.webView.scrollView.bounces = NO;


//    NSString *string = [NSString stringWithFormat:@"%@", path];
//    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url =[NSURL URLWithString:ACCP_MAIN_PAGE];
//    NSURLRequest *request =[NSURLRequest requestWithURL:url];
//    
//    [self.webView loadRequest:request];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.webView.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.webView addSubview : activityIndicatorView] ;
    
    bool isConnect= [[NSString stringWithFormat:@"%i",[[ConnectedToNetwork new] connectedToNetwork]] isEqualToString:@"1"];
    self.webView.delegate=self;

    if (isConnect) {
        NSString *remoteUrlPath=[NSString stringWithFormat:@"%@%@",ACCP_MAIN_PAGE,PAGE_INDEX];
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:remoteUrlPath]];
        [self.webView loadRequest:request];
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath: path]]];
    }
    
    [_btnLogin addTarget:self  action:@selector(btnLoginEvent:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark UIWebView delegate method
/****************************************************************
 *WEBVIEW代理方法
 ****************************************************************/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@",request.URL];
    NSDictionary *params = [UrlParamUtil getParamsFromUrl:request.URL];
    // 同步用户信息
    NSUserDefaults *shareMap=[NSUserDefaults standardUserDefaults];
    
	NSLog(@"startRequest:*********  %@",requestURLString);
	NSString *requestQueryString = [[request URL] query];
    if ([requestURLString rangeOfString:@"http://callClient/loadRequestWebview"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/loadRequestWebview"].location != NSNotFound) {// 静态页面的导航设置
        NSUserDefaults *shareMap=[NSUserDefaults standardUserDefaults];
        NSString *fromPage = [params objectForKey:@"fromPage"];
        NSString *string = [[shareMap valueForKey:ACCP_MAIN_PAGE_INPUT] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if([fromPage isEqualToString:@"1"]){
            string=[string stringByAppendingFormat:@"/product/index.html"];
        }else if([fromPage isEqualToString:@"2"]){
            string=[string stringByAppendingFormat:@"/purchase/index.html"];
        }else if([fromPage isEqualToString:@"3"]){
            string=[string stringByAppendingFormat:@"/assistant/index.html"];
        }else if([fromPage isEqualToString:@"4"]){
            string=[string stringByAppendingFormat:@"/login/index.html"];
        }else{
            string=[string stringByAppendingString:fromPage];
        }
        
        NSURL *url =[NSURL URLWithString:string];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        
		[self.webView loadRequest:request];
        return NO;
	}else if ([requestURLString rangeOfString:@"http://callClient/showAlert"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/showAlert"].location != NSNotFound) {
		[self popDialog:requestQueryString];
        return NO;
    }else if ([requestURLString rangeOfString:@"http://callClient/makeCall"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/makeCall"].location != NSNotFound) {// 拨打电话
        NSString *phoneNum = [params objectForKey:@"id"]; //电话号码
    
        //NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneNum]];
        NSLog(@"phoneNum %@",phoneNum);
        UIWebView *callView=[[UIWebView alloc] init];
        NSString *num = [NSString stringWithFormat:@"tel:%@",phoneNum];//number为号码字符串
        NSURL *telUrl=[NSURL URLWithString:num];
        [callView loadRequest:[NSURLRequest requestWithURL:telUrl]];
        [self.view addSubview:callView];
        
        
        // 简单呼叫方式
        //NSString *num = [NSString stringWithFormat:@"telprompt://%@",phoneNum];//number为号码字符串
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
        
        return NO;
	}else if([requestURLString rangeOfString:@"http://callClient/showInputAlert"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/showInputAlert"].location != NSNotFound) {
		
        //UIAlertView *alert=[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入URL地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                            
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入URL地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            
        alert.alertViewStyle=UIAlertViewStylePlainTextInput;
 
		[alert setTag:101];
		[alert show];
        
        return NO;
	}else if ([requestURLString rangeOfString:@"http://callClient/rockRoll"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/rockRoll"].location != NSNotFound) {// 进入登录页面访问
        NSString *id = [params objectForKey:@"id"];
        [shareMap setValue:id forKey:USER_LOGIN_ID];
        [shareMap synchronize];
        
        NSLog(@"登录请求 userId: %@  deviceId: %@",[shareMap objectForKey:USER_LOGIN_ID],[shareMap objectForKey:DEVICE_ID]);
        
        return NO;
	}else if ([requestURLString rangeOfString:@"http://callClient/mloginValue"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/mloginValue"].location != NSNotFound) {// 初始化登录页面 同步给页面一个设备号
  
        NSString *deviceId=[StringUtil md5:[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
        deviceId=[deviceId uppercaseString];
        [shareMap synchronize];
       
        [shareMap setValue:deviceId forKey:DEVICE_ID];

        NSString *deviceEvent = [NSString stringWithFormat:@"$('body').trigger('mloginiphone', ['%@']);", deviceId];
        
        [self.webView stringByEvaluatingJavaScriptFromString:deviceEvent];
        
        return NO;
	}else if ([requestURLString rangeOfString:@"http://callClient/selectImageFromPhotoLibrary"].location != NSNotFound||[requestURLString rangeOfString:@"http://callclient/selectImageFromPhotoLibrary"].location != NSNotFound){//web页面通知选择照片
  
        imageName = nil;
       
        NSString *fromType = [params objectForKey:@"fromType"];
        selector=              [params objectForKey:@"selector"];
        NSString *callBack = [params objectForKey:@"callback"];
        selector=[params objectForKey:@"selector"];
        //[[params objectForKey:@"selector"] copy];
        imageName = [[params objectForKey:@"fileName"] copy];
        
        selectImageFromType = [fromType intValue];
        selectImageCallBack = callBack == nil ? 0 : [callBack intValue];
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker.view setAutoresizesSubviews:NO];
        picker.sourceType = selectImageFromType % 2 == 1 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
        NSString *message = picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary ? @"你的设备不能访问图片库。" : @"你的设备不支持拍照功能，请从图片库中选取照片上传。";
        
        if (![UIImagePickerController isSourceTypeAvailable: picker.sourceType]) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return NO;
        }
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        [picker setHidesBottomBarWhenPushed:NO];
        
        // [self.navigationController setViewControllers:picker.viewControllers animated:YES];
        if (IS_IOS6 > 5.1f) {
            [self presentViewController:picker animated:YES completion:Nil ];
        }else
            [self presentModalViewController:picker animated:YES];
        
        return NO;
    }
    return YES;
}

/*
ASIHTTPRequest *loginRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:request_url]];
[loginRequest setDidFailSelector:@selector(loginRequestDidFailedSelector:)];
[loginRequest setDidStartSelector:@selector(loginRequestDidStartSelector:)];
[loginRequest setDidFinishSelector:@selector(loginRequestDidFinishSelector:)];
[loginRequest setDelegate:self];
[loginRequest startAsynchronous];

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
    NSLog(@"loginRequestDidFinishSelector=============");
    NSUserDefaults *shareNotifications = [NSUserDefaults standardUserDefaults];
    NSDictionary *params = [UrlParamUtil getParamsFromUrl:loginRequest.url];
    NSString *id = [params objectForKey:@"id"];
    [shareNotifications synchronize];
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *selectedPhotoImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	//UIImage转NSData
    //	imageData = UIImagePNGRepresentation(photoImage);
	NSData *imageData = UIImageJPEGRepresentation(selectedPhotoImage, 0.1);
    selectImageCallBack=1;
    if (selectImageCallBack == 1) {
        
        NSString *filePath = [self storageImage:imageName imageData:imageData];
        NSLog(@"filePath,%@==",filePath);
        
//        $("'" + selector + "'").data('base64', "base64");
//        $("" + selector + "").data('iamgeType', "iamgeType");
//        $("" + selector + "").trigger('imagecomplete');
        
        NSMutableString *jsString=[NSMutableString new];
        
        [jsString appendFormat:@"$('%@').data('base64','data:image/jpg;base64,%@');",selector,[imageData base64EncodedString]];
        //[jsString appendFormat:@"$('%@').data('base64','%@');",selector,@"yangguoqi"];
        [jsString appendFormat:@"$('%@').data('imageType','%@');",selector,@"jpg"];
        [jsString appendFormat:@"$('%@').trigger('imagecomplete');",selector];
        
        
        //NSString jsString=[NSString stringWithFormat:@"$('%@').data('base64',%@);"];
        //NSLog(@"photo Update ===%@",(NSString *)jsString)
        
        [self.webView stringByEvaluatingJavaScriptFromString:(NSString *)jsString];
        
    }
    
    if (IS_IOS6 >5.1f) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }else
        [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)storageImage:(NSString *)fileName imageData:(NSData *)imageData
{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", fileName]];
    
    [imageData writeToFile: filePath atomically:YES];
    return filePath;
}

// Provide 2.x compliance
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:@"UIImagePickerControllerOriginalImage"];
	[self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

// Optional but "expected" dismiss
- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self.view setFrame:CGRectMake(0, 44, 320, 300)];
    if (IS_IOS6 >5.1f) {
        [self dismissViewControllerAnimated:YES completion:Nil];
    }else
        [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark alertView handler method
/****************************************************************
 *弹出框处理
 ****************************************************************/
-(BOOL)popDialog:(NSString*)queryParam
{
	/*
	 * 弹出框
	 * 参数说明：
	 *	popType ：弹出框类型      popType ＝  “1” 为一个按钮的弹出框（确定按钮）， popType ＝  “0” 为二个按钮的弹出框（确定和取消按钮）
	 *	title         ：弹出框标题
	 *	message：弹出框信息
	 *	jsCode   ：弹出框弹出后回调函数
	 **/
	NSString *popType = @"";
	NSString *popDialogTitle = @"";
	NSString *popDialogMsg = @"";
	NSArray *requestURLQueryParamArray = [queryParam componentsSeparatedByString:@"&"];//就是以&为标示
	for (NSString *str in requestURLQueryParamArray) {
		if ([str hasPrefix:@"title"]) {
			popDialogTitle = [[NSString stringWithFormat:@"%@",[[str componentsSeparatedByString:@"title="] objectAtIndex:1]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		} else if([str hasPrefix:@"message"]){
			popDialogMsg = [[NSString stringWithFormat:@"%@",[[str componentsSeparatedByString:@"message="] objectAtIndex:1]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		} else if([str hasPrefix:@"jsCode"]){
			JSCallBackFunction = [[[NSString stringWithFormat:@"%@",[[str componentsSeparatedByString:@"jsCode="] objectAtIndex:1]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] copy];
		}else {
			popType = [[NSString stringWithFormat:@"%@",[[str componentsSeparatedByString:@"popType="] objectAtIndex:1]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		}
        
	}
	if ([popType isEqual:@"0"]) {
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:popDialogTitle message:popDialogMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert setTag:100];
		[alert show];
		return YES;
	}
    
	UIAlertView *alert=[[UIAlertView alloc] initWithTitle:popDialogTitle message:popDialogMsg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
	[alert show];
	
	return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView numberOfButtons]==1) {
        if (alertView.tag == 101) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            NSUserDefaults *shareMap=[NSUserDefaults standardUserDefaults];
            if([textField.text isEqualToString:@""])
                return;
            
            [shareMap setValue:[NSString stringWithFormat:@"http://%@/xone-app",textField.text] forKey:ACCP_MAIN_PAGE_INPUT];

            //textField.keyboardType = UIKeyboardTypeDefault;
        }else{
            [self runJS:JSCallBackFunction];
        }
    }
   
    if ([alertView numberOfButtons]==2) {
        // confirm 事件确定按钮
        if (alertView.tag == 100 && buttonIndex == 1) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"$('body').trigger('iphoneconfirm', [1]);"];
        }
         // confirm 事件取消按钮
        if (alertView.tag == 100 && buttonIndex == 0) {
            [self.webView stringByEvaluatingJavaScriptFromString:@"$('body').trigger('iphoneconfirm', [0]);"];
        }
        // 图片上传事件
        if (buttonIndex == 1) {
            [self runJS:JSCallBackFunction];
        } else {
            [self runJS:@"clickConfirmCancelButton()"];
        }
    }
}
//mainPageWebView调用js
- (NSString*)runJS:(NSString*) jsCode
{
    NSString* runJSResult = @"";
	@try {
		runJSResult = [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
		//WDLog(@"runJS:%@",jsCode);
		if (self.webView.hidden) {
		 
            self.webView.hidden=NO;
		}
        
	} @catch (NSException * e) {
		////WDLog(@"%@",[e reason]);
	}
    return runJSResult;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = [self.webView.scrollView contentSize].height;
//    newFrame.size.width = [self.webView.scrollView contentSize].width;
//    self.webView.frame = newFrame;
//    UIScrollView  *scroller = [self.webView.subviews objectAtIndex:0];
//    if (scroller)
//    {
//        scroller.bounces = NO;
//        scroller.alwaysBounceVertical = NO;
//    }
//    for (id subview in self.webView.subviews) {
//        if ([[subview class] isSubclassOfClass:[UIScrollView class]]) {
//            ((UIScrollView *)subview).bounces=NO;
//        }
//    }

    [activityIndicatorView stopAnimating];
    self.webView.scrollView.bounces = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    [alterview show];
    NSLog(@"didFailLoadWithError error %@",[error localizedDescription]);
}

#pragma mark 内存警告时触发
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
    //取消目前是第一回应者（键盘消失）
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
    
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"登录" message:@"登录成功！"  delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
    [alterview show];
    
    //    //打开本地通知
    //    UILocalNotification *notification=[[UILocalNotification alloc] init];
    //    NSDate *now1=[NSDate date];//相当于new Date
    //    notification.timeZone=[NSTimeZone defaultTimeZone];
    //    notification.repeatInterval=NSDayCalendarUnit;
    //    notification.applicationIconBadgeNumber = 1;
    //    notification.alertAction = NSLocalizedString(@"显示", nil);
    //    notification.fireDate=[now1 dateByAddingTimeInterval:500];
    //    notification.alertBody=@"通知测试";
    //    [notification setSoundName:UILocalNotificationDefaultSoundName];
    //    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
    //                          [NSString stringWithFormat:@"%d",1], @"key1", nil];
    //    [notification setUserInfo:dict];
    //    [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    
}


- (void)viewDidUnload {
    NSLog(@"viewDidUnload============");
    [self setBtnLogin:nil];
    [self setBtnRigerst:nil];
    [super viewDidUnload];
}
@end

