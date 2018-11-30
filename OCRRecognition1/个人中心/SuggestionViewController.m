//
//  SuggestionViewController.m
//  明星医生
//
//  Created by wei feng on 16/1/14.
//  Copyright (c) 2016年 lideliang. All rights reserved.
//

#import "SuggestionViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"



@interface SuggestionViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextField *phoneNum;
@property(nonatomic,strong)UITextView *contentView;
@property(nonatomic,strong)UIButton *submit;
@property (strong, nonatomic) NSData *cookiesdata;
-(void)isPhoneNumberOfString;


@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"意见反馈";
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
    
    UILabel *headTit=[[UILabel alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width, 40)];
    headTit.text=@"我们懂得聆听,知错就改,您的意见是";
    headTit.font=[UIFont systemFontOfSize:14];
    headTit.textColor=[UIColor blackColor];
    [self.view addSubview:headTit];

    _contentView=[[UITextView alloc]initWithFrame:CGRectMake(10, headTit.frame.size.height+headTit.frame.origin.y, self.view.frame.size.width-2*10, 150)];
    _contentView.delegate=self;
//    _contentView.text = @"请您将你的意见告知我们";
    _contentView.font=[UIFont systemFontOfSize:13];
    _contentView.textColor=[UIColor lightGrayColor];
    _contentView.layer.borderWidth=1;
    _contentView.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [self.view addSubview:_contentView];
    
    UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, _contentView.frame.origin.y+_contentView.frame.size.height+10, self.view.frame.size.width-2*10, 30)];
    phoneLabel.text=@"请留下您的手机号,明星医生会第一时间联系您";
    phoneLabel.font=[UIFont systemFontOfSize:14];
    [self.view addSubview:phoneLabel];
    
    _phoneNum=[[UITextField alloc]initWithFrame:CGRectMake(10, phoneLabel.frame.size.height+phoneLabel.frame.origin.y+10, self.view.frame.size.width-2*10, 30)];
    _phoneNum.placeholder=@" 请输入手机号";
    _phoneNum.layer.borderWidth=1;
    _phoneNum.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _phoneNum.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_phoneNum setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_phoneNum];
    
    _submit=[[UIButton alloc]initWithFrame:CGRectMake(10, _phoneNum.frame.size.height+_phoneNum.frame.origin.y+30, self.view.frame.size.width-2*10, 40)];
    _submit.backgroundColor=[UIColor colorWithRed:253.0/255 green:76.0/255 blue:82.0/255 alpha:1];
    [_submit setTitle:@"提  交" forState:UIControlStateNormal];
    _submit.tintColor=[UIColor whiteColor];
    _submit.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    _submit.layer.borderColor=[[UIColor redColor]CGColor];
    _submit.layer.borderWidth=1;
    _submit.layer.cornerRadius=5;
    [_submit addTarget:self action:@selector(submitData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submit];
    

    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"写下你想说的..."]) {
        textView.text = @"";
        textView.textColor=[UIColor blackColor];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.textColor=[UIColor lightGrayColor];
        textView.text = @"写下你想说的...";
    }
}

-(void)leftButton{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)submitData{
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
