//
//  ForgetViewController.m
//  明星医生
//
//  Created by wei feng on 16/1/18.
//  Copyright (c) 2016年 lideliang. All rights reserved.
//

#import "ForgetViewController.h"




@interface ForgetViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong)UILabel *addSelect;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UITextField *namefield;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)UIButton *automatic;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UITextField *verificationField;
@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"忘记密码";
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
    
    UILabel *account=[[UILabel alloc]initWithFrame:CGRectMake(30, 100, 50, 30)];
    account.text=@"账号:";
    account.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:account];
    
    _namefield=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, account.frame.origin.y, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];
    _namefield.backgroundColor=[UIColor whiteColor];
    _namefield.placeholder=@" 请输入手机号或邮箱";
    _namefield.layer.borderWidth=1;
    _namefield.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _namefield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_namefield setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _namefield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _namefield.clearButtonMode=UITextFieldViewModeAlways;
    [self.view addSubview:_namefield];
    
    UILabel *verificationLabel=[[UILabel alloc]initWithFrame:CGRectMake(account.frame.origin.x, _namefield.frame.origin.y+_namefield.frame.size.height+20, account.frame.size.width, 30)];
    verificationLabel.text=@"验证码:";
    verificationLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:verificationLabel];
    
    _verificationField=[[UITextField alloc]initWithFrame:CGRectMake(verificationLabel.frame.size.width+verificationLabel.frame.origin.x+10, _namefield.frame.origin.y+_namefield.frame.size.height+20, 100, 30)];
    _verificationField.backgroundColor=[UIColor whiteColor];
    _verificationField.placeholder=@" 请输入验证码";
    _verificationField.layer.borderWidth=1;
    _verificationField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _verificationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_verificationField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _verificationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verificationField.clearButtonMode=UITextFieldViewModeAlways;
    [self.view addSubview:_verificationField];

    UIButton *verificationBtn=[[UIButton alloc]initWithFrame:CGRectMake(_verificationField.frame.size.width+_verificationField.frame.origin.x+10, _verificationField.frame.origin.y, _namefield.frame.size.width-_verificationField.frame.size.width-10, 30)];
    verificationBtn.backgroundColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    [verificationBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [verificationBtn addTarget:self action:@selector(submitPhoneNum) forControlEvents:UIControlEventTouchUpInside];
    verificationBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [self.view addSubview:verificationBtn];
    
    
    
    
    UILabel *passwordLabel=[[UILabel alloc]initWithFrame:CGRectMake(account.frame.origin.x, verificationLabel.frame.origin.y+verificationLabel.frame.size.height+20, verificationLabel.frame.size.width, 30)];
    passwordLabel.text=@"新密码:";
    passwordLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:passwordLabel];

    _passwordField=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, passwordLabel.frame.origin.y, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];
    _passwordField.backgroundColor=[UIColor whiteColor];
    _passwordField.placeholder=@" 请输入新密码";
    _passwordField.layer.borderWidth=1;
    _passwordField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_passwordField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.clearButtonMode=UITextFieldViewModeAlways;
    [self.view addSubview:_passwordField];

    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, _passwordField.frame.origin.y+_passwordField.frame.size.height+80, self.view.frame.size.width-2*50, 30)];
    mainBtn.backgroundColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    [mainBtn setTitle:@"确  定" forState:UIControlStateNormal];
    mainBtn.layer.cornerRadius=5;
    [mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mainBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    [mainBtn addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainBtn];
}
-(void)submitPhoneNum{
    
}
-(void)goMain{
    
}

-(void)leftButton{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//输入完成之后软键盘隐退
- (BOOL)textFieldShouldReturn:(UITextField *)namefield {
    
    [namefield resignFirstResponder];
    
    return YES;
    
}
-(void)pushSecondController{
    
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
    [self presentViewController:vc animated:YES completion:nil];


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
