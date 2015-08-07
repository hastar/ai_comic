//
//  SectionsScrollView.m
//  ai_comic
//
//  Created by lanou on 15/6/25.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "SectionsScrollView.h"
#import "ComicSectionModel.h"
@implementation SectionsScrollView

#define XLINES      4.0
#define BUTTONWIDTH    70
#define BUTTONHEIGHT    0.45*BUTTONWIDTH

- (void)dealloc
{
    [super dealloc];
}


- (void)creatButtonBySectionArray:(NSMutableArray *)sectionsArray
{
    int  Lines = (int)sectionsArray.count/XLINES;
    if ((int)sectionsArray.count%(int)XLINES != 0) {
        Lines += 1;
    }
    CGFloat linesSpace = (self.frame.size.width - XLINES*BUTTONWIDTH)/(XLINES + 1);
    for (int i = 0; i < Lines; i++) {
        for (int j = 0; j < XLINES; j++) {
            if ((XLINES*i+j)>=sectionsArray.count ) {
                break;
            }
            ComicSectionModel *model = [sectionsArray objectAtIndex:(XLINES*i+j)];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame = CGRectMake(linesSpace + j*(linesSpace + BUTTONWIDTH) , linesSpace + i*(linesSpace+BUTTONHEIGHT), BUTTONWIDTH, BUTTONHEIGHT);
            //            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            //            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            if ([model.name length] > 5) {
                [button setTitle: [NSString stringWithFormat:@"%@..",[model.name substringToIndex:6] ] forState:UIControlStateNormal];
                button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            }
            else
                [button setTitle:[NSString stringWithFormat:@"%@", model.name] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = XLINES*i+j;
//            button.layer.cornerRadius = 5.0;
//            button.layer.masksToBounds = YES;
//            button.layer.borderColor = [UIColor blackColor].CGColor;
 //           button.layer.borderWidth = 0.02;
//            button.backgroundColor  =  [UIColor whiteColor];
            button.tintColor =  [UIColor colorWithRed:61/255.0 green:53/255.0 blue:51/255.0 alpha:1.0];
            [button setBackgroundImage:[UIImage imageNamed:@"BUTTON"] forState:UIControlStateNormal];
            button.tintColor = [UIColor blackColor];
            [self addSubview:button];
        }
    }
    self.bounces = YES;
    self.contentSize = CGSizeMake(self.frame.size.width, (Lines )* (linesSpace + BUTTONHEIGHT)+linesSpace );
    self.isSetOut = YES;
}


- (void)touch:(id)sender
{
    [self.delegate kanManHua:(id)sender];
}

@end
