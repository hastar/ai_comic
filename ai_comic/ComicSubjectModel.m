//
//  ComicSubjectModel.m
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSubjectModel.h"

@implementation ComicSubjectModel
-(void)dealloc
{
    [_name release];
    [_updatetime release];
    [_cover2url release];
    [_cover3url release];
    [_position release];
    [_subjectid release];
    [super dealloc];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
