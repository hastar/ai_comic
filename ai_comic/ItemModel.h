//
//  ItemModel.h
//  test
//
//  Created by 侯垒 on 15/5/19.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemModel : NSObject
@property(nonatomic,retain)NSNumber *bigbook_id;
@property(nonatomic,retain)NSString *bigbook_name;
@property(nonatomic,assign)float cover_height;
@property(nonatomic,assign)float cover_width;
@property(nonatomic,retain)NSString *coverurl;
@property(nonatomic,retain)NSString *lastpartname;


- (id)initWithDictionary:(NSDictionary *)dict;
+ (id)itemWithDictionary:(NSDictionary *)dict;

@end
