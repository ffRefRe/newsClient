//
//  KBTabbarController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBTabbarController.h"
#import "ViewController.h"
#import "settingViewController.h"
#import "KBTabbar.h"
#import "STViewController.h"

@interface KBTabbarController ()

@end

@implementation KBTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

//    ViewController *root = [[ViewController alloc]init];
//    newsTableViewController *root = [[newsTableViewController alloc]init];
//    tViewController *root = [[tViewController alloc]init];
    STViewController *root = [[STViewController alloc]init];
    root.type = 0;

    [self addChildController:root title:@"首页" imageName:@"tab1-heart" selectedImageName:@"tab1-heartshow" navVc:[UINavigationController class]];
    

    settingViewController *svc = [[settingViewController alloc]init];
//    selfTableViewController *svc = [[selfTableViewController alloc]init];
    [self addChildController:svc title:@"设置" imageName:@"tab5-fileshow" selectedImageName:@"tab5-file" navVc:[UINavigationController class]];
    
    
    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 设置自定义的tabbar
    [self setCustomtabbar];
    
    
    
}

- (void)setCustomtabbar{

    KBTabbar *tabbar = [[KBTabbar alloc]init];
    
    [self setValue:tabbar forKeyPath:@"tabBar"];

    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];


}

- (void)centerBtnClick:(UIButton *)btn{

    NSNotification *notification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(Class)navVc
{
    
    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }forState:UIControlStateSelected];
 
    UINavigationController* nav = [[navVc alloc] initWithRootViewController:childController];
    
    [self addChildViewController:nav];
}


- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
