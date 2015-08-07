//
//  ComicDetailModel.m
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicDetailModel.h"

@implementation ComicDetailModel
-(void)dealloc
{
    [_bigbook_author release];
    [_bigbook_name release];
    [_bigbook_brief release];
    [_gradescore release];
    [_subject_name release];
    [_coverurl release];
    [_adgroupid release];
    [_bigbookview release];
    [_book_id release];
    [_source_name release];
    [_totalpart release];
    [_updatedate release];
    [_updatemessage release];
    [_progresstype release];
    [_currentPartid release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
