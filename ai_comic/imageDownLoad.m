//
//  imageDownLoad.m
//  Lesson_UI_17_网络封装
//
//  Created by lanou on 15/6/4.
//  Copyright (c) 2015年 Rocky. All rights reserved.
//

#import "imageDownLoad.h"

@implementation imageDownLoad
+(void)imageDownWithUrlString:(NSString*)urlString andResult:(results)result
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //将请求回来的data数据转化为图片UIImage类型,并且传递出去
        UIImage *image = [UIImage imageWithData:data];
        //通过block的形式将数据传递出去
        result(image);
    }];
}

@end
