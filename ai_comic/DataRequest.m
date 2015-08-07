//
//  DataRequest.m
//  ai_comic
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "DataRequest.h"
#import "SearchComicModel.h"
#import "ComicSubjectModel.h"
#import "ComicDetailModel.h"
#import "ComicSectionModel.h"
#import "recommendModel.h"
#import "boardListModel.h"
#import "specialBoardModel.h"
#import "ItemModel.h"
#import "ScorllModel.h"
#import "DataHandle.h"

#define kSearchComicURL @"http://mhjk.1391.com/comic/searchbookauthor?pindex=0&version=2&psize=10&name=?&type=2&channelid=appstore"
#define kComicSubjectsURL @"http://mhjk.1391.com/comic/recommendsubject?&channelid=appstore"
#define kComicDetailURL @"http://mhjk.1391.com/comic/comicsdetail_v2?&bigbookid=?&channelid=appstore"
#define kComicIDURL @"http://mhjk.1391.com/comic/bigbooksource_v3?&bigbookid=?&channelid=appstore"
#define kComicSectionURL @"http://mhjk.1391.com/comic/downloadcomicsview_v3?bookid=?&channelid=baidu"
#define kComicPagesURL @"http://mhjk.1391.com/comic/comicsread_v3?bookid=?&partid=?&partVersion=1&channelid=appstore"
#define recommendURL @"http://mhjk.1391.com/comic/comicslist_v2_sb?"
#define boardListURL @"http://mhjk.1391.com/comic/recommendspecial_sb?&retype=1&cchannelid=appstore"
#define specialBoardURL @"http://mhjk.1391.com/comic/comicslist_v2?"
#define recScorllURL @"http://mhjk.1391.com/comic/getproad?adgroupid=6&channelid=appstore"
@interface DataRequest()

@end




@implementation DataRequest

static DataRequest *dataRe= nil;
+(instancetype)shareDataRequest
{
    if (dataRe == nil) {
        dataRe = [[DataRequest alloc] init];
    }
    return dataRe;
}

- (NSMutableArray *)dataHandleArray
{

    if (_dataHandleArray == nil) {
            _dataHandleArray = [[NSMutableArray alloc]init];
    }
    return [[_dataHandleArray retain]autorelease];
}

