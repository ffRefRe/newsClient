//
//  ViewController.m
//  OCRRecognition1
//
//  Created by fred on 2018/2/8.
//  Copyright © 2018年 fred. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import <MBProgressHUD.h>
#import "historyTableViewController.h"
#import "FMDatabase.h"



@interface ViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *restltText;

@property (nonatomic,retain) MBProgressHUD *HUD;

@property (nonnull, strong) FMDatabase * database;

@end

@implementation ViewController {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

#pragma mark - UI

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.operationQueue = [[NSOperationQueue alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[AipOcrService shardService] authWithAK:@"5cGH6o3UECUZPzFxarKmbK1T" andSK:@"z9n3dfFEPD47UueDe9HQ6Rcn7F3tmbjb"];
    [self configCallback];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    
    // 第１行信息的追加
//    self.navigationItem.prompt = @"第１行信息";
    // 设置标题
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1];
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    title.text=@"新闻";
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont boldSystemFontOfSize:18];
    title.textAlignment= NSTextAlignmentCenter;
    self.navigationItem.titleView=title;
    
 
    
    
    //导航栏 右按钮
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame=CGRectMake(0, 0, 45, 20);
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    rightBtn.contentMode=UIViewContentModeCenter;
    rightBtn.layer.cornerRadius=2;
    rightBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    [rightBtn setTitle:@" 历史记录 " forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:0 green:178.0/255 blue:201.0/255 alpha:1] forState:UIControlStateNormal];
    rightBtn.backgroundColor=[UIColor colorWithRed:163.0/255 green:250.0/255 blue:1 alpha:1];
    [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    

    //边框
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
    
    
//    UIWebView *wb = [[UIWebView alloc]init];
//    [self.view addSubview:wb];
//    [wb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view.mas_centerX);
//        make.top.equalTo(self.view).offset(77);
//        make.width.equalTo(self.view.mas_width).offset(-70);
//        make.height.mas_equalTo(wb.mas_width).offset(300);
//    }];
//    CALayer * layer = [wb layer];
//    layer.borderColor = [[UIColor redColor] CGColor];
//    layer.borderWidth = 1.0f;
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = webView;
    NSURL *url = [NSURL URLWithString:@"http://env.people.com.cn/n1/2018/1024/c1010-30360787.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

    
    

    
    UIImage *image = [UIImage imageNamed:@"coin.jpg"];
    
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    
    if ([self.database open]) {
        NSString *rText1 = @"11";
        BOOL flag = [self.database executeUpdate:@"insert into hisOfFMDB (name,img) values(?,?)",rText1,data];
        
        if (flag) {
            NSLog(@"插入成功");
        }else{
            NSLog(@"插入失败");
        }
        [self.database close];
    }
    
    
    

}

#pragma mark - history
- (void)rightBarButtonClick{
    historyTableViewController *vC = [[historyTableViewController alloc]init];
    vC.hidesBottomBarWhenPushed=YES; 
    [self.navigationController pushViewController:vC animated:true];
    
}

#pragma mark - open the photoAlbum
- (void)openPhoto{
//    [self test];

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];

    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //加载图片
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filePath];
        _imageView.image = savedImage;
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    
}

#pragma mark - open the camera

