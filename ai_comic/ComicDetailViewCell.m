//
//  ComicDetailViewCell.m
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicDetailViewCell.h"
#import "SectionsScrollView.h"
#define XSIZETOFIT(x) (xbounds*(x))
#define YSIZETOFIT(y) (ybounds*(y))
#define ButtonWidth 15
#define ButtonHieght  15

@interface ComicSectionButton ()

@end

@implementation ComicSectionButton

-(void)dealloc
{
    [_sourceLabel release];
    [_currentSection release];
    [_updateTimeLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
        CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
        //self = [UIButton buttonWithType:UIButtonTypeCustom];
        //self.frame = frame;
        self.sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(8), 0, XSIZETOFIT(150), YSIZETOFIT(21))];
        _sourceLabel.font = [UIFont systemFontOfSize:13];
        _sourceLabel.textColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:_sourceLabel];
        [_sourceLabel release];
        
        self.currentSection = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(8), YSIZETOFIT(21), XSIZETOFIT(221), YSIZETOFIT(21))];
        _currentSection.font = [UIFont systemFontOfSize:15];
        [self addSubview:_currentSection];
        [_currentSection release];

        self.updateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(8), YSIZETOFIT(40), XSIZETOFIT(150), YSIZETOFIT(21))];
        _updateTimeLabel.font = [UIFont systemFontOfSize:13];
        _updateTimeLabel.textColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:_updateTimeLabel];
        [_updateTimeLabel release];
        
        UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(260), YSIZETOFIT(35), XSIZETOFIT(100), YSIZETOFIT(30))];
        signLabel.text = @"下拉列表⬇️";
        //signLabel.font = [UIFont preferredFontForTextStyle:@"body"];
        signLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        signLabel.textColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:signLabel];
        [signLabel release];
    }

    return self;
}

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface ComicDetailButton()
{
    CGRect sourceViewRect;
    BOOL isSetOut;
}

@end


@implementation ComicDetailButton

-(void)dealloc
{
    [_label release];
    [_button release];
    [super dealloc];
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]init];
        self.label.numberOfLines = 0;
        //字体不要用body体！！！！  在改变frame的时候，字体大小会进行微调，视觉效果差
        //_label.font = [UIFont systemFontOfSize:13];
        _label.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        _label.frame = CGRectMake(0, 0, frame.size.width, 2 * _label.font.lineHeight);
        _label.textColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        [self addSubview:_label];
        [_label release];
        
        self.button = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"展开16"]];
        self.button.frame = CGRectMake(self.frame.size.width - ButtonWidth, _label.frame.size.height, ButtonWidth, ButtonHieght);
        [self addSubview:self.button];
        [_button release];
        
        [self addTarget:self action:@selector(doClick:) forControlEvents:UIControlEventTouchUpInside];
       
    }
//    self.backgroundColor = [UIColor redColor];
//    self.label.backgroundColor = [UIColor yellowColor];
    return self;
}

- (void)doClick:(id)sender
{
    if (isSetOut) {
        isSetOut = NO;
        [self setFrame:sourceViewRect];
        [_label setFrame:CGRectMake(0, 0, _label.frame.size.width, 2*_label.font.lineHeight)];

    }
    else
    {
        isSetOut = YES;
        sourceViewRect = self.frame;
        _label.frame = [_label textRectForBounds:CGRectMake(_label.frame.origin.x, _label.frame.origin.y, _label.frame.size.width, CGFLOAT_MAX) limitedToNumberOfLines:0];
        [self setFrame: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _label.frame.size.height + ButtonHieght)];
//        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//            [_button setFrame:CGRectMake(self.frame.size.width - ButtonWidth, _label.frame.size.height, ButtonWidth, ButtonHieght)];
//            CGAffineTransform t_Rotation=CGAffineTransformRotate(_button.transform, M_PI);
//            _button.transform = t_Rotation;
//        } completion:^(BOOL finished) {
//        }];
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_button setFrame:CGRectMake(self.frame.size.width - ButtonWidth, self.frame.size.height - ButtonHieght, ButtonWidth, ButtonHieght)];
        CGAffineTransform t_Rotation=CGAffineTransformRotate(_button.transform, M_PI);
        _button.transform = t_Rotation;
    } completion:^(BOOL finished) {
    }];
}




@end








//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation ComicDetailViewCell

