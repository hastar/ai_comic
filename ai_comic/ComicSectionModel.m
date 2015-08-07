//
//  ComicSectionModel.m
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSectionModel.h"

@implementation ComicSectionModel

-(void)dealloc
{
    [_name release];
    [_partsize release];
    [_part_id release];
    [_partnumber release];
    [_totalpage release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
