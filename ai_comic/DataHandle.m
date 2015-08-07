//
//  DateHandle.m
//  ai_comic
//
//  Created by lanou on 15/7/7.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "DataHandle.h"
#import "DataRequest.h"
#import <UIKit/UIKit.h>
@implementation DataHandle
- (void)dealloc
{
    NSLog(@"++++++++++++++++++++++++++++++Handle");
    [_connection cancel];
    [_connection release];
    _connection = nil;
    [_receiveData release];
    _receiveData = nil;
    _datablock = NULL;
    Block_release(_datablock);
    [super dealloc];
}

- (void)sendAsynDelegateRequest:(NSURLRequest *)request WithData:(DataBlock)data
{
    self.connection = [[[NSURLConnection alloc]initWithRequest:request delegate:self]autorelease];
    self.datablock = data;
    [self.connection start];
}

//异步请求类的协议方法实现
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [[NSMutableData alloc]init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading: = %ld",[[DataRequest shareDataRequest]dataHandleArray].count);
    if (self.datablock!=NULL&&[[DataRequest shareDataRequest]dataHandleArray].count != 0) {
        self.datablock(_receiveData);
        [_receiveData release];
//        [_connection release];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error) {
        [_receiveData release];
        [[[DataRequest shareDataRequest] dataHandleArray] removeObject:self];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"数据请求失败，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        UIWindow * window = [UIApplication sharedApplication].keyWindow ;
        [window addSubview:alert];
        [alert show];
        [alert release];
    }
}



@end
