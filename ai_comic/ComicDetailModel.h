//
//  ComicDetailModel.h
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ComicDetailModel : NSObject
@property (nonatomic, retain)NSString *bigbook_author;
@property (nonatomic, retain)NSString *bigbook_name;
@property (nonatomic, retain)NSString *bigbook_brief;
@property (nonatomic, retain)NSString *gradescore;
@property (nonatomic, retain)NSString *subject_name;
@property (nonatomic, retain)NSString *coverurl;
@property (nonatomic, retain)NSNumber *adgroupid;
@property (nonatomic, retain)NSNumber *bigbookview;

@property (nonatomic, retain)NSNumber *book_id;
@property (nonatomic, retain)NSString *source_name;
@property (nonatomic, retain)NSString *totalpart;
@property (nonatomic, retain)NSString *updatedate;
@property (nonatomic, retain)NSString *updatemessage;
@property (nonatomic, retain)NSNumber *progresstype;


@property (nonatomic,retain)NSNumber *currentPartid;


@end