+(void)cancelAll
{
//    NSLog(@"'...................................................%ld",[[self shareDataRequest] dataHandleArray].count);
    [[[self shareDataRequest] dataHandleArray] removeAllObjects];
}
+ (void)searchComicWithName:(NSString *)name AndPageIndex:(NSNumber *)pindex ToResult:(result)result
{
    NSString *nameStr = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [kSearchComicURL stringByReplacingOccurrencesOfString:@"name=?" withString:[NSString stringWithFormat:@"name=%@",nameStr]];
    if (pindex.intValue != 0) {
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"pindex=0" withString:[NSString stringWithFormat:@"pindex=%@",pindex]];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
            NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *secDic = firDic[@"info"];
            NSDictionary *thirdDic = secDic[@"data"];
            NSArray *array = thirdDic[@"items"];
            NSMutableArray *SCArray = [[NSMutableArray alloc]init];
            NSLog(@"%@", array);
            for (NSDictionary *fourDic in array) {
                SearchComicModel *SCM = [[SearchComicModel alloc]init];
                [SCM setValuesForKeysWithDictionary:fourDic];
                [SCArray addObject:SCM];
                [SCM release];
                //NSLog(@"%@", fourDic);
        }
        if (result)
            result(SCArray);
        [SCArray release];
    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        if (connectionError == nil) {
//            NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *secDic = firDic[@"info"];
//            NSDictionary *thirdDic = secDic[@"data"];
//            NSArray *array = thirdDic[@"items"];
//            NSMutableArray *SCArray = [[NSMutableArray alloc]init];
//            for (NSDictionary *fourDic in array) {
//                SearchComicModel *SCM = [[SearchComicModel alloc]init];
//                [SCM setValuesForKeysWithDictionary:fourDic];
//                [SCArray addObject:SCM];
//                [SCM release];
//                //NSLog(@"%@", fourDic);
//            }
//            if (result)
//                result(SCArray);
//            [SCArray release];
//        }
//    }];
}

+ (void)getComicSubjectsToResult:(result)result
{
    NSURL *url = [NSURL URLWithString:kComicSubjectsURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secDic = firDic[@"info"];
        NSArray *array = secDic[@"subjects"];
        NSMutableArray *subjectsArray = [[NSMutableArray alloc]init];
        for (NSDictionary *thirdDic in array) {
            ComicSubjectModel *subject = [[ComicSubjectModel alloc]init];
            [subject setValuesForKeysWithDictionary:thirdDic];
            [subjectsArray addObject:subject];
            [subject release];
            //NSLog(@"%@", thirdDic);
        }
        if (result)
            result(subjectsArray);
        [subjectsArray release];
    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *secDic = firDic[@"info"];
//        NSArray *array = secDic[@"subjects"];
//        NSMutableArray *subjectsArray = [[NSMutableArray alloc]init];
//        for (NSDictionary *thirdDic in array) {
//            ComicSubjectModel *subject = [[ComicSubjectModel alloc]init];
//            [subject setValuesForKeysWithDictionary:thirdDic];
//            [subjectsArray addObject:subject];
//            [subject release];
//            //NSLog(@"%@", thirdDic);
//        }
//        if (result)
//             result(subjectsArray);
//        [subjectsArray release];
//    }];
}



+ (void)getComicSubjects:(NSNumber *)subject WithPageNo:(NSNumber *)pageno ToResult:(result)result
{
    NSURL *url = [NSURL URLWithString:specialBoardURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSDictionary *bodyDic = @{@"pageno":pageno.stringValue,@"pagesize":@"10",@"subject":subject.stringValue};
    NSData *data = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody: data];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *infoDic = [dic valueForKey:@"info"];
        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (NSDictionary *Dic in comicsList) {
            specialBoardModel *speModel = [[specialBoardModel alloc] init];
            [speModel setValuesForKeysWithDictionary:Dic];
            [modelArr addObject:speModel];
            [speModel release];
        }
        //通过block的形式将数据传递出去
        result(modelArr);
        [modelArr release];

    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *infoDic = [dic valueForKey:@"info"];
//        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
//        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
//        
//        for (NSDictionary *Dic in comicsList) {
//            specialBoardModel *speModel = [[specialBoardModel alloc] init];
//            [speModel setValuesForKeysWithDictionary:Dic];
//            [modelArr addObject:speModel];
//            [speModel release];
//        }
//        //通过block的形式将数据传递出去
//        result(modelArr);
//        [modelArr release];
//    }];

    
}

+ (void)getComicDetailWithBigBookID:(NSNumber *)bigbookid ToResult:(result)result
{
    NSString *urlStr = [kComicDetailURL stringByReplacingOccurrencesOfString:@"bigbookid=?" withString:[NSString stringWithFormat:@"bigbookid=%@",bigbookid.stringValue]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    NSLog(@"[[[self shareDataRequest] dataHandleArray] addObject:dataH] = %ld",[[self shareDataRequest] dataHandleArray] .count);
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secDic = firDic[@"info"];
        NSArray *array = secDic[@"comicsdetail"];
        NSMutableArray *detailArray = [[NSMutableArray alloc]init];
        for (NSDictionary *thirdDic in array) {
            ComicDetailModel *detail = [[ComicDetailModel alloc]init];
            [detail setValuesForKeysWithDictionary:thirdDic];
            //获取漫画ID并赋给 comicdetail
            NSString *urlStr2 = [kComicIDURL  stringByReplacingOccurrencesOfString:@"bigbookid=?" withString:[NSString stringWithFormat:@"bigbookid=%@",bigbookid.stringValue]];
            NSURL *url2 = [NSURL URLWithString:urlStr2];
            NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
            DataHandle *dataH2 =  [[DataHandle alloc]init];
            [[[self shareDataRequest] dataHandleArray] addObject:dataH2];
            NSLog(@"[[[self shareDataRequest] dataHandleArray] addObject:dataH] = %ld",[[self shareDataRequest] dataHandleArray] .count);
            [dataH2 release];
            [dataH2 sendAsynDelegateRequest:request2 WithData:^(NSMutableData *data) {
                if (data==nil) {
                    return ;
                }
                NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *secDic = firDic[@"info"];
                NSArray *array = secDic[@"comicssource"];
                NSDictionary *thirdDic = array[0];
                [detail setValuesForKeysWithDictionary:thirdDic];
                
                [detailArray addObject:detail];
                [detail release];
                if (result)
                    result(detailArray);
                [detailArray release];
                
            }];
        }
    }];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *secDic = firDic[@"info"];
//        NSArray *array = secDic[@"comicsdetail"];
//        NSMutableArray *detailArray = [[NSMutableArray alloc]init];
//        for (NSDictionary *thirdDic in array) {
//            ComicDetailModel *detail = [[ComicDetailModel alloc]init];
//            [detail setValuesForKeysWithDictionary:thirdDic];
//            //获取漫画ID并赋给 comicdetail
//            NSString *urlStr2 = [kComicIDURL  stringByReplacingOccurrencesOfString:@"bigbookid=?" withString:[NSString stringWithFormat:@"bigbookid=%@",bigbookid.stringValue]];
//            NSURL *url2 = [NSURL URLWithString:urlStr2];
//            NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
//            [NSURLConnection sendAsynchronousRequest:request2 queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                if (data==nil || connectionError!=nil) {
//                    return ;
//                }
//                NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                NSDictionary *secDic = firDic[@"info"];
//                NSArray *array = secDic[@"comicssource"];
//                NSDictionary *thirdDic = array[0];
//                [detail setValuesForKeysWithDictionary:thirdDic];
//                
//                [detailArray addObject:detail];
//                [detail release];
//                if (result)
//                    result(detailArray);
//                [detailArray release];
//                //NSLog(@"%@",thirdDic);
//            }];
//            //NSLog(@"%@", thirdDic);
//            
//        }
//        
//    }];
    
    
}



+ (void)getComicSectionsWithBookID:(NSNumber *)bookid ToResult:(result)result
{
    NSString *urlStr = [kComicSectionURL stringByReplacingOccurrencesOfString:@"bookid=?" withString:[NSString stringWithFormat:@"bookid=%@",bookid.stringValue]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secDic = firDic[@"info"];
        NSArray *array = secDic[@"bookPartList"];
        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *thirdDic in array) {
            ComicSectionModel *section = [[ComicSectionModel alloc]init];
            [section setValuesForKeysWithDictionary:thirdDic];
            [sectionArray addObject:section];
            [section release];
            //NSLog(@"%@", thirdDic);
        }
        if (result)
            result(sectionArray);
        [sectionArray release];
    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *secDic = firDic[@"info"];
//        NSArray *array = secDic[@"bookPartList"];
//        NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
//        for (NSDictionary *thirdDic in array) {
//            ComicSectionModel *section = [[ComicSectionModel alloc]init];
//            [section setValuesForKeysWithDictionary:thirdDic];
//            [sectionArray addObject:section];
//            [section release];
//            //NSLog(@"%@", thirdDic);
//        }
//        if (result)
//            result(sectionArray);
//        [sectionArray release];
//    }];
}

+ (void)getComicPagesWithBookID:(NSNumber *)bookid AndPartID:(NSNumber *)partid ToResult:(result)result
{
    NSString *urlStr = [kComicPagesURL stringByReplacingOccurrencesOfString:@"bookid=?" withString:[NSString stringWithFormat:@"bookid=%@",bookid.stringValue]];
    urlStr = [urlStr stringByReplacingOccurrencesOfString:@"partid=?" withString:[NSString stringWithFormat:@"partid=%@",partid.stringValue]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data == nil) {
            return ;
        }
        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSString *imageString = firDic[@"info"];
        NSData *data2 = [imageString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *pagesArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSUTF8StringEncoding error:nil];
        if (result)
            result(pagesArray);
    }];
}

