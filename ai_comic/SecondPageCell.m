//
//  SecondPageCell.m
//  ai_comic
//
//  Created by lanou on 15/6/27.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "SecondPageCell.h"
#define XSIZETOFIT(x) (xbounds*(x))
#define YSIZETOFIT(y) (ybounds*(y))

@interface SecondPageCell()

@property(nonatomic, retain) UIView *bottomView;

@end

@implementation SecondPageCell

-(void)dealloc
{
    [_coverImageView release];
    [_bookName release];
    [_authorName release];
    [_progressType release];
    [_bookView release];
    [_keyLabel release];
    [_bottomView release];
    [super dealloc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake( XSIZETOFIT(8), YSIZETOFIT(7), XSIZETOFIT(359), YSIZETOFIT(116))];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.borderWidth = 0.3;
        _bottomView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bottomView];
        [_bottomView release];
        
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake( XSIZETOFIT(8), YSIZETOFIT(5), XSIZETOFIT(82), YSIZETOFIT(106))];
        _coverImageView.layer.cornerRadius = 3;
        _coverImageView.layer.masksToBounds = YES;
        [_bottomView addSubview:_coverImageView];
        [_coverImageView release];
        
        self.bookName = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(2), XSIZETOFIT(253), YSIZETOFIT(24))];
        _bookName.font = [UIFont systemFontOfSize:17];
        [_bottomView addSubview:_bookName];
        [_bookName release];
        
        self.authorName = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(29), XSIZETOFIT(253), YSIZETOFIT(14))];
        _authorName.textColor = [UIColor grayColor];
        _authorName.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:_authorName];
        [_authorName release];
        
        self.keyLabel = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(46), XSIZETOFIT(253), YSIZETOFIT(14))];
        _keyLabel.textColor = [UIColor grayColor];
        _keyLabel.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:_keyLabel];
        [_keyLabel release];
        
        self.bookView = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(63), XSIZETOFIT(253), YSIZETOFIT(14))];
        _bookView.textColor = [UIColor grayColor];
        _bookView.font = [UIFont systemFontOfSize:13];
        [_bottomView addSubview:_bookView];
        [_bookView release];
        
        self.progressType = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(82), XSIZETOFIT(253), YSIZETOFIT(21))];
        _progressType.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [_bottomView addSubview:_progressType];
        [_progressType release];
    }
    return self;

}

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
//    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
//    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithRed:0.94f green:0.94f blue:0.94f alpha:1.00f];
//        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake( XSIZETOFIT(8), YSIZETOFIT(7), XSIZETOFIT(359), YSIZETOFIT(106))];
//        _bottomView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:_bottomView];
//        [_bottomView release];
//        
//        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake( XSIZETOFIT(8), YSIZETOFIT(2), XSIZETOFIT(82), YSIZETOFIT(101))];
//        [_bottomView addSubview:_coverImageView];
//        [_coverImageView release];
//        
//        self.bookName = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(2), XSIZETOFIT(253), YSIZETOFIT(24))];
//        _bookName.font = [UIFont preferredFontForTextStyle:@"Headline"];
//        [_bottomView addSubview:_bookName];
//        [_bookName release];
//        
//        self.authorName = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(29), XSIZETOFIT(253), YSIZETOFIT(14))];
//        _authorName.textColor = [UIColor grayColor];
//        _authorName.font = [UIFont systemFontOfSize:14];
//        [_bottomView addSubview:_authorName];
//        [_authorName release];
//        
//        self.keyLabel = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(46), XSIZETOFIT(253), YSIZETOFIT(14))];
//        _keyLabel.textColor = [UIColor grayColor];
//        _keyLabel.font = [UIFont systemFontOfSize:14];
//        [_bottomView addSubview:_keyLabel];
//        [_keyLabel release];
//        
//        self.bookView = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(63), XSIZETOFIT(253), YSIZETOFIT(14))];
//        _bookView.textColor = [UIColor grayColor];
//        _bookView.font = [UIFont systemFontOfSize:14];
//        [_bottomView addSubview:_bookView];
//        [_bookView release];
//        
//        self.progressType = [[UILabel alloc]initWithFrame:CGRectMake( XSIZETOFIT(98), YSIZETOFIT(82), XSIZETOFIT(253), YSIZETOFIT(21))];
//        _progressType.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//        [_bottomView addSubview:_progressType];
//        [_progressType release];
//    }
//    return self;
//}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
