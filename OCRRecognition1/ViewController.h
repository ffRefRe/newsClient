//
//  ViewController.h
//  OCRRecognition1
//
//  Created by fred on 2018/2/8.
//  Copyright © 2018年 fred. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TesseractOCRMethod/TesseractOCR.h"

@interface ViewController : UIViewController <G8TesseractDelegate,
                                              UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>
{
    //图片2进制路径
    NSString* filePath;
    
    
    
}


@end

