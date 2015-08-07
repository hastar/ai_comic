//
//  BaseUITableViewCell.h
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComicJumpDelegate.h"

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, assign)id <ComicJumpDelegate>delegate;
@end