+(void)recommendInterfaceWithPageno:(NSNumber*)pageno ToResult:(result)result;
{
    NSURL *url = [NSURL URLWithString:recommendURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    NSDictionary *bodyDic = @{@"type":@"1",@"pageno":[NSString stringWithFormat:@"%@",pageno],@"pagesize":@"10"};
    //[bodyDic setValue:[NSString stringWithFormat:@"%@",pageno] forKey:@"pageno"];
    //设置异步post请求的body体(body体即为上面的字典)
    NSData *data = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody: data];
    //发送异步请求
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        //将请求回来的data数据进行解析
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //检验数据
        //        NSLog(@"*********dic2 = %@",dic);
        
        NSDictionary *infoDic = [dic valueForKey:@"info"];
        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (NSDictionary *Dic in comicsList) {
            ItemModel *recModel = [[ItemModel alloc] init];
            [recModel setValuesForKeysWithDictionary:Dic];
            if ([recModel.bigbook_name isEqualToString:@"漫画岛招聘"]) {
                continue;
            }
            [modelArr addObject:recModel];
        }
        //通过block的形式将数据传递出去
        result(modelArr);
        [modelArr release];
    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        //将请求回来的data数据进行解析
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//        //检验数据
//        //        NSLog(@"*********dic2 = %@",dic);
//        
//        NSDictionary *infoDic = [dic valueForKey:@"info"];
//        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
//        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
//        
//        for (NSDictionary *Dic in comicsList) {
//            ItemModel *recModel = [[ItemModel alloc] init];
//            [recModel setValuesForKeysWithDictionary:Dic];
//            if ([recModel.bigbook_name isEqualToString:@"漫画岛招聘"]) {
//                continue;
//            }
//            [modelArr addObject:recModel];
//        }
//        //通过block的形式将数据传递出去
//        result(modelArr);
//    }];
}

