//
//  newsDetailViewController.m
//  OCRRecognition1
//
//  Created by fred on 2018/10/30.
//  Copyright © 2018年 fred. All rights reserved.
//

#import "newsDetailViewController.h"

@interface newsDetailViewController ()

@end

@implementation newsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"健康工作五十年";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    NSURL *url;
    if (_urlStr.length > 0) {
        url = [NSURL URLWithString:_urlStr];
    } else {
        url = [NSURL URLWithString:@"http://env.people.com.cn/n1/2018/1024/c1010-30360787.html"];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
