//
//  ComicDetailViewCell.h
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"


@interface ComicSectionButton : UIButton
@property (nonatomic, retain) UILabel *sourceLabel;
@property (nonatomic, retain) UILabel *currentSection;
@property (nonatomic, retain) UILabel *updateTimeLabel;
@end

@interface ComicDetailButton : UIButton

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *button;

@end



@class ComicSectionButton,ComicDetailButton,SectionsScrollView;
@interface ComicDetailViewCell : BaseTableViewCell
@property (nonatomic, retain) UIImageView *coverImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIView *bottomView;
//加入收藏、继续阅读的按钮
@property (nonatomic, retain) UIButton *collectButton;
@property (nonatomic, retain) UIButton *continueButton;
@property (nonatomic, retain) UIButton *authorButton;
@property (nonatomic, retain) UIButton *readState;
@property (nonatomic, retain) ComicDetailButton *comicDetailButton;
@property (nonatomic, retain) ComicSectionButton *sectionButton;
@property (nonatomic, retain) SectionsScrollView *scrollView;
@end