+(void)boardListInterfaceWithResult:(result)result
{
    NSURL *url = [NSURL URLWithString:boardListURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    //设置异步post请求的body体
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"type":@"1",@"pageno":@"1",@"pagesize":@"10"} options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody: data];
    //发送异步请求
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        //将请求回来的data数据进行解析
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //检验数据
        //        NSLog(@"*********dic2 = %@",dic);
        
        NSDictionary *infoDic = [dic valueForKey:@"info"];
        NSArray *specials = [infoDic valueForKey:@"specials"];
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
        
        
        for (NSDictionary *Dic in specials) {
            boardListModel *boaModel = [[boardListModel alloc] init];
            [boaModel setValuesForKeysWithDictionary:Dic];
            [modelArr addObject:boaModel];
        }
        //通过block的形式将数据传递出去
        result(modelArr);
        [modelArr release];

    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        //将请求回来的data数据进行解析
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        
//        //检验数据
//        //        NSLog(@"*********dic2 = %@",dic);
//        
//        NSDictionary *infoDic = [dic valueForKey:@"info"];
//        NSArray *specials = [infoDic valueForKey:@"specials"];
//        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
//        
//        
//        for (NSDictionary *Dic in specials) {
//            boardListModel *boaModel = [[boardListModel alloc] init];
//            [boaModel setValuesForKeysWithDictionary:Dic];
//            [modelArr addObject:boaModel];
//        }
//        //通过block的形式将数据传递出去
//        result(modelArr);
//        [modelArr release];
//    }];
}

