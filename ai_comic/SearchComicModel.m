//
//  SearchComicModel.m
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "SearchComicModel.h"

@implementation SearchComicModel
-(void)dealloc
{
    [_author release];
    [_bigbookview release];
    [_coverurl release];
    [_gradescore release];
    [_ID release];
    [_name release];
    [_progresstype release];
    [_subject_name release];
    [_updatedate release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

@end
