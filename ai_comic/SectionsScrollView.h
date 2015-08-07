//
//  SectionsScrollView.h
//  ai_comic
//
//  Created by lanou on 15/6/25.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicJumpDelegate.h"
@interface SectionsScrollView : UIScrollView
//漫画话按钮是否已创建
@property (nonatomic, assign)BOOL isSetOut;


- (void)creatButtonBySectionArray:(NSMutableArray *)sectionsArray;
- (void)setScrollViewFrame:(CGRect)frame;

@end
