//
//  DateHandle.h
//  ai_comic
//
//  Created by lanou on 15/7/7.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^DataBlock) (NSMutableData *data);
@interface DataHandle : NSObject<NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, copy) DataBlock datablock;
@property (nonatomic, retain) NSMutableData *receiveData;

- (void)sendAsynDelegateRequest:(NSURLRequest *)request WithData:(DataBlock)data;
@end
