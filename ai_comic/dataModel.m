//
//  dataModel.m
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel
-(void)dealloc
{
    [_bigbook_name release];
    [_name release];
    [_updatemessage release];
    [_converurl release];
    [super dealloc];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
