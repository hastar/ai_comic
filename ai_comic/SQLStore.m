//
//  SQLStore.m
//  UI_Test_李少佳
//
//  Created by lanou on 15/6/15.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "SQLStore.h"
#import "dataModel.h"

static sqlite3 *db = nil;
@implementation SQLStore
+(sqlite3*)openDB
{
    
    if (db) {
        return db;
    }
    //打开数据库
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"DATA.sqlite"];
    int state = sqlite3_open([filePath UTF8String], &db);
    if (state != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    NSLog(@"coolectionDataFilepath = %@",filePath);
    
    NSString *createTableStr = @"create table if not exists classA(bigbookid integer primary key,bigbook_name text,book_id integer,part_id integer,name text,updatemessage text,partnumber integer)";
    char *errmsg;
    int result = sqlite3_exec(db, [createTableStr UTF8String], NULL, NULL, &errmsg);
    if (result)
    {
        sqlite3_close(db);
        sqlite3_free(errmsg);
    }
    return db;
}
+(void)closeDB
{
    if (db) {
        sqlite3_close(db);
    }
}
#pragma -mark 查找指定的消息
+(NSMutableArray*)findBook;
{
    
    sqlite3 *db=[SQLStore openDB];
    sqlite3_stmt *stmt=nil;
    int state=sqlite3_prepare_v2(db, "select * from classA ", -1, &stmt, nil);
    if (state==SQLITE_OK) {
        NSMutableArray *modelArr= [[NSMutableArray alloc] initWithCapacity:10];
        while(sqlite3_step(stmt)==SQLITE_ROW)
        {
            dataModel *model = [[dataModel alloc] init];
            //如果想要搜索主键，就要从0开始搜索
            int bigbookid = sqlite3_column_int(stmt, 0);
            const unsigned char *bigbook_name = sqlite3_column_text(stmt, 1);
             int book_id = sqlite3_column_int(stmt, 2);
             int part_id = sqlite3_column_int(stmt, 3);
            const unsigned char *name = sqlite3_column_text(stmt, 4);
            const unsigned char *updatemessage = sqlite3_column_text(stmt, 5);
            int partnumber = sqlite3_column_int(stmt, 6);

            model.bigbookid = bigbookid;
            model.bigbook_name = [NSString stringWithUTF8String:(char*)bigbook_name];
            model.book_id = book_id;
            model.part_id = part_id;
            model.name = [NSString stringWithUTF8String:(char*)name];
            model.updatemessage = [NSString stringWithUTF8String:(char*)updatemessage];
            model.partnumber = partnumber;
            [modelArr addObject:model];
            [model release];
        }
        return [modelArr autorelease];
    }
    return nil;

}
#pragma -mark 添加一个活动
+(BOOL)addbigbookid:(int)bigbookid Bigbookname:(NSString*)bigbook_name Bookid:(int)bookid Partid:(int)partid Name:(NSString*)name Updatemassage:(NSString*)updatemessage Coverurl:(NSString *)coverurl AndPartnumber:(int)partnumber;
{
    sqlite3 *db = [SQLStore openDB];
    sqlite3_stmt *stmt = nil;
    int state = sqlite3_prepare_v2(db,"insert or replace into classA(bigbookid,bigbook_name,book_id,part_id,name,updatemessage,partnumber)values(?,?,?,?,?,?,?)", -1, &stmt, nil);
    if (state == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, bigbookid);
        sqlite3_bind_text(stmt,2, [bigbook_name UTF8String], -1, nil);
         sqlite3_bind_int(stmt, 3, bookid);
        sqlite3_bind_int(stmt,4,partid);
        sqlite3_bind_text(stmt, 5, [name UTF8String], -1, nil);
        sqlite3_bind_text(stmt, 6, [updatemessage UTF8String], -1, nil);
          sqlite3_bind_int(stmt, 7, partnumber);
        int result = sqlite3_step(stmt);
        if (result == SQLITE_DONE)
        {
            NSLog(@"数据添加成功");
            return YES;
        }
    }
    return NO;
}

#pragma -mark 删除书籍
+(BOOL)deleteBookByBigbookid:(int)bigbookid
{

    sqlite3 *db = [SQLStore openDB];
    sqlite3_stmt *stmt = nil;
    int state = sqlite3_prepare_v2(db, "delete from classA where bigbookid = ?", -1, &stmt, nil);
    if (state == SQLITE_OK) {
        sqlite3_bind_int(stmt, 1, bigbookid);
        int result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"数据删除成功");
            return YES;
        }
    }
    return NO;
}

#pragma -mark删除全部书籍
+(BOOL)deleteAllBooks
{
    sqlite3 *db = [SQLStore openDB];
    sqlite3_stmt *stmt = nil;
    int state = sqlite3_prepare_v2(db, "delete from classA ", -1, &stmt, nil);
    if (state == SQLITE_OK) {
        int result = sqlite3_step(stmt);
        if (result == SQLITE_DONE) {
            NSLog(@"数据删除成功");
            return YES;
        }
    }
    return NO;
    
}

@end
