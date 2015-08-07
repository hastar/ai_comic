//
//  historyView.m
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height

#import "historyView.h"

@implementation historyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.myTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, widths, heights -104)];
        self.myTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
         self.myTabView.scrollEnabled = YES;
        [self addSubview:self.myTabView];
        
    }
    return self;
}




@end
