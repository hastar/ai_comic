//
//  BoardTableViewCell.m
//  test
//
//  Created by lanou on 15/6/27.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import "BoardTableViewCell.h"
#import "boardListModel.h"

#define XSIZETOFIT(x) (xbounds*(x))
#define YSIZETOFIT(y) (ybounds*(y))
@implementation BoardTableViewCell
//-(UIImageView *)BoardimageView
//{
//    if (_BoardimageView) {
//        self.BoardimageView = [[UIImageView alloc]initWithFrame:self.bounds];
//        [self.contentView addSubview:self.BoardimageView];
//    }
//    return self.BoardimageView;
//}
-(void)dealloc
{
    [_BoardimageView release];
    [_nameLabel release];
    [_desLabel release];
    [_boardPage release];
    [super dealloc];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667;
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.BoardimageView = [[UIImageView alloc] initWithFrame:CGRectMake(XSIZETOFIT(10), YSIZETOFIT(10), XSIZETOFIT(125), YSIZETOFIT(80))];
        [self.contentView addSubview:_BoardimageView];
        self.BoardimageView.layer.cornerRadius  = 2.5;
        self.BoardimageView.layer.masksToBounds = YES;
        [_BoardimageView release];
        //CGRectMake(XSIZETOFIT(150), YSIZETOFIT(50), XSIZETOFIT(150), YSIZETOFIT(60))
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XSIZETOFIT(150), YSIZETOFIT(10), XSIZETOFIT(150), YSIZETOFIT(25))];
        self.nameLabel.textColor =[UIColor darkGrayColor];
        [self.nameLabel setFont:[UIFont fontWithName:@"Marker" size:15]];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
        
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(XSIZETOFIT(150), YSIZETOFIT(35), XSIZETOFIT(150), YSIZETOFIT(40))];
        _desLabel.textColor =[UIColor darkGrayColor];
        [_desLabel setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:12]];
        _desLabel.numberOfLines = 0;
        [self.contentView addSubview:_desLabel];
        [_desLabel release];
    }
    return self;
}

-(void)setBoardPage:(boardListModel *)boardPage
{
    if (_boardPage != boardPage) {
        [_boardPage release];
        _boardPage = [boardPage retain];
    }
    //self.BoardimageView.image = boardPage.image;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