- (void)openCamera{
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        _imageView.image = image;
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - remoteOCR

- (void)remoteOCR{
    [self beginHUDAction];
    _restltText.text=@"  识别结果:";
    
    UIImage *img = [UIImage imageNamed:@"coin.jpg"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
    [[AipOcrService shardService] detectTextBasicFromImage:savedImage
                                               withOptions:options
                                            successHandler:_successHandler
                                               failHandler:_failHandler];
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        __weak __typeof(self) weakself= self;
        dispatch_async(dispatch_queue_create(0, 0), ^{
            // 子线程执行任务（比如获取较大数据）
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知主线程刷新 神马的
                 [_HUD hideAnimated:YES afterDelay:0.0];
            });
        });
        
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        
                        
                        
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                        
                        //正则判断
                        NSString *upperWords = obj[@"words"];
                        NSString *words = [upperWords uppercaseString];    //大写
                        
                        NSRange range = [words rangeOfString:@"[A-Z]{2}\\d{8}" options:NSRegularExpressionSearch];
                        if (range.location != NSNotFound) {
                            NSLog(@"%@", [words substringWithRange:range]);
                            NSString *resultText = [words substringWithRange:range];
                            NSString *rText = [[NSString alloc]initWithFormat:@"  识别结果: %@",resultText];
                            [_restltText performSelectorOnMainThread:@selector(setText:)                                        withObject:rText
                                waitUntilDone:YES];
                            
                            
                            UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filePath];
                            
                            
                            //插入数据库
                            NSData *data;
                            if (UIImagePNGRepresentation(savedImage) == nil)
                            {
                                data = UIImageJPEGRepresentation(savedImage, 1.0);
                            }
                            else
                            {
                                data = UIImagePNGRepresentation(savedImage);
                            }
                            
                            if ([self.database open]) {
                                
                                NSDate * date = [NSDate date];
                                NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
                                [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
                                NSString * dateStr = [formatter stringFromDate:date];
                                
                                
                                BOOL flag = [self.database executeUpdate:@"insert into hisOfFMDB (name,time,img) values(?,?,?)",resultText,dateStr,data];
                                
                                if (flag) {
                                    NSLog(@"插入成功");
                                }else{
                                    NSLog(@"插入失败");
                                }
                                [self.database close];
                            }
                            
                        }
   
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    };
    
    _failHandler = ^(NSError *error){
        __weak __typeof(self) weakself= self;
        dispatch_async(dispatch_queue_create(0, 0), ^{
            // 子线程执行任务（比如获取较大数据）
            dispatch_async(dispatch_get_main_queue(), ^{
                // 通知主线程刷新 神马的
                [_HUD hideAnimated:YES afterDelay:0.0];
            });
        });
    
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}



#pragma mark - local OCR
- (void)buttonClick{
    [self recognizeImageWithTesseract:[UIImage imageNamed:@"letter.jpg"]];
}

- (void)localOCR{
    [self beginHUDAction];

    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    [self recognizeImageWithTesseract:savedImage];
//    _imageView.image = [UIImage imageNamed:@"coin.jpg"];;
//    [self recognizeImageWithTesseract:[UIImage imageNamed:@"letter.jpg"]];
}

-(void)recognizeImageWithTesseract:(UIImage *)image
{
    // Preprocess the image so Tesseract's recognition will be more accurate
    UIImage *bwImage = [image g8_blackAndWhite];
    
    
    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];
    
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    operation.tesseract.language = @"eng";
    
    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    
    //    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    //    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeSparseText;
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    //operation.tesseract.maximumRecognitionTime = 1.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    
    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        
        NSLog(@"%@", recognizedText);
        
        [_HUD hideAnimated:YES afterDelay:0.0];
        
        // Spawn an alert with the recognized text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
                                                        message:recognizedText
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    };
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}


#pragma mark - 通常情况  文字  加 菊花
- (void)beginHUDAction{

    self.HUD = [[MBProgressHUD alloc] initWithView:self.view ];
    //修改样式，否则等待框背景色将为半透明
    _HUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置等待框背景色为黑色
//    hud.bezelView.backgroundColor = [UIColor blackColor];
    _HUD.removeFromSuperViewOnHide = YES;
    _HUD.label.text = @"正在识别...";
    //设置菊花框为白色
//    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    [self.view addSubview:_HUD];
    [_HUD showAnimated:YES];
    
    // 隐藏时候从父控件中移除
    _HUD.removeFromSuperViewOnHide = YES;
    
    //1秒之后再消失
//    [_HUD hideAnimated:YES afterDelay:1.0];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
