//
//  specialBoardModel.m
//  Tools
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "specialBoardModel.h"

@implementation specialBoardModel

- (void)dealloc
{
    [_bigbook_name release];
    [_bigbook_author release];
    [_bigbookview release];
    [_bigbook_id release];
    [_progresstype release];
    [_coverurl release];
    [_key_name release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
