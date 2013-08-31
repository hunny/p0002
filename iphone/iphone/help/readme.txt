


-(NSString *)getCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    self.startTime = dateTime;
    return startTime;
}


http://rs.fengzhangyu.com:8080/xone-app/product/listProduct.html?_pu=1&_pm=FDFEFSDFDSFsd&_pd=12212&_=232323231

https://appleid.apple.com/cgi-bin/WebObjects/MyAppleId.woa/wa/directToSignIn?localang=zh_CN

http://rs.fengzhangyu.com:8080/xone-app/assistant/subscribe.html?id=1&_m=1E8283A655F8E349D49EF2B287621AF1

webcpic@gmail.com Cpic1234


alexhuang0906@hotmail.com  Alexhuang0906@.apple.com1

Alexhuang0906@hotmail.com hxx!@#$%^



/**
	 * 订阅成功的列表地址
	 */
public final static String SUBSCRIBE_RESULT_ADDR_KEY = "/productstProduct.html";


com.wonddertek.cpic
iOS开发UIWebView展示网页实例代码

时间：2013-04-25 10:14 来源：达内移动互联网学院 作者：YY



在IOS学习中UIWebView是ios内置的浏览器控件，我们可以用它来浏览网页、打开文档等等。接下来达内ios培训老师将会介绍它是如何实现展示网页实例代码，大家通过学习这篇文章可以对

   在IOS学习中UIWebView是ios内置的浏览器控件，我们可以用它来浏览网页、打开文档等等。接下来达内ios培训老师将会介绍它是如何实现展示网页实例代码，大家通过学习这篇文章可以对UIWebView有更多的了解。

代码如下
viewController.h
@interface ViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicatorView;
}
@end
viewController.m

- (void)viewDidLoad
{
    [super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray] ;
    [self.view addSubview : activityIndicatorView] ;
   
    NSURL *url =[NSURL URLWithString:@"http://www.hopean.com"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
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
    [alterview release];
}
   只有自己才能决定自己是否成功,下定了成功的决心，仅仅是使成功有了必要性，要使成功具有必然性就需要具有坚持不懈的信心和毅力，惟有奋斗才能成功。决心和努力，达内会带给你一个不一样的你，感受达内，成功就在远方。 