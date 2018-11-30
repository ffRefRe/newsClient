//
//  STViewController.m
//  SwipeTableView
//
//  Created by Roy lee on 16/4/1.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "STViewController.h"
#import "SwipeTableView.h"
#import "CustomTableView.h"
#import "CustomCollectionView.h"
#import "CustomSegmentControl.h"
#import "UIView+STFrame.h"
#import "STImageController.h"
#import "STTransitions.h"
#import "STRefresh.h"
#import <objc/message.h>
#import <AFNetworking.h>
#import "newsDetailViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"



@interface STViewController ()<SwipeTableViewDataSource,SwipeTableViewDelegate,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) CustomSegmentControl * segmentBar;
@property (nonatomic, strong) CustomTableView * tableView;
@property (nonatomic, strong) CustomCollectionView * collectionView;
@property (nonatomic, strong) NSMutableDictionary * dataDic;
@property (nonatomic, strong) NSMutableDictionary * dataMDic;

@property (nonatomic, strong) CustomTableView * tableView1;


@end

@implementation STViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataMDic = [NSMutableDictionary dictionary];
    
    [self sendRequest:0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNewsDetailViewController:) name:@"pushNewsDetailView" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestNewData) name:@"requestNewData" object:nil];
    
    BOOL disableBarScroll = _type == STControllerTypeDisableBarScroll;
    BOOL hiddenNavigationBar = _type == STControllerTypeHiddenNavBar;
    
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.swipeHeaderBar = self.segmentBar;
    _swipeTableView.swipeHeaderBarScrollDisabled = disableBarScroll;
    [self.view addSubview:_swipeTableView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // nav bar
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"- Header" style:UIBarButtonItemStylePlain target:self action:@selector(setSwipeTableHeader:)];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc]initWithTitle:@"- Bar" style:UIBarButtonItemStylePlain target:self action:@selector(setSwipeTableBar:)];
    self.navigationItem.leftBarButtonItem = disableBarScroll?nil:leftBarItem;
    self.navigationItem.rightBarButtonItem = disableBarScroll?nil:rightBarItem;
    [self.navigationController.navigationBar setTintColor:RGBColor(234, 39, 0)];
    
    // edge gesture
    [_swipeTableView.contentView.panGestureRecognizer requireGestureRecognizerToFail:self.screenEdgePanGestureRecognizer];
    
    // init data
    _dataDic = [@{} mutableCopy];
    

    
    // 一次性请求所有item的数据
    [self getAllData];
}

- (void)sendRequest:(int)type{
    
    //对请求路径的说明
    //协议头+主机地址+接口名称+？+参数1&参数2&参数3
    //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
    //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
    
    //1.确定请求路径
    
    NSString *urlStr = @"http://45.76.74.189:8000/newsfetch/?offset=10";
    
    if(type == 1) {
        urlStr = @"http://45.76.74.189:8000/newsfetch/?offset=10&plat=people";
       
    } else if(type == 2) {
        urlStr = @"http://45.76.74.189:8000/newsfetch/?offset=10&plat=toutiao";
    } else if(type == 3) {
        urlStr = @"http://45.76.74.189:8000/newsfetch/?offset=10&plat=world";
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.创建请求对象
    //请求对象内部默认已经包含了请求头和请求方法（GET）
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            //6.解析服务器返回的数据
            //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            NSMutableArray *dataArr = [dict valueForKey:@"data"];
            NSLog(@"%@",dataArr);
            
            if (type==0) {
                
               
//            // 获取文件路径
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            dataArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//         

            
                
                [_dataMDic setObject:dataArr forKey:@(0)];
            } else if (type == 1) {
                [_dataMDic setObject:dataArr forKey:@(1)];
            } else if (type == 2) {
                [_dataMDic setObject:dataArr forKey:@(2)];
            } else if (type == 3) {
                [_dataMDic setObject:dataArr forKey:@(3)];
            }
            
            
          
            
        
            // 3.GCD
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [_tableView refreshWithData:dataArr];
            });

            
        }
    }];
    
    //5.执行任务
    [dataTask resume];
}

- (void)pushNewsDetailViewController:(NSNotification *) notification {
    self.hidesBottomBarWhenPushed=YES;
    NSDictionary * infoDic = [notification object];
    NSString *url = [infoDic objectForKey:@"url"];
    newsDetailViewController *vc = [[newsDetailViewController alloc]init];
    vc.urlStr = url;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (void) delayMethod{
    static int num = 0;
    num++;
    
    NSString *path;
    
    if (num == 2) {
        
        path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"json"];
    } else {
        
        path = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"json"];
    }
    
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    
    
    
    
    [_dataDic removeObjectForKey:@(0)];
    [_dataMDic setObject:arr forKey:@(0)];
    
    // UI更新代码
    [_tableView refreshWithData:arr];
}
- (void)requestNewData{
    

   //[self  performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"waiting......";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // Do something...
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    [hud hide:YES afterDelay:1.0];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    
}


- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}

#pragma mark - Header & Bar




