//
//  WelcomeViewController.m
//  明星医生
//
//  Created by wei feng on 16/1/18.
//  Copyright (c) 2016年 lideliang. All rights reserved.
//

#import "WelcomeViewController.h"
#import "ForgetViewController.h"
#import "RegisterViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"

NSString *testNSString = @"Hello Test";

@interface WelcomeViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong)UILabel *addSelect;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *passwordField;
@property(nonatomic,strong)NSString *loginName;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *testNSString;


@property(nonatomic,strong)UIButton *automatic;


@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UITextField *verificationField;



@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) NSData *cookiesdata;
@end

@implementation WelcomeViewController


- (void)loadView
{
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:applicationFrame];
    contentView.backgroundColor = [UIColor blackColor];
    self.view = contentView;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults boolForKey:@"isAutomatic"]) {
        [self QuickLoginIn];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"会员登录";
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:16];
    title.textAlignment= NSTextAlignmentCenter;
    self.navigationItem.titleView=title;
    
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 40, 20);
    rightBtn.layer.cornerRadius=2;
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    rightBtn.contentMode=UIViewContentModeCenter;
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1] forState:UIControlStateNormal];
    rightBtn.backgroundColor=[UIColor colorWithRed:163.0/255 green:250.0/255 blue:1 alpha:1];
    [rightBtn addTarget:self action:@selector(rightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    

    
    _nameField=[[UITextField alloc]initWithFrame:CGRectMake(50, 110, self.view.frame.size.width-50*2, 30)];
    

    _nameField.backgroundColor=[UIColor whiteColor];
    _nameField.placeholder=@" 请输入登陆账号";
    _nameField.layer.borderWidth=1;
    _nameField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nameField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.clearButtonMode=UITextFieldViewModeAlways;
    _nameField.delegate = self;
    [self.view addSubview:_nameField];
    
    _passwordField=[[UITextField alloc]initWithFrame:CGRectMake(50, _nameField.frame.size.height+_nameField.frame.origin.y+30, self.view.frame.size.width-50*2, 30)];
    
    _passwordField.secureTextEntry = YES;
    _passwordField.backgroundColor=[UIColor whiteColor];
    _passwordField.placeholder=@" 请输入登陆密码";
    _passwordField.layer.borderWidth=1;
    _passwordField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_passwordField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.clearButtonMode=UITextFieldViewModeAlways;
    _passwordField.delegate = self;
    [self.view addSubview:_passwordField];

    
    self.automatic=[[UIButton alloc]initWithFrame:CGRectMake(50, _passwordField.frame.origin.y+_passwordField.frame.size.height+40,30, 30)];
    [self.automatic setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
    [self.automatic setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
    [self.automatic addTarget:self action:@selector(automaticBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.automatic];
    
    UILabel *automaticLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.automatic.frame.origin.x+30, self.automatic.frame.origin.y, 100, 30)];
    automaticLabel.text=@"自动登录";
    automaticLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:automaticLabel];
    
    UIButton *forgetBtn=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50-100, automaticLabel.frame.origin.y, 100, 30)];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    UIButton *welBtn=[[UIButton alloc]initWithFrame:CGRectMake(_passwordField.frame.origin.x, forgetBtn.frame.origin.y+30+30, _passwordField.frame.size.width, 30)];
    welBtn.backgroundColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    [welBtn setTitle:@"立即登录" forState:UIControlStateNormal];
    [welBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    welBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    welBtn.layer.cornerRadius=5;
    [welBtn addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:welBtn];
    
    UILabel *thirdLabel=[[UILabel alloc]initWithFrame:CGRectMake(welBtn.frame.origin.x, welBtn.frame.origin.y+30+30, welBtn.frame.size.width, 30)];
    thirdLabel.text=@"————— 第三方登陆 —————";
    thirdLabel.textAlignment=NSTextAlignmentCenter;
    thirdLabel.font=[UIFont systemFontOfSize:12];
    thirdLabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:thirdLabel];
    
    UIButton *QQ=[[UIButton alloc]initWithFrame:CGRectMake(100, thirdLabel.frame.origin.y+30+10, 30, 30)];
    QQ.contentMode=UIViewContentModeCenter;
    [QQ setImage:[UIImage imageNamed:@"QQ未选中.png"] forState:UIControlStateNormal];
    [QQ setImage:[UIImage imageNamed:@"QQ点击.png"] forState:UIControlStateSelected];
    [QQ addTarget:self action:@selector(qqbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQ];
    UILabel *QQtext=[[UILabel alloc]initWithFrame:CGRectMake(QQ.frame.origin.x, QQ.frame.origin.y+30, 30, 20)];
    QQtext.text=@"QQ";
    QQtext.textAlignment=NSTextAlignmentCenter;
    QQtext.textColor=[UIColor lightGrayColor];
    QQtext.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:QQtext];
    
    
    UIButton *WeChat=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100-30, thirdLabel.frame.origin.y+30+10, 30, 30)];
    WeChat.contentMode=UIViewContentModeCenter;
    [WeChat setImage:[UIImage imageNamed:@"微信未选中.png"] forState:UIControlStateNormal];
    [WeChat setImage:[UIImage imageNamed:@"微信点击.png"] forState:UIControlStateSelected];
    [WeChat addTarget:self action:@selector(wtbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WeChat];
    
    UILabel *Wetext=[[UILabel alloc]initWithFrame:CGRectMake(WeChat.frame.origin.x, QQ.frame.origin.y+30, 30, 20)];
    Wetext.text=@"微信";
    Wetext.textAlignment=NSTextAlignmentCenter;
    Wetext.textColor=[UIColor lightGrayColor];
    Wetext.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:Wetext];


}
-(void)forgetBtn{
    ForgetViewController *vc=[[ForgetViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)qqbtn {
    

}

- (void)wtbtn
{
}
-(void)rightButton{
    self.hidesBottomBarWhenPushed=YES;
    RegisterViewController *vc=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];


    }

//登录主函数
-(void)goMain{
    //先判断两项是否都已经填写
    if (_nameField.text.length == 0 || _passwordField.text.length ==0 )
    {
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"请先将账号和密码信息填写完整";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [hud hide:YES afterDelay:1.5];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
    } else{
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = @"登录中。。。。。。";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            // Do something...
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        [hud hide:YES afterDelay:1.5];
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        
       [self  performSelector:@selector(QuickLoginIn) withObject:nil afterDelay:1.5f];
        
       

        
        
        
    }
    
   
    
    
    
    

   
}


//快速登录入口
-(void)QuickLoginIn{
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController popViewControllerAnimated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

-(void)automaticBtn{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    if (self.automatic.selected == YES) {
        [userDefaults setBool:NO forKey:@"isAutomatic"];
        self.automatic.selected = NO;
    }else{
        [userDefaults setBool:YES forKey:@"isAutomatic"];
        self.automatic.selected = YES;
    }
}

- (void)viewDidUnload
{
//    [myAccount release];
//    txtNSString = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//输入完成之后软键盘隐退
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

/**
 检查Email是否正确
 
 - parameter mail: 输入的Email
 
 是Email返回truth，不是Email返回false
 
 - returns: 返回true or false
 */
- (BOOL)isNotEmail:(NSString*)mail
{
    NSString *mailPattern = [[NSString alloc]init];
    mailPattern = @"^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$";
    NSPredicate *regextestmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mailPattern];
    BOOL tem = [regextestmail evaluateWithObject:mail];
    if (tem)
    {
        return true;
    }
    else
    {
        return false;
    }
}


//正则判断手机号码格式
- (BOOL)isAPhoneNum:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}


//-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    [textFiled resignFirstResponder];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
