//
//  ViewController.h
//  Tools
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComicPagesColltionControll : UIViewController

@property(nonatomic, retain)NSArray *sectionsArray;
//看的是第几话
@property(nonatomic, assign)NSInteger Sectionindex;
@property(nonatomic, retain) NSNumber *book_id;
@property(nonatomic,retain)NSNumber *bigbookid;
@property(nonatomic,retain)NSString *bigbookname;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *updatemessage;
@property(nonatomic,retain)NSNumber *partid;
@end

