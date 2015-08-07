//
//  ComicDetailPageController.h
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@interface ComicDetailPageController : BaseTableViewController
@property (nonatomic,retain)NSNumber *bigbookid;
//传值到看漫画页面的属性，然后再看漫画页面存入数据库；


@end
