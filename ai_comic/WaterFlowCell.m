//
//  MyCollectionViewCell.m
//  test
//
//  Created by 侯垒 on 15/5/19.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import "WaterFlowCell.h"
#import "ItemModel.h"
@implementation WaterFlowCell

-(void)dealloc
{
    [_imageView release];
    [_bookLabel release];
    [_bookName release];
    [_lastPartName release];
    [super dealloc];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
      
        [self.contentView addSubview:_imageView];
        
        //设置图片圆角
        self.imageView.layer.cornerRadius = 4;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        
        
        //设置作品名称 章节
        
        //self.bookName = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        self.bookName = [[UILabel alloc]initWithFrame:frame];
        self.bookName.backgroundColor = [UIColor whiteColor];
        self.bookName.alpha = 0.8;
        [self.imageView addSubview:self.bookName];
        //self.lastPartName = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height-20, self.frame.size.width, 20)];
        self.lastPartName=  [[UILabel alloc]initWithFrame:frame];
        self.lastPartName.alpha = 0.8;
        //self.lastPartName.textAlignment = NSTextAlignmentRight;
        
        self.lastPartName.backgroundColor = [UIColor whiteColor];
        [self.imageView addSubview:self.lastPartName];
        
    }
    return self;
}


//一定要重写该方法，不然会重影
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGRect rect = _bookName.frame;
    rect.size.width = self.frame.size.width/2;
    rect.size.height = 20;
    rect.origin.y =self.imageView.frame.size.height - rect.size.height;
    rect.origin.x = 0;
    _bookName.frame = rect;
    
    CGRect rect2 = _lastPartName.frame;
    
    rect2.origin.x = self.frame.size.width/2;
    rect2.origin.y =self.frame.size.height-20;
    rect2.size.width = self.imageView.frame.size.width/2;
    rect2.size.height = 20;
    
    _lastPartName.frame = rect2;
    //_lastPartName.textAlignment = NSTextAlignmentRight;

}

@end
