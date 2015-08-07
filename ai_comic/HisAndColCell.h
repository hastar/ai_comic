//
//  HisAndColCell.h
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HisAndColCell : UITableViewCell
@property(nonatomic,retain)UIImageView *posterView;
@property(nonatomic,retain)UILabel *titleLable;
@property(nonatomic,retain)UILabel *recordLable;
@property(nonatomic,retain)UILabel *lastChapterLable;
@property(nonatomic,retain)UIButton *continueButton;
@property(nonatomic,retain)UIView *bottomView;
@end
