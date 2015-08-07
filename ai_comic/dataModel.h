//
//  dataModel.h
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataModel : NSObject
@property(nonatomic)int bigbookid;
@property(nonatomic)int  book_id;
@property(nonatomic)int part_id;
@property(nonatomic,retain)NSString *bigbook_name;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *updatemessage;
@property(nonatomic,retain)NSString *converurl;
@property (nonatomic)int partnumber;
@end
