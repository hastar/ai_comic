//
//  ComicSubjectsViewCell.m
//  ai_comic
//
//  Created by lanou on 15/6/27.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSubjectsViewCell.h"

@implementation ComicSubjectsViewCell
-(void)dealloc
{
    [_coverImageView release];
    [_nameLabel release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        _coverImageView.layer.cornerRadius = 2.2;
        //与边界对齐
        _coverImageView.layer.masksToBounds = YES;
        _coverImageView.layer.borderColor = [UIColor blackColor].CGColor;
        _coverImageView.layer.borderWidth = 0.3;
        [self.contentView addSubview:_coverImageView];
        [_coverImageView release];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _coverImageView.frame.size.height, self.frame.size.width, self.frame.size.height - self.frame.size.width)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont preferredFontForTextStyle:@"body"];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel release];
    }
    return self;
}

@end
