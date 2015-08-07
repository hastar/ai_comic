//
//  ComicJumpProtocol.h
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ComicJumpDelegate <NSObject>

@optional
- (void)doClickAuthorButton: (id) sender;
- (void)doShowOutSections:(id)sender;
- (void)kanManHua:(id)sender;


@end
