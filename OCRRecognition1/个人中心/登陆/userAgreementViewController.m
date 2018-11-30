//
//  userAgreementViewController.m
//  明星医生
//
//  Created by fred on 16/6/20.
//  Copyright © 2016年 lideliang. All rights reserved.
//

#import "userAgreementViewController.h"


@implementation userAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];



    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"用户协议";
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:16];
    title.textAlignment= NSTextAlignmentCenter;
    self.navigationItem.titleView=title;
    
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame=CGRectMake(0, 0, 10, 20);
    leftBtn.contentMode=UIViewContentModeCenter;
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    

    
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 70, self.view.frame.size.width - 30, 40)];
    title1.backgroundColor = [UIColor redColor];
    title1.textColor = [UIColor grayColor];
    title1.font = [UIFont systemFontOfSize:20];
    title1.text = @"用户协议";
    [self.view addSubview:title1];
    
    UILabel *content1 = [[UILabel alloc]initWithFrame:CGRectMake(15, title1.frame.origin.y + title1.frame.size.height + 10, self.view.frame.size.width - 30, 120)];
    content1.backgroundColor = [UIColor redColor];
    content1.text = @"本协议是您与明星医生客户端（简称“本客户端”）所有者（以下简称为“星医”）之间就星医客户端服务等相关事宜所订立的契约，请您仔细阅读本注册协议，您点击“注册”按钮后，本协议即构成对双方有约束力的法律文件。";
    content1.lineBreakMode = UILineBreakModeWordWrap;
    content1.numberOfLines = 0;
    [self.view addSubview:content1];
    
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(15, content1.frame.origin.y + content1.frame.size.height + 10, self.view.frame.size.width - 30, 40)];
    //title2.backgroundColor = [UIColor redColor];
    title2.textColor = [UIColor colorWithRed:48.0f/255.0f green:128.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    title2.font = [UIFont systemFontOfSize:20];
    title2.text = @"第1条本客户端服务条款的确认和接纳";
    [self.view addSubview:title2];

    
    
    UILabel *content2 = [[UILabel alloc]initWithFrame:CGRectMake(15, title2.frame.origin.y + title2.frame.size.height + 10, self.view.frame.size.width - 30, 420)];
    content2.backgroundColor = [UIColor redColor];
    content2.text = @"1.1. 本客户端的各项电子服务的所有权和运作权归星医所有。用户同意所有注册协议条款并完成注册程序，才能成为本客户端的正式用户。用户确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方另有特别约定的，依其规定。/n1.2. 用户点击同意本协议的，即视为用户确认自己具有享受本客户端服务、下单购买等相应的权利能力和行为能力，能够独立承担法律责任。/n1.3. 如果您在18周岁以下，您只能在父母或监护人的监护参与下才能使用本客户端。/n1.4. 明星医生保留在中华人民共和国大陆地区法施行之法律允许的范围内独自决定拒绝服务、关闭用户账户、清除或编辑内容或取消订单的权利。/n第2条本客户端服务/n2.1. 星医通过互联网依法为用户提供互联网信息等服务，用户在完全同意本协议及本客户端规定的情况下，方有权使用本客户端的相关服务。/n2.2. 用户必须自行准备如下设备和承担如下开支：/n（1）上网设备，包括并不限于电脑或者其他上网终端、调制解调器及其他必备的上网装置；/n（2）上网开支，包括并不限于网络接入费、上网设备租用费、手机流量费等。";
    content2.lineBreakMode = UILineBreakModeWordWrap;
    content2.numberOfLines = 0;
    [self.view addSubview:content2];
    

}

-(void)leftButton{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
