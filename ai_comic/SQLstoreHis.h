//
//  SQLstoreHis.h
//  ai_comic
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLstoreHis : NSObject
+(sqlite3*)openDB;
+(void)closeDB;
#pragma -mark 查找书籍
+(NSMutableArray*)findBook;
#pragma -mark 添加书籍
+(BOOL)addbigbookid:(int)bigbookid Bigbookname:(NSString*)bigbook_name Bookid:(int)bookid Partid:(int)partid Name:(NSString*)name Updatemassage:(NSString*)updatemessage  AndPartnumber:(int)partnumber;
#pragma -mark 删除书籍
+(BOOL)deleteBookByBigbookid:(int)bigbookid;
#pragma -mark 删除全部书籍
+(BOOL)deleteAllBooks;
@end
