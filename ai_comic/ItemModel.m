//
//  ItemModel.m
//  test
//
//  Created by 侯垒 on 15/5/19.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

-(void)dealloc
{
    [_bigbook_id release];
    [_bigbook_name release];
    [_coverurl release];
    [_lastpartname release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.bigbook_id= dict[@"bigbook_id"];
        self.bigbook_name = dict[@"bigbook_name"];
        self.coverurl  =dict[@"coverurl"];
        self.lastpartname = dict[@"lastpartname"];
        self.cover_height = [dict[@"cover_height"] floatValue];
        self.cover_width = [dict[@"cover_width"] floatValue];
    }
    return self;
}

+ (id)itemWithDictionary:(NSDictionary *)dict{
    return [[[self class] alloc] initWithDictionary:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
