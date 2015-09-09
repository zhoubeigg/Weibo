//
//  OAuthViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/8/5.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "OAuthViewController.h"
#import "ZBWHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "AccountTool.h"

@interface OAuthViewController () <UIWebViewDelegate>

@end

@implementation OAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建一个webview
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    [self.view addSubview:webView];
    webView.delegate = self;
    // 2.用webView加载登陆页面
    // 请求地址：https://api.weibo.com/oauth2/authorize
    /* 请求参数：
     第一个：
     App Key：258491033
     App Secret：7ce2267e38fa8f9aefc51a275e641fe1
     第二个：
     App Key：1780976026
     App Secret：d3dc5bc67c90dd2fdcdce89b5e1d01b7
    */

    NSString *urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",ZBWAppKey, ZBWRedirectURI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //ZBLog(@"webViewDidStartLoad---");
    [MBProgressHUD showMessage:@"正在加载..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //ZBLog(@"shouldStartLoadWithRequest--%@ code=9dae2eca23005782fd72ca4b3027ecc1", request.URL.absoluteString);
    // 1.获得URL
    NSString *url = request.URL.absoluteString;
    
    // 2.判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0) { //是回调地址
        // 截取code=后面的参数
        NSUInteger fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        // 利用code换取一个accessToken
        [self accessTokenWithCode:code];
        
        //禁止加载回调地址
        return NO;
    }

    return YES;
}

// 利用code（授权成功后的request token）换取一个accessToken
- (void)accessTokenWithCode:(NSString *)code
{
    
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = ZBWAppKey;
    params[@"client_secret"] = ZBWAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"redirect_uri"] = ZBWRedirectURI;
    params[@"code"] = code;
    
    // 2.发送请求
    [ZBWHttpTool post:@"https://api.weibo.com/oauth2/access_token" params:params success:^(id json) {
        [MBProgressHUD hideHUD];
        //ZBLog(@"请求成功-%@", responseObject);
        
        // 将返回的数据装成模型，存进沙盒中
        Account *account = [Account accountWithDict:json];
        [AccountTool saveAccount:account];
        
        // 切换窗口的根控制器
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        ZBLog(@"请求失败-%@",error);
    }];
     //"access_token" = "2.00xNDITB0N1bURdda5c5be060YXNBd";
}


@end
