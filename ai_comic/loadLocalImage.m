//
//  loadLocalImage.m
//  UI_Test_李少佳
//
//  Created by lanou on 15/6/14.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "loadLocalImage.h"

@implementation loadLocalImage

+(UIImage*)loadLocalImage:(NSString*)string
{
    //从沙盒中获取图片
    NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *fileName = [libPath stringByAppendingPathComponent:string];
    NSData *imageData = [NSData dataWithContentsOfFile:fileName];
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
