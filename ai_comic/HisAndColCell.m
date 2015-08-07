//
//  HisAndColCell.m
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
#define widthsFit  [UIScreen mainScreen].bounds.size.width/375
#define  heightsFit   [UIScreen mainScreen].bounds.size.height/667
#import "HisAndColCell.h"

@implementation HisAndColCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        NSLog(@"self.frame.size.width = %f",[UIScreen mainScreen].bounds.size.height);
        
        //未能适配屏幕
   

        self.posterView = [[UIImageView alloc] initWithFrame:CGRectMake(10*widths/375,10*heights/667,80*widths/375,100*heights/667)];
        self.posterView.contentMode = UIViewContentModeScaleAspectFit;
        //设置图片圆角
        self.posterView.layer.cornerRadius = 3;
        self.posterView.layer.masksToBounds = YES;
        
        self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(100*widths/375, 20*heights/667,widths/2, 20*heights/667)];
        self.recordLable = [[UILabel alloc] initWithFrame:CGRectMake(100*widths/375, 55*heights/667, widths/2, 15*heights/667)];
        self.lastChapterLable = [[UILabel alloc] initWithFrame:CGRectMake(100*widths/375,80*heights/667, widths/2, 15*heights/667)];
        self.continueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.continueButton.layer.cornerRadius = 1.5;
        self.continueButton.layer.borderWidth = 0.2;
        self.continueButton.layer.borderColor = [UIColor blackColor].CGColor;
        self.continueButton.layer.masksToBounds = YES;
         self.continueButton.frame = CGRectMake(290*widths/375, 60*heights/667, 50*widths/375,25*heights/667);
        
        [self.continueButton setBackgroundImage:[UIImage imageNamed:@"BUTTON"] forState:UIControlStateNormal];
        [self.continueButton setTitle:@"续看" forState:UIControlStateNormal];

        self.recordLable.font = [UIFont systemFontOfSize:13];
        self.recordLable.textColor = [UIColor grayColor];
        self.lastChapterLable.font = [UIFont systemFontOfSize:13];
        self.lastChapterLable.textColor = [UIColor grayColor];
        
        self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(8*widthsFit,8*heightsFit,359*widthsFit,116*heightsFit)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 5;
        _bottomView.layer.borderWidth = 0.3;
        _bottomView.layer.masksToBounds = YES;
        
        
//         self.posterView.backgroundColor = [UIColor orangeColor];
//         self.titleLable.backgroundColor = [UIColor orangeColor];
//         self.recordLable.backgroundColor = [UIColor orangeColor];
//         self.lastChapterLable.backgroundColor = [UIColor orangeColor];
//         self.continueButton.backgroundColor = [UIColor orangeColor];
        
        self.backgroundColor =[UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        [self.contentView addSubview: self.posterView];
//        [self.contentView addSubview: self.titleLable];
//        [self.contentView addSubview: self.recordLable];
//        [self.contentView addSubview: self.lastChapterLable];
//        [self.contentView addSubview: self.continueButton];
        
        
        [self.bottomView addSubview: self.posterView];
        [self.bottomView addSubview: self.titleLable];
        [self.bottomView addSubview: self.recordLable];
        [self.bottomView addSubview: self.lastChapterLable];
        [self.bottomView addSubview: self.continueButton];
        
        
        
        [self.contentView addSubview:_bottomView];

//        NSLog(@"%f",self.frame.size.width-20);
        
        }
    return self;
}
@end
