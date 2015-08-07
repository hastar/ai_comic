//
//  boardListModel.m
//  Tools
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "boardListModel.h"

@implementation boardListModel

- (void)dealloc
{
    [_specialid release];
    [_coverurl release];
    [_descriptions release];
    [_name release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"description"]) {
        self.descriptions = value;
    }
}


@end