- (CustomSegmentControl * )segmentBar {
    if (nil == _segmentBar) {
        self.segmentBar = [[CustomSegmentControl alloc]initWithItems:@[@"综合",@"人民网新闻",@"今日头条",@"环球网",@"谷歌新闻",@"腾讯新闻"]];
        _segmentBar.st_size = CGSizeMake(80 * 6, 40);
        _segmentBar.font = [UIFont systemFontOfSize:14];
        _segmentBar.textColor = RGBColor(100, 100, 100);
        _segmentBar.selectedTextColor = RGBColor(249, 104, 92);
        _segmentBar.backgroundColor = RGBColor(249, 251, 198);
        _segmentBar.selectionIndicatorColor = RGBColor(249, 251, 198);
        _segmentBar.selectedSegmentIndex = _swipeTableView.currentItemIndex;
        [_segmentBar addTarget:self action:@selector(changeSwipeViewIndex:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentBar;
}

#pragma mark -

- (void)tapHeader:(UITapGestureRecognizer *)tap {
    STImageController * imageVC = [[STImageController alloc]init];
    imageVC.transitioningDelegate = self;
    [self presentViewController:imageVC animated:YES completion:nil];
}


- (void)setSwipeTableHeader:(UIBarButtonItem *)barItem {
 
    
}

- (void)setSwipeTableBar:(UIBarButtonItem *)barItem {
    self.hidesBottomBarWhenPushed=YES;
    newsDetailViewController *vc = [[newsDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}



- (void)changeSwipeViewIndex:(UISegmentedControl *)seg {
    [_swipeTableView scrollToItemAtIndex:seg.selectedSegmentIndex animated:NO];
    // request data at current index
    [self getDataAtIndex:seg.selectedSegmentIndex];
}

#pragma mark - Data Reuqest

// 请求数据（根据视图滚动到相应的index后再请求数据）
- (void)getDataAtIndex:(NSInteger)index {
    [self sendRequest:(int)index];
}

// 请求数据（一次性获取所有item的数据）
- (void)getAllData {

        [_dataDic setObject:@(18) forKey:@(0)];
        [_dataDic setObject:@(10) forKey:@(1)];
        [_dataDic setObject:@(15) forKey:@(2)];
        [_dataDic setObject:@(12) forKey:@(3)];

        [_dataDic setObject:@(10) forKey:@(4)];
        [_dataDic setObject:@(12) forKey:@(5)];

}


#pragma mark - SwipeTableView M

- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return [_dataDic count];
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    
    CustomTableView * tableView = (CustomTableView *)view;
    // 重用
    if (nil == tableView) {
        tableView = [[CustomTableView alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
    }
    
    // 获取当前index下item的数据，进行数据刷新
    if (index == 0) {
//        NSArray *dataArr = [_dataMDic objectForKey:@(0)];
//        [_tableView refreshWithData:dataArr];
        
    } else if (index == 1) {
        NSArray *dataArr = [_dataMDic objectForKey:@(1)];
        [_tableView refreshWithData:dataArr];
        
    } else if (index == 2) {
        NSArray *dataArr = [_dataMDic objectForKey:@(2)];
        [_tableView refreshWithData:dataArr];
        
    } else {
        id data = _dataDic[@(index)];
        [tableView refreshWithData:data atIndex:index];
    }
    view = tableView;
    _tableView = tableView;
    // 在没有设定下拉刷新宏的条件下，自定义的下拉刷新需要做 refreshheader 的 frame 处理
    [self configRefreshHeaderForItem:view];
    
    return view;
}

// swipetableView index变化，改变seg的index
- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _segmentBar.selectedSegmentIndex = swipeView.currentItemIndex;
}

// 滚动结束请求数据
- (void)swipeTableViewDidEndDecelerating:(SwipeTableView *)swipeView {
    [self getDataAtIndex:swipeView.currentItemIndex];
}

/**
 *  以下两个代理，在未定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT，并自定义下拉刷新的时候，必须实现
 *  如果设置了下拉刷新的宏，以下代理可根据需要实现即可
 */
- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
}

- (CGFloat)swipeTableView:(SwipeTableView *)swipeTableView heightForRefreshHeaderAtIndex:(NSInteger)index {
    return kSTRefreshHeaderHeight;
}

/**
 *  采用自定义修改下拉刷新，此时不会定义宏 #define ST_PULLTOREFRESH_HEADER_HEIGHT
 *  对于一些下拉刷新控件，可能会在`layouSubViews`中设置RefreshHeader的frame。所以，需要在itemView有效的方法中改变RefreshHeader的frame，如 `scrollViewDidScroll:`
 */
- (void)configRefreshHeaderForItem:(UIScrollView *)itemView {
    if (_type == STControllerTypeDisableBarScroll) {
        itemView.header = nil;
        return;
    }
#if !defined(ST_PULLTOREFRESH_HEADER_HEIGHT)
    STRefreshHeader * header = itemView.header;
    header.st_y = - (header.st_height + (_segmentBar.st_height + _headerImageView.st_height));
#endif
}



#pragma  mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return [[STTransitions alloc]initWithTransitionDuration:0.55f fromView:self.headerImageView isPresenting:YES];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[STTransitions alloc]initWithTransitionDuration:0.5f fromView:self.headerImageView isPresenting:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:_type == STControllerTypeHiddenNavBar animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    __weak typeof(self) weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
