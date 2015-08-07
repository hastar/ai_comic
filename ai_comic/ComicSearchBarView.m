//
//  ComicSearchBarView.m
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSearchBarView.h"


@implementation ComicSearchBarView

-(void)dealloc
{
    [_searchBar release];
    [_button release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
    if (self = [super initWithFrame:frame]) {
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(8, 20, XSIZETOFIT(311), 44)];
        //self.searchBar.backgroundColor=[UIColor clearColor];
//        self.searchBar.barStyle =UIBarStyleBlackTranslucent;
//        
//        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//        
//        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//        
//        self.searchBar.placeholder = _(@"Search");
//        
//        self.searchBar.keyboardType = UIKeyboardTypeDefault;
//        
//        //--->背景图片
//        
//        UIView *segment = [m_searchBar.subviews objectAtIndex:0];
//        
//        UIImageView *bgImage = [[UIImageView alloc] initWithImage: [UIImageimageNamed:@"Images/search_bar_
    
//        [[self.searchBar.subviews objectAtIndex:0]removeFromSuperview];
        for (UIView *subview in self.searchBar.subviews)
        {
            for (UIView *aView in subview.subviews) {
                if ([aView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
                {
                    [aView removeFromSuperview];
                    break;
                }
            }
        }
        UIView *view = [[UIView alloc]initWithFrame:self.searchBar.bounds];
        //view.backgroundColor = [UIColor colorWithRed:237/255.0 green:233/255.0 blue:225/255.0 alpha:1.0];
        [self.searchBar insertSubview:view atIndex:0];
        [view release];
    
        [self addSubview:_searchBar];
        [_searchBar release];
        
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.layer.cornerRadius = 5;
        [_button setTitle:@"取消" forState:UIControlStateNormal];
        _button.frame = CGRectMake(XSIZETOFIT(319), 20, XSIZETOFIT(54), YSIZETOFIT(44));
        [self addSubview:_button];
        
        //self.backgroundColor = [UIColor colorWithRed:199.0/255 green:199.0/255 blue:204.0/255 alpha:1.0];
        //view.backgroundColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:241/255.0 alpha:1.0];
        // _searchBar.barTintColor = [UIColor colorWithRed:255/255.0 green:251/255.0 blue:241/255.0 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:237/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];    }
    return  self;
}

@end
