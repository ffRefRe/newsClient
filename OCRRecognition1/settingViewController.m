//
//  settingViewController.m
//  OCRRecognition1
//
//  Created by fred on 2018/4/19.
//  Copyright © 2018年 fred. All rights reserved.
//

#import "settingViewController.h"
#import "InstalledTableViewController.h"
#import "SuggestionViewController.h"
#import "historyTableViewController.h"
#import <Masonry.h>
#import "WelcomeViewController.h"

@interface settingViewController ()

@property(assign, nonatomic)BOOL isLogin;
@property (nonatomic, strong)UILabel* nameLable;

@end

@implementation settingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    _isLogin = true;
    [_tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self getNameLable];
    
    _isLogin = false;
    _tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);

        make.top.equalTo(self.view.mas_top);
    }];
    
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"个人中心";
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:16];
    title.textAlignment= NSTextAlignmentCenter;
    self.navigationItem.titleView=title;
    

    self.tableView.showsVerticalScrollIndicator=NO;
    [self.tabBarController.tabBar setTintColor:[UIColor colorWithRed:0 green:170.0/255 blue:192.0/255 alpha:1]];
    
    
    // nav bar

    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 40, 20);
    rightBtn.layer.cornerRadius=2;
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    rightBtn.contentMode=UIViewContentModeCenter;
    [rightBtn setTitle:@"登录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1] forState:UIControlStateNormal];
    rightBtn.backgroundColor=[UIColor colorWithRed:163.0/255 green:250.0/255 blue:1 alpha:1];
    [rightBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;



//    self.navigationItem.rightBarButtonItem = _isLogin?nil:rightItem;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }else{
        return 6;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    
    
    if (indexPath.section==0) {
        static NSString *CellIdentifier = @"Cell0";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        } else {
            for(UIView * view in cell.subviews){
                [view removeFromSuperview];
            }
        }
        
        UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QQ未选中.png"]];
        logoImage.frame=CGRectMake(10, 10, 60, 60);
        [cell addSubview:logoImage];
        
        _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(logoImage.frame.size.width+10+10, 0, self.view.frame.size.width-logoImage.frame.size.width-10, 80)];
        _nameLable.font=[UIFont systemFontOfSize:16];
       _nameLable.text = @"  用户ID";
        if (_isLogin) {
            _nameLable.text = @"  fjl";
        }
        
        [cell addSubview:_nameLable];

        
        
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        } else {
            for(UIView * view in cell.subviews){
                [view removeFromSuperview];
            }
        }
        
        UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 60)];
        
        [cell addSubview:textLabel];
        textLabel.font=[UIFont systemFontOfSize:14];
        if (indexPath.row==0) {
            textLabel.text=@"个人账户";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的账户.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        } else if (indexPath.row==1) {
            textLabel.text=@"历史记录";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"发现.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        } else if (indexPath.row==2) {
            textLabel.text=@"批量导出";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"在线咨询.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        } else if (indexPath.row==3) {
            textLabel.text=@"意见反馈";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"意见反馈.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        } else if (indexPath.row==4) {
            textLabel.text=@"设置";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"设置.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        } else if (indexPath.row==5) {
            textLabel.text=@"关于";
            
            UIImageView *logoImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"病例单.png"]];
            logoImage.contentMode=UIViewContentModeCenter;
            logoImage.frame=CGRectMake(10, 0, 40, 60);
            [cell addSubview:logoImage];
        }
        
        
        
        return cell;
        
    }
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
    }else{
//        if (indexPath.row==0) {
//            self.hidesBottomBarWhenPushed=YES;
//            MyAccountViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"MyAccount"];
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
//        }
        if (indexPath.row==1) {
            self.hidesBottomBarWhenPushed=YES;
            historyTableViewController *vc=[[historyTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
//        if (indexPath.row==2) {
//            self.hidesBottomBarWhenPushed=YES;
//            MyDoctorTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"MyDoctor"];
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
//        }
        if (indexPath.row==3) {
            self.hidesBottomBarWhenPushed=YES;
            SuggestionViewController *vc=[[SuggestionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
        if (indexPath.row==4) {
            self.hidesBottomBarWhenPushed=YES;
            InstalledTableViewController *vc=[[InstalledTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed=NO;
        }
//        if (indexPath.row==5) {
//            self.hidesBottomBarWhenPushed=YES;
//            FriendTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"Friend"];
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
//        }
//        if (indexPath.row==6) {
//            self.hidesBottomBarWhenPushed=YES;
//            InstalledTableViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"Installed"];
//            [self.navigationController pushViewController:vc animated:YES];
//            self.hidesBottomBarWhenPushed=NO;
//        }
        
        
    }
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return @" ";
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else{
        
        return 60;
    }
    
}

- (void)login {
    self.hidesBottomBarWhenPushed=YES;

    WelcomeViewController *vc=[[WelcomeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
    self.navigationItem.rightBarButtonItem = nil;
    _isLogin = true;
    
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
