//
//  detailViewController.m
//  OCRRecognition1
//
//  Created by fred on 2018/4/17.
//  Copyright © 2018年 fred. All rights reserved.
//

#import "detailViewController.h"
#import <Masonry.h>

@interface detailViewController ()



@end

@implementation detailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    

    NSData *data = [_imgDic objectForKey:@"data"];
    UIImage *image = [UIImage imageWithData:data];
    NSString *number = [_imgDic objectForKey:@"name"];
    NSString *numberID = [_imgDic objectForKey:@"id"];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(77);
        make.width.equalTo(self.view.mas_width).offset(-70);
        make.height.mas_equalTo(imageView.mas_width).offset(-100);
    }];
    CALayer * layer = [imageView layer];
    layer.borderColor = [[UIColor redColor] CGColor];
    layer.borderWidth = 1.0f;
    
    //label
    UILabel *restltText = [[UILabel alloc]init];
    restltText.text=number;
    restltText.textColor = [UIColor redColor];
    restltText.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:restltText];
    [restltText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(50);
        //        make.width.equalTo(openPhotoButton);
//        make.height.equalTo(openPhotoButton);
    }];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
