//
//  SearchComicModel.h
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchComicModel : NSObject

@property (nonatomic, retain)NSString *author;
@property (nonatomic, retain)NSString *bigbookview;
@property (nonatomic, retain)NSString *gradescore;
@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *coverurl;
@property (nonatomic, retain)NSNumber *ID;

@property (nonatomic, retain)NSString *subject_name;
@property (nonatomic, retain)NSString *updatedate;
@property (nonatomic, retain)NSNumber *progresstype;

@end