+(void)specialBoardInterfaceWithPageno:(NSNumber*)pageno AndID:(NSNumber*)ID ToResult:(result)result;
{
    NSURL *url = [NSURL URLWithString:specialBoardURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求方式
    [request setHTTPMethod:@"POST"];
    NSDictionary *bodyDic = @{@"pageno":[NSString stringWithFormat:@"%@",pageno] ,@"pagesize":@"10",@"special":[NSString stringWithFormat:@"%@",ID],@"sort":@"4"} ;
    //设置异步post请求的body体(special对应的value由前一个页面获取)
    NSData *data = [NSJSONSerialization dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPBody: data];
    //发送异步请求
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        //将请求回来的data数据进行解析
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        //        NSLog(@"dic111 = %@",dic);
        
        NSDictionary *infoDic = [dic valueForKey:@"info"];
        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *Dic in comicsList) {
            specialBoardModel *speModel = [[specialBoardModel alloc] init];
            [speModel setValuesForKeysWithDictionary:Dic];
            [modelArr addObject:speModel];
        }
        //通过block的形式将数据传递出去
        result(modelArr);
        [modelArr release];

    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        //将请求回来的data数据进行解析
//        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        //        NSLog(@"dic111 = %@",dic);
//        
//        NSDictionary *infoDic = [dic valueForKey:@"info"];
//        NSArray *comicsList = [infoDic valueForKey:@"comicsList"];
//        NSMutableArray *modelArr = [[NSMutableArray alloc] initWithCapacity:10];
//        for (NSDictionary *Dic in comicsList) {
//            specialBoardModel *speModel = [[specialBoardModel alloc] init];
//            [speModel setValuesForKeysWithDictionary:Dic];
//            [modelArr addObject:speModel];
//        }
//        //通过block的形式将数据传递出去
//        result(modelArr);
//        [modelArr release];
//    }];
}

+(void)getRecommenScrollDataToResult:(result)result
{

    NSURL *url = [NSURL URLWithString:recScorllURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    DataHandle *dataH =  [[DataHandle alloc]init];
    [[[self shareDataRequest] dataHandleArray] addObject:dataH];
    [dataH release];
    [dataH sendAsynDelegateRequest:request WithData:^(NSMutableData *data) {
        if (data==nil) {
            return ;
        }
        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secDic = firDic[@"info"];
        NSString *imageString = secDic[@"adlistjson"];
        NSData *data2 = [imageString dataUsingEncoding:NSUTF8StringEncoding];
        if (data2 == nil) {
            return;
        }
        NSMutableArray *pagesArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSUTF8StringEncoding error:nil];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *thirDic in pagesArray) {
            ScorllModel *model = [[ScorllModel alloc]init];
            [model setValuesForKeysWithDictionary:thirDic];
            [array addObject:model];
            [model release];
        }
        //NSLog(@"%@", pagesArray);
        if (result)
            result(array);
        [array release];

    }];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (data==nil || connectionError!=nil) {
//            return ;
//        }
//        NSDictionary *firDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSDictionary *secDic = firDic[@"info"];
//        NSString *imageString = secDic[@"adlistjson"];
//        NSData *data2 = [imageString dataUsingEncoding:NSUTF8StringEncoding];
//        if (data2 == nil) {
//            return;
//        }
//        NSMutableArray *pagesArray = [NSJSONSerialization JSONObjectWithData:data2 options:NSUTF8StringEncoding error:nil];
//        NSMutableArray *array = [[NSMutableArray alloc]init];
//        for (NSDictionary *thirDic in pagesArray) {
//            ScorllModel *model = [[ScorllModel alloc]init];
//            [model setValuesForKeysWithDictionary:thirDic];
//            [array addObject:model];
//            [model release];
//        }
//        //NSLog(@"%@", pagesArray);
//        if (result)
//            result(array);
//        [array release];
//    }];
    
}



@end
