//
//  BoardTableViewCell.h
//  test
//
//  Created by lanou on 15/6/27.
//  Copyright (c) 2015年 Se7eN_HOU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "boardListModel.h"

@interface BoardTableViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *BoardimageView;
@property(nonatomic,retain)UILabel *desLabel;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)boardListModel *boardPage;
@end
