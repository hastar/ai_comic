//
//  NBWaterFlowLayout.h
//  test
//
//  Created by 侯垒 on 15/5/19.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NBWaterFlowLayout;

/**
 *  UICollectionView扩展协议，获取每个item的高度
 */
@protocol UICollectionViewDelegateWaterFlowLayout <UICollectionViewDelegate>
/**
 *  返回每个item自己的高度
 *
 *  @param collectionView 返回的高度在哪一个集合视图中使用
 *  @param layout         按照什么样的布局来返回高度
 *  @param indexPath      返回的是第几个item的高度
 *
 *  @return item的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
          waterFlowLayout:(NBWaterFlowLayout *)layout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NBWaterFlowLayout : UICollectionViewLayout
@property (nonatomic, assign) id<UICollectionViewDelegateWaterFlowLayout> delegate;

@property (nonatomic, assign) NSUInteger numberOfColumns;//瀑布流的列数
@property (nonatomic, assign) CGSize itemSize;//每一个item的大小
@property (nonatomic, assign) UIEdgeInsets sectionInsets;//分区的上、下、左、右、四个边距

@end
