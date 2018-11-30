//
//  RegisterViewController.m
//  明星医生
//
//  Created by wei feng on 16/1/18.
//  Copyright (c) 2016年 lideliang. All rights reserved.
//

#import "RegisterViewController.h"
#import "userAgreementViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"


@interface RegisterViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong)UIButton *automatic;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *addSelect;
@property(nonatomic,strong)UILabel *address;
@property(nonatomic,strong)UITextField *nameField;
@property(nonatomic,strong)UITextField *verificationField;
@property(nonatomic,strong)UITextField *passwordField;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;
//@property (strong, nonatomic) NSArray *nameField;


@end

@implementation RegisterViewController

- (IBAction)okBtn:(id)sender {
    self.backView.frame=CGRectMake(-1000, -1000, 100, 100);
    NSString *one=[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSString *two=[self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    NSString *three=[self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
    self.addSelect.text=[NSString stringWithFormat:@" %@  %@  %@",one,two,three];
    [self hideMyPicker];

    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPickerData];
    self.view.backgroundColor=[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    
    self.backView=[[UIView alloc]init];
    [self.okButton setTitleColor:[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1] forState:UIControlStateNormal];
    self.backView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    self.bottomView.hidden=YES;
    self.bottomView.backgroundColor=[UIColor whiteColor];
    self.pickerView.delegate=self;
    self.pickerView.dataSource=self;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"会员注册";
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
    account.text=@"账号: ";
    account.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:account];
    
    UITextField *nameField=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, account.frame.origin.y, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];

    _nameField=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, account.frame.origin.y, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];
    _nameField.backgroundColor=[UIColor whiteColor];
    _nameField.placeholder=@" 请输入手机号或邮箱";
    _nameField.layer.borderWidth=1;
    _nameField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_nameField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.clearButtonMode=UITextFieldViewModeAlways;
    _nameField.delegate = self;
    [self.view addSubview:_nameField];
    
    
    UILabel *password=[[UILabel alloc]initWithFrame:CGRectMake(30, account.frame.origin.y+account.frame.size.height+20, 50, 30)];
    password.text=@"密码: ";
    password.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:password];
    
    UITextField *passwordField=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, account.frame.origin.y+account.frame.size.height+20, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];
    _passwordField=[[UITextField alloc]initWithFrame:CGRectMake(account.frame.origin.x+account.frame.size.width+10, account.frame.origin.y+account.frame.size.height+20, self.view.frame.size.width-30-account.frame.size.width-30-10, 30)];
    
    _passwordField.secureTextEntry = YES;
    _passwordField.backgroundColor=[UIColor whiteColor];
    _passwordField.placeholder=@" 请输入密码";
    _passwordField.layer.borderWidth=1;
    _passwordField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_passwordField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _passwordField.clearButtonMode=UITextFieldViewModeAlways;
    _passwordField.delegate = self;
    [self.view addSubview:_passwordField];
    
    
    UILabel *verificationLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, password.frame.origin.y+password.frame.size.height+20, account.frame.size.width, 30)];
    verificationLabel.text=@"验证码: ";
    verificationLabel.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:verificationLabel];
    
    _verificationField=[[UITextField alloc]initWithFrame:CGRectMake(verificationLabel.frame.size.width+verificationLabel.frame.origin.x+10, password.frame.origin.y+password.frame.size.height+20, 100, 30)];
    _verificationField.backgroundColor=[UIColor whiteColor];
    _verificationField.placeholder=@" 请输入验证码";
    _verificationField.layer.borderWidth=1;
    _verificationField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _verificationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_verificationField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _verificationField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _verificationField.clearButtonMode=UITextFieldViewModeAlways;
    _verificationField.delegate = self;
    [self.view addSubview:_verificationField];
    
    UIButton *verificationBtn=[[UIButton alloc]initWithFrame:CGRectMake(_verificationField.frame.size.width+_verificationField.frame.origin.x+10, _verificationField.frame.origin.y, nameField.frame.size.width-_verificationField.frame.size.width-10, 30)];
    verificationBtn.backgroundColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    [verificationBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    verificationBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [verificationBtn addTarget:self action:@selector(getVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:verificationBtn];
    
    
    UILabel *address=[[UILabel alloc]initWithFrame:CGRectMake(30, verificationBtn.frame.origin.y+verificationBtn.frame.size.height+20, 50, 30)];
    address.text=@"地址: ";
    address.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:address];
    
    self.addSelect=[[UILabel alloc]initWithFrame:CGRectMake(address.frame.size.width+address.frame.origin.x+10, address.frame.origin.y, passwordField.frame.size.width, 30)];
    self.addSelect.text=@"  请选择市区县";
//    NSString *address = self.addSelect.text
    self.addSelect.font=[UIFont systemFontOfSize:14];
    self.addSelect.textColor=[UIColor lightGrayColor];
    self.addSelect.backgroundColor=[UIColor whiteColor];
    self.addSelect.layer.borderWidth=1;
    self.addSelect.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [self.view addSubview:self.addSelect];
    
    UIButton *addressBtn=[[UIButton alloc]init];
    addressBtn.frame=self.addSelect.frame;
    addressBtn.backgroundColor=[UIColor clearColor];
    [addressBtn addTarget:self action:@selector(SelectAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addressBtn];
    
    self.automatic=[[UIButton alloc]initWithFrame:CGRectMake(address.frame.origin.x, address.frame.origin.y+address.frame.size.height+20, 30, 30)];
    [self.automatic setImage:[UIImage imageNamed:@"未选中.png"] forState:UIControlStateNormal];
    [self.automatic setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
    [self.automatic addTarget:self action:@selector(automaticBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.automatic];
    
    UIButton *userAgreement=[[UIButton alloc]initWithFrame:CGRectMake(self.automatic.frame.origin.x+self.automatic.frame.size.width-10, self.automatic.frame.origin.y, 100, 30)];
    [userAgreement setTitle:@"用户协议" forState:UIControlStateNormal];
    [userAgreement setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    userAgreement.font=[UIFont systemFontOfSize:12];
    [userAgreement addTarget:self action:@selector(userAgreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:userAgreement];
    
    UIButton *mainBtn=[[UIButton alloc]initWithFrame:CGRectMake(50, userAgreement.frame.size.height+userAgreement.frame.origin.y+50, self.view.frame.size.width-2*50, 30)];
    mainBtn.backgroundColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    [mainBtn setTitle:@"注册并登陆" forState:UIControlStateNormal];
    mainBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    mainBtn.layer.cornerRadius=5;
    [mainBtn addTarget:self action:@selector(goMain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainBtn];
}


//  页面消失
//
//- (void) viewDidAppear:(BOOL)paramAnimated{
//    
//    [super viewDidAppear:paramAnimated];
//    [self performSelector:@selector(pushSecondController) withObject:nil afterDelay:1.0f];
//}

-(void)getVerification {
    /**
     *  @from                    v1.1.1
     *  @brief                   获取验证码(Get verification code)
     *
     *  @param method            获取验证码的方法(The method of getting verificationCode)
     *  @param phoneNumber       电话号码(The phone number)
     *  @param zone              区域号，不要加"+"号(Area code)
     *  @param customIdentifier  自定义短信模板标识 该标识需从官网http://www.mob.com上申请，审核通过后获得。(Custom model of SMS.  The identifier can get it  from http://www.mob.com  when the application had approved)
     *  @param result            请求结果回调(Results of the request)
     */
    
   
}

- (void)userAgreementBtn
{
  
}

-(void)SelectAddress{
    self.bottomView.hidden=NO;
    self.backView.frame=self.view.frame;
//    self.backView.frame=self.view.frame;
    [self.view addSubview:self.backView];
    [self.backView addSubview:self.bottomView];
    NSLog(@"选择地区");
}

/*
 *点击注册按钮
 */
-(void)goMain{
    
}
-(void)automaticBtn{
    
    if (self.automatic.selected==YES) {
        self.automatic.selected=NO;
    }else{
        self.automatic.selected=YES;
    }
}

-(void)leftButton{
     self.hidesBottomBarWhenPushed=YES;
    [self.navigationController popViewControllerAnimated:YES];
   
self.hidesBottomBarWhenPushed=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPickerData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
    
    if (self.selectedArray.count > 0) {
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    
    if (self.cityArray.count > 0) {
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
}
- (void)hideMyPicker {
    self.bottomView.hidden=YES;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 110;
    } else if (component == 1) {
        return 100;
    } else {
        return 110;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 12;
        //        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentLeft];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = nil;
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (self.selectedArray.count > 0 && self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:row]];
        } else {
            self.townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

//输入完成之后软键盘隐退
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
   
    
    return YES;
    
}
- (BOOL)verificationFieldShouldReturn:(UITextField *)verificationField {
    
 [verificationField resignFirstResponder];
    
    
    return YES;
    
}


-(void)pushSecondController{
    
    

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
        return YES;
    }
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
