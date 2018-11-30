//
//  CustomTableView.m
//  SwipeTableView
//
//  Created by Roy lee on 16/4/1.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "CustomTableView.h"
#import "UIView+STFrame.h"
#import "STRefresh.h"
#import "SwipeTableView.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CustomTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, strong) NSArray * dataArr;

@end

@implementation CustomTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        _dataArr = [NSArray array];
        
        self.delegate = self;
        self.dataSource = self;
        self.separatorColor = RGBColor(175, 175, 175);
        [self registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
        self.tableFooterView = [UIView new];
        self.itemIndex = -1;
        self.separatorStyle = UITableViewCellStyleValue1;
        
        self.header = [STRefreshHeader headerWithRefreshingBlock:^(STRefreshHeader *header) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [header endRefreshing];
            });
        }];
    }
    return self;
}

- (void)refreshWithData:(id)numberOfRows atIndex:(NSInteger)index {
    _numberOfRows = [numberOfRows integerValue];
    _itemIndex = index;
    
    [self reloadData];
}

- (void)refreshWithData:(NSArray *)arr {
    _numberOfRows = [arr count];
    _dataArr = arr;
    _itemIndex = -1;
    
    [self reloadData];
}


#pragma mark - UITableView M
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    for (UIView *cellView in cell.subviews)
    {
        
        [cellView removeFromSuperview];
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * title = nil;
    if (_itemIndex >= 0) {
        NSString *str = [NSString stringWithFormat:@"[ ItemView_%ld ] ---- 第 %ld 行",_itemIndex,indexPath.row];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = str;
        
        titleLabel.backgroundColor = [UIColor redColor];
        
        [cell addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).offset(10);
            make.left.equalTo(cell.mas_left).offset(20);
            make.right.equalTo(cell.mas_right).offset(-170);
            make.bottom.equalTo(cell.mas_bottom).offset(-90);
        }];
        
        
        
    }else {
        NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
        NSString *imageUrl = [dic objectForKey:@"pic"];
        
        NSString *titleStr = [dic objectForKey:@"title"];
//        titleStr = [titleStr stringByRemovingPercentEncoding];
        
        NSString *platStr = [dic objectForKey:@"plat"];
        if ([platStr isEqualToString:@"toutiao"]) {
            platStr = @"今日头条";
        } else if ([platStr isEqualToString:@"people"]) {
            platStr = @"人民日报";
        } else if ([platStr isEqualToString:@"world"]) {
            platStr = @"环球网";
        } else if ([platStr isEqualToString:@"red"]) {
            platStr = @"置顶";
    
        }
        
        if ([imageUrl isEqualToString:@"EMPTY"]) {
            
            //TitleLabel
            UILabel *titleText = [[UILabel alloc]init];
            titleText.text = titleStr;
//            titleText.backgroundColor = [UIColor redColor];
            titleText.font = [UIFont systemFontOfSize:16];
            titleText.textColor = [UIColor blackColor];
            titleText.frame = CGRectMake(30, 20, 370, 50);
            titleText.textAlignment = NSTextAlignmentLeft;
            titleText.numberOfLines = 0;//表示label可以多行显示
            [cell addSubview:titleText];
            
            //Label
            UILabel *platText = [[UILabel alloc]init];
            platText.text = platStr;
            platText.font = [UIFont systemFontOfSize:14];
            platText.textColor = [UIColor redColor];
            platText.frame = CGRectMake(30, 75, 200, 30);
            platText.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:platText];
            
        } else {
            
            //TitleLabel
            UILabel *titleText = [[UILabel alloc]init];
            titleText.text = titleStr;
//            titleText.backgroundColor = [UIColor redColor];
            titleText.font = [UIFont systemFontOfSize:16];
            titleText.textColor = [UIColor blackColor];
            titleText.frame = CGRectMake(30, 20, 200, 60);
            titleText.textAlignment = NSTextAlignmentLeft;
            titleText.numberOfLines = 0;//表示label可以多行显示
            [cell addSubview:titleText];
    
            //Label
            UILabel *platText = [[UILabel alloc]init];
            platText.text = platStr;
            platText.font = [UIFont systemFontOfSize:14];
            platText.textColor = [UIColor redColor];
            platText.frame = CGRectMake(30, 85, 200, 30);
            platText.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:platText];
            

            //图片
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.frame = CGRectMake(250, 15, 150, 95);
            [cell addSubview:imageView];
            CALayer * layer = [imageView layer];
            layer.borderColor = [[UIColor redColor] CGColor];
            layer.borderWidth = 1.0f;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                         placeholderImage:[UIImage imageNamed:@"coin.jpg"]];
            
        }
        
        
        
        
    }
    
    
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    NSDictionary *dic = [_dataArr objectAtIndex:indexPath.row];
    
    NSNotification *notification =[NSNotification notificationWithName:@"pushNewsDetailView" object:dic userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
#if !defined(ST_PULLTOREFRESH_HEADER_HEIGHT)
    STRefreshHeader * header = self.header;
    CGFloat orginY = - (header.st_height + self.swipeTableView.swipeHeaderView.st_height + self.swipeTableView.swipeHeaderBar.st_height);
    if (header.st_y != orginY) {
        header.st_y = orginY;
    }
#endif
}

@end
