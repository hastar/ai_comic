//
//  DataRequest.h
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  void (^result) (NSMutableArray *);
@interface DataRequest : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic,retain) NSMutableArray *dataHandleArray;
+(void)cancelAll;
+(instancetype)shareDataRequest;
+ (void)searchComicWithName:(NSString *)name AndPageIndex:(NSNumber *)pindex ToResult:(result)result;
+ (void)getComicSubjectsToResult:(result)result;
+ (void)getComicSubjects:(NSNumber *)subject WithPageNo:(NSNumber *)pageno ToResult:(result)result;
+ (void)getComicDetailWithBigBookID:(NSNumber *)bigbookid ToResult:(result)result;
+ (void)getComicSectionsWithBookID:(NSNumber *)bookid ToResult:(result)result;
+ (void)getComicPagesWithBookID:(NSNumber *)bookid AndPartID:(NSNumber *)partid ToResult:(result)result;
+ (void)recommendInterfaceWithPageno:(NSNumber*)pageno ToResult:(result)result;
+ (void)boardListInterfaceWithResult:(result)result;
+ (void)specialBoardInterfaceWithPageno:(NSNumber*)pageno AndID:(NSNumber*)ID ToResult:(result)result;
+ (void)getRecommenScrollDataToResult:(result)result;

@end
