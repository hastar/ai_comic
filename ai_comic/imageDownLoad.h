//
//  imageDownLoad.h
//  Lesson_UI_17_网络封装
//
//  Created by lanou on 15/6/4.
//  Copyright (c) 2015年 Rocky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//创建一个block用来传值使用
//block使用参数来传值
typedef void (^results)(UIImage*img);
@interface imageDownLoad : NSObject

//声明一个接口
/*
 参数一：用来传递请求的url
 参数而：用来传递需要传值的block
 */
+(void)imageDownWithUrlString:(NSString*)urlString andResult:(results)result;



@end