-(void)dealloc
{
    [_coverImageView release];
    [_titleLabel release];
    [_authorButton release];
    [_readState release];
    [_comicDetailButton release];
    [_sectionButton release];
    [_scrollView release];
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
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
        CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
        //NSLog(@"%f,%f", xbounds, ybounds);
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(XSIZETOFIT(16), YSIZETOFIT(8), XSIZETOFIT(100), YSIZETOFIT(120))];
        [self.contentView addSubview:_coverImageView];
        [_coverImageView release];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(134), YSIZETOFIT(8), XSIZETOFIT(225), YSIZETOFIT(25))];
         _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        _titleLabel.textColor  = [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        //_titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel release];
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(XSIZETOFIT(134), YSIZETOFIT(41), XSIZETOFIT(50), YSIZETOFIT(21))];
        //aLabel.bounds = [aLabel textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, aLabel.frame.size.height) limitedToNumberOfLines:1];
        //aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        aLabel.text = @"作者：";
        aLabel.textColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:aLabel];
        [aLabel release];
        
        //增加继续阅读和加入收藏两个按钮（修改：Lee）
        self.collectButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.collectButton.frame = CGRectMake(XSIZETOFIT(126), YSIZETOFIT(80), XSIZETOFIT(80), YSIZETOFIT(40));
        [self.collectButton setTitle:@"加入收藏" forState:UIControlStateNormal];
        [self.contentView addSubview:self.collectButton];
        [self.collectButton release];
        
        self.continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.continueButton.frame = CGRectMake(XSIZETOFIT(226), YSIZETOFIT(80), XSIZETOFIT(80), YSIZETOFIT(40));
        [self.continueButton setTitle:@"继续阅读" forState:UIControlStateNormal];
        [self addSubview:self.continueButton];
        [self.continueButton release];

        
        
        
        
        
        self.authorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _authorButton.frame = CGRectMake(XSIZETOFIT(170), YSIZETOFIT(37), XSIZETOFIT(170), YSIZETOFIT(30));
        //设置左对齐
        _authorButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_authorButton addTarget:self action:@selector(ClickAuthorButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_authorButton];
        
        
        self.comicDetailButton = [[ComicDetailButton alloc]initWithFrame:CGRectMake(XSIZETOFIT(16), YSIZETOFIT(136), XSIZETOFIT(343), YSIZETOFIT(45))];
        [self.comicDetailButton addTarget:self action:@selector(touchDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.comicDetailButton setHighlighted:YES];
        [self addSubview:_comicDetailButton];
        [_comicDetailButton release];

        /******************************          章节部分             ************************************/
        self.sectionButton = [[ComicSectionButton alloc]initWithFrame:CGRectMake(XSIZETOFIT(16), self.comicDetailButton.frame.origin.y + self.comicDetailButton.frame.size.height + 30, XSIZETOFIT(343), YSIZETOFIT(65))];
        self.sectionButton.layer.cornerRadius = 2.5;
        self.sectionButton.layer.masksToBounds = YES;
        self.sectionButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.sectionButton.layer.borderWidth = 1;
//        [self.sectionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        self.sectionButton.highlighted = YES;
        self.sectionButton.backgroundColor = [UIColor whiteColor];
        //[_sectionButton addTarget:self action:@selector(ClickSectionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sectionButton];
        [_sectionButton release];
        
        
        /*------------------------------------------   章节滑动栏    ---------------------------------------------------*/
        self.scrollView = [[SectionsScrollView alloc]initWithFrame:CGRectMake(_sectionButton.frame.origin.x, _sectionButton.frame.origin.y+_sectionButton.frame.size.height, _sectionButton.frame.size.width, 0)];
        [self addSubview:_scrollView];
        [_scrollView release];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XSIZETOFIT(375), self.comicDetailButton.frame.origin.y+self.comicDetailButton.frame.size.height+10)];
        _bottomView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1.0];
        _bottomView.layer.borderWidth = 0.15;
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.borderColor = [UIColor blackColor].CGColor;
        [self addSubview:_bottomView];
        [self sendSubviewToBack:_bottomView];
        [_bottomView release];
        
        self.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
    }
    
    return self;
}

- (void)touchDetailButton:(id)sender
{
//    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
//    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
//    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self.sectionButton setFrame: CGRectMake(XSIZETOFIT(16), self.comicDetailButton.frame.origin.y + self.comicDetailButton.frame.size.height + 30, XSIZETOFIT(343), YSIZETOFIT(65))];
//        [self.scrollView setFrame:CGRectMake(XSIZETOFIT(16), self.sectionButton.frame.origin.y + self.sectionButton.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
//    } completion:^(BOOL finished) {
//    }];
}


- (void)ClickAuthorButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(doClickAuthorButton:)]) {
        [self.delegate doClickAuthorButton:sender];
    }
}








- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.sectionButton setFrame: CGRectMake(XSIZETOFIT(16), self.comicDetailButton.frame.origin.y + self.comicDetailButton.frame.size.height + 30, XSIZETOFIT(343), YSIZETOFIT(65))];
        [self.scrollView setFrame:CGRectMake(XSIZETOFIT(16), self.sectionButton.frame.origin.y + self.sectionButton.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [self.bottomView setFrame:CGRectMake(0, 0, XSIZETOFIT(375), self.comicDetailButton.frame.origin.y+self.comicDetailButton.frame.size.height+10)];
    } completion:^(BOOL finished) {
    }];
    UITableView *tableView = self.superview.superview;
    if (self.scrollView.frame.size.height + self.scrollView.frame.origin.y >= YSIZETOFIT(650)) {
        //NSLog(@"%@", self.superview.superview);
        tableView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.origin.y + self.scrollView.frame.size.height+25);
        CGRect rect = self.frame;
        rect.size.height = self.scrollView.frame.origin.y + self.scrollView.frame.size.height+25;
        self.frame = rect;
    }
    else
    {
       tableView.contentSize = CGSizeMake(0, 0);
        CGRect rect = self.frame;
        rect.size.height = 667;
        self.frame = rect;
    }
}

//- (void)ClickSectionButton:(id)sender
//{
//    if ([self.delegate respondsToSelector:@selector(doShowOutSections:)]) {
//        [self.delegate doShowOutSections:sender];
//    }
//}

@end
