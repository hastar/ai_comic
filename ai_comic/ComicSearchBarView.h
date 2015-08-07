//
//  ComicSearchBarView.h
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#define XSIZETOFIT(x) (xbounds*(x))
#define YSIZETOFIT(y) (ybounds*(y))
@interface ComicSearchBarView : UIView

@property(nonatomic, retain)UISearchBar *searchBar;
@property(nonatomic, retain)UIButton *button;


@end
