//
//  myCollectionViewCell.h
//  Tools
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UIScrollView *scrollV;
@property(nonatomic,strong)UILabel *pageLabel;
@property(nonatomic, strong)UITapGestureRecognizer *doubleTap;

@end
