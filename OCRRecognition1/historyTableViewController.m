//
//  historyTableViewController.m
//  OCRRecognition1
//
//  Created by fred on 2018/4/16.
//  Copyright © 2018年 fred. All rights reserved.
//

#import "historyTableViewController.h"
#import "FMDatabase.h"
#import <Masonry.h>
#import "detailViewController.h"

@interface historyTableViewController ()

@property (nonnull, strong) FMDatabase * database;
@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation historyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //数据库在沙盒中的路径
    NSString * hisFileName = [[NSSearchPathForDirectoriesInDomains(13, 1, 1)lastObject]stringByAppendingPathComponent:@"hisOfFMDB.sqlite"];
    NSLog(@"%@",hisFileName);
    
    //创建数据库
    self.database = [[FMDatabase alloc]initWithPath:hisFileName];
    
    self.title = @" 历史记录 ";
    
    
    //导航栏 右按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 45, 20);
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    rightBtn.contentMode=UIViewContentModeCenter;
    rightBtn.layer.cornerRadius=2;
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [rightBtn setTitle:@" 搜索 " forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1] forState:UIControlStateNormal];
    rightBtn.backgroundColor=[UIColor colorWithRed:163.0/255 green:250.0/255 blue:1 alpha:1];
    [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
//    //打开数据库
//    if ([self.database open]) {
//        NSLog(@"打开数据库成功");
//        //创建表 返回值为BOOL
//        BOOL flag = [self.database executeUpdate:@"create table if not exists hisOfFMDB (id integer primary key autoincrement,name text,img blob)"];
//        if (flag) {
//            NSLog(@"成功建表");
//        }else{
//            NSLog(@"失败建表");
//        }
//        
//        //关闭数据库
//        [self.database close];
//        
//    }else{
//        NSLog(@"打开数据库失败");
//    }
    
    
    
    
    
//    if ([self.database open]) {
//        for (NSInteger i = 0; i < 2; i ++) {
//
//            BOOL flag = [self.database executeUpdate:@"insert into hisOfFMDB (name) values(?)",[NSString stringWithFormat:@"爱吃鱼--"]];
//
//            if (flag) {
//                NSLog(@"插入成功");
//            }else{
//                NSLog(@"插入失败");
//            }
//
//        }
//    }
//    [self.database close];

    
    
    
    
//    if ([self.database open]) {
//
//        //返回查询数据的结果集
//        FMResultSet * resultSet = [self.database executeQuery:@"select * from hisOfFMDB"];
//        //查询表中的每一个记录
//        while ([resultSet next]) {
//
//            NSString * name = [resultSet stringForColumn:@"name"];
//            NSLog(@"%@",name);
//
//        }
//
//    }
//    [self.database close];
    
    
    
    
    
    
//    if ([self.database open]) {
//
//        BOOL flag = [self.database executeUpdate:@"delete from hisOfFMDB where name = "];
//
//        if (flag) {
//            NSLog(@"删除成功");
//        }else{
//            NSLog(@"删除失败");
//        }
//
//    }
//    [self.database close];
    
    
    
    
    if ([self.database open]) {
        
        //返回查询数据的结果集
        FMResultSet *resultSet = [self.database executeQuery:@"select * from hisOfFMDB"];
        
        _imgArray = [NSMutableArray array];
        
        //查询表中的每一个记录
        while ([resultSet next]) {
        
            NSData * data = [resultSet dataForColumn:@"img"];
            NSString * name = [resultSet stringForColumn:@"name"];
            NSString * time = [resultSet stringForColumn:@"time"];
            NSString * tId = [resultSet stringForColumn:@"id"];
           
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:data forKey:@"data"];
            [dic setObject:name forKey:@"name"];
            [dic setObject:time forKey:@"time"];
            [dic setObject:tId forKey:@"id"];
            [_imgArray addObject:dic];
    
            
        }
        NSLog(@"%@",_imgArray);
        [self.database close];
    }
    
    

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imgArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    } else {
        for(UIView * view in cell.subviews){
            [view removeFromSuperview];
        }
    }
    
  
//    cell.backgroundColor = [UIColor grayColor];
    
    NSDictionary *dic = [_imgArray objectAtIndex:indexPath.row];
    NSData *data = [dic objectForKey:@"data"];
    UIImage *image = [UIImage imageWithData:data];
    NSString *number = [dic objectForKey:@"name"];
    NSString *numberID = [dic objectForKey:@"id"];
    NSString *time = [dic objectForKey:@"time"];
    
    //Label
    UILabel *numberText = [[UILabel alloc]init];
    numberText.text = number;
    numberText.font = [UIFont systemFontOfSize:14];
    numberText.textColor = [UIColor redColor];
    numberText.frame = CGRectMake(30, 25, 200, 30);
    numberText.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:numberText];
    
    
    //Label
    UILabel *tiemText = [[UILabel alloc]init];
    tiemText.text = time;
    tiemText.font = [UIFont systemFontOfSize:14];
    tiemText.textColor = [UIColor redColor];
    tiemText.frame = CGRectMake(30, 90, 200, 30);
    tiemText.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:tiemText];

    
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.frame = CGRectMake(200, 20, 200, 95);
    [cell addSubview:imageView];

    CALayer * layer = [imageView layer];
    layer.borderColor = [[UIColor redColor] CGColor];
    layer.borderWidth = 1.0f;
    
    
    
 
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    detailViewController *vC = [[detailViewController alloc]init];
    vC.imgDic = [_imgArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vC animated:true];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    //设置右边按钮的文字
    return @"删除";
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //实现删除操作
    NSDictionary *dic = [_imgArray objectAtIndex:indexPath.row];
    NSString *numberID = [dic objectForKey:@"id"];
    
    [_imgArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    if ([self.database open]) {
        
        
        BOOL flag = [self.database executeUpdate:@"delete from hisOfFMDB where id = ?;",numberID];
        
        if (flag) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
        [self.database close];
    }
    

    
    
}





////左滑编辑模式
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //可在此对点击cell右边出现的按钮进行逻辑处理
//}
//





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
