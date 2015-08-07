//
//  ScorllModel.m
//  ai_comic
//
//  Created by lanou on 15/7/4.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ScorllModel.h"

@implementation ScorllModel

- (void)dealloc
{
    [_imageurl release];
    [_title release];
    [_name release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
