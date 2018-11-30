//
//  InstalledTableViewController.m
//  明星医生
//
//  Created by wei feng on 16/1/15.
//  Copyright (c) 2016年 lideliang. All rights reserved.
//

#import "InstalledTableViewController.h"

@interface InstalledTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic,strong)UIButton *Btn;
@property(nonatomic,strong)UITableViewCell *cellAboutUs;
@end

@implementation InstalledTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"设置";
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
    
    UIView *buttom=[[UIView alloc]init];
    self.tableView.tableFooterView=buttom;
    
    
    
    _Btn=[[UIButton alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width-2*10, 40)];
    [_Btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [_Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _Btn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    _Btn.backgroundColor=[UIColor colorWithRed:1 green:77.0/255 blue:83.0/255 alpha:1];
    _Btn.layer.cornerRadius=5;
    [_Btn addTarget:self action:@selector(withdraw) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:_Btn];
    


}
-(void)leftButton{
    [self.navigationController popViewControllerAnimated:YES];
    
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
    
        return 3;
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstalledCell" forIndexPath:indexPath];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *headImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"个人信息.png"]];
        headImage.frame=CGRectMake(20, 10, 20, 20);
        
        UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width+10, 10, 100, 20)];
        text.text=@"个人信息";
        text.font=[UIFont systemFontOfSize:13];
        [cell addSubview:text];
        [cell addSubview:headImage];
         return cell;
    }else{
        if (indexPath.row==0) {
            
            _cellAboutUs = [tableView dequeueReusableCellWithIdentifier:@"InstalledCell" forIndexPath:indexPath];
            _cellAboutUs.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
            
            UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
            text.text=@"关于明星医生";
            text.font=[UIFont systemFontOfSize:13];
            [_cellAboutUs addSubview:text];
            
            return _cellAboutUs;
        }
        if (indexPath.row==1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstalledCell" forIndexPath:indexPath];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
            text.text=@"服务协议";
            text.font=[UIFont systemFontOfSize:13];
            [cell addSubview:text];
            
            return cell;
        }
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstalledCell" forIndexPath:indexPath];
            UILabel *text=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
            text.text=@"版本号";
            text.font=[UIFont systemFontOfSize:13];
            UILabel *name=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-10-100, 10, 100, 20)];
            name.text=@"2.9.2 Build1035";
            name.font=[UIFont systemFontOfSize:13];
            [cell addSubview:name];
            
            [cell addSubview:text];
            
            return cell;
        }
       

    }
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 10;
    
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




//  退出登录，回到登录页面
-(void)withdraw{

    //将userDefaults中的isAutomatic设置为NO,从而退出登录
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"isAutomatic"];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic) {
        [userDefaults removeObjectForKey:key];
    }

    [userDefaults synchronize];
    
    //两段代码的先后顺序，决定了执行顺序
    UIViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"Welcome"];
    [self presentViewController:vc animated:YES completion:nil];

}

-(void)AboutUs{
   

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
