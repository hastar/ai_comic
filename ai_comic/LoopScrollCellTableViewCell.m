//
//  LoopScrollCellTableViewCell.m
//  ai_comic
//
//  Created by lanou on 15/7/1.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "LoopScrollCellTableViewCell.h"

#define XSIZETOFIT(x) (xbounds*(x))
#define YSIZETOFIT(y) (ybounds*(y))
@implementation LoopScrollCellTableViewCell

- (void)dealloc
{
    [_scroll release];
    [_pageC release];
    [super dealloc];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, XSIZETOFIT(667), YSIZETOFIT(150))];
        //        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width*3, _scroll.frame.size.height);
        _scroll.pagingEnabled = YES;
        _scroll.bounces = NO;
        [self addSubview:_scroll];
        [_scroll release];
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:234/255.0 blue:244/255.0 alpha:1.0];
    }
    return  self;
}

@end
