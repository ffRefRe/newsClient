//
//  settingViewController.h
//  OCRRecognition1
//
//  Created by fred on 2018/4/19.
//  Copyright © 2018年 fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface settingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic)  UITableView *tableView;
//UITableView中的数据，用一个字符串数组来保存
@property (strong, nonatomic) NSMutableArray *tableDataArr;

@end
