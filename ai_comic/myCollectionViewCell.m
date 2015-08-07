//
//  myCollectionViewCell.m
//  Tools
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
#define widthsFit  [UIScreen mainScreen].bounds.size.width/375
#define  heightsFit  [UIScreen mainScreen].bounds.size.height/667
#import "myCollectionViewCell.h"

@implementation myCollectionViewCell

//- (void)dealloc
//{
//    [_imageV release];
//    [_scrollV release];
//    [_pageLabel release];
//    [super dealloc];
//}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //不包含状态栏的Rect
//        CGRect rect = [[UIScreen mainScreen]applicationFrame];
        self.imageV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 20, widths, heights - 40)];
        self.imageV.backgroundColor = [UIColor blackColor];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        self.scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, widths, heights )];
        [self.scrollV addSubview:self.imageV];
//        self.scrollV.bounces = NO;
//        self.scrollV.alwaysBounceVertical = NO;
        self.scrollV.decelerationRate = 0.01;
        self.scrollV.delaysContentTouches = NO;
        self.scrollV.maximumZoomScale = 2;
        self.scrollV.minimumZoomScale = 1;
        self.scrollV.delegate = self;
        self.scrollV.showsVerticalScrollIndicator = NO;
        self.scrollV.showsHorizontalScrollIndicator = NO;
        
        //设置显示页数的label
//        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(widths/2 - 25*widthsFit, heights - 20, 50*widthsFit, 20)];
//        self.pageLabel.font = [UIFont systemFontOfSize:10];
//        self.pageLabel.textColor = [UIColor whiteColor];
//        self.pageLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
       
        [self.contentView addSubview:self.scrollV];
        self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTheDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        [self.scrollV addGestureRecognizer:_doubleTap];
//        [showTap requireGestureRecognizerToFail:doubleTap];
    }
    return self;
}

//一定要重写该方法，不然会重影
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageV.frame = self.bounds;
}

- (CGFloat)imageScaleHeight
{
    CGFloat w = self.imageV.image.size.width;
    CGFloat h = self.imageV.image.size.height;
    return  self.scrollV.frame.size.width/w*h*self.scrollV.zoomScale;
}


- (CGFloat)viewRatio
{
//    size_t w = CGImageGetWidth(self.imageV.image.CGImage);
//    size_t h = CGImageGetHeight(self.imageV.image.CGImage);
    CGFloat w = self.imageV.image.size.width;
    CGFloat h = self.imageV.image.size.height;
    NSLog(@"%f", h/w);
    return h/w;
}

#pragma -mark   捏合后执行的方法
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    CGFloat imageHeight = scrollView.frame.size.width*scrollView.zoomScale*[self viewRatio];
//    if (imageHeight >= scrollView.frame.size.height) {
//        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, (imageHeight - scrollView.frame.size.height)/2);
//    }
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat imageHeight = [self imageScaleHeight];
    if (imageHeight < scrollView.frame.size.height && scrollView.zooming==NO) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, (self.imageV.frame.size.height- scrollView.frame.size.height)/2);
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self setContentInset];
}

- (void)setContentInset
{
    CGFloat imageVHeight = [self imageScaleHeight];
    if (imageVHeight >= self.scrollV.frame.size.height) {
        CGFloat VemptyPlace = ( self.scrollV.frame.size.height * self.scrollV.zoomScale - imageVHeight)/2;
        self.scrollV.contentInset = UIEdgeInsetsMake( -VemptyPlace, 0, 0, 0);
        self.scrollV.contentSize = CGSizeMake( self.scrollV.frame.size.width * self.scrollV.zoomScale,   (self.scrollV.frame.size.height* self.scrollV.zoomScale - VemptyPlace) );
    }
    else
    {
        self.scrollV.contentInset = UIEdgeInsetsZero;
    }
}

- (void)doTheDoubleTap:(UITapGestureRecognizer *)tap
{
    UIScrollView *scroll = (UIScrollView *)tap.view;
    CGPoint tapPoint =  [tap locationInView:tap.view];
    
    CGFloat imageHeight = [self imageScaleHeight];
    CGFloat zoomScale = 2.0f;
    CGFloat Xpoint = scroll.center.x + (tapPoint.x-scroll.center.x)*zoomScale;
    CGFloat Ypoint = scroll.center.y+ (tapPoint.y-scroll.center.y)*zoomScale;

    CGFloat VemptyPlace = (self.imageV.frame.size.height - imageHeight)/2;
    
    if (Xpoint < 0) {
        Xpoint = 0;
    }
    else if (Xpoint > scroll.frame.size.width*(zoomScale-1)) {
        Xpoint = scroll.frame.size.width*(zoomScale-1);
    }
    
    if ((Ypoint < VemptyPlace*zoomScale)&&(imageHeight*zoomScale >= scroll.frame.size.height)) {
        Ypoint = VemptyPlace*zoomScale;
    }
    else if (Ypoint > (scroll.frame.size.height)*(zoomScale-1)-VemptyPlace*zoomScale) {
        Ypoint = (scroll.frame.size.height)*(zoomScale-1)-VemptyPlace*zoomScale;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        if (scroll.zoomScale != 1.0f) {
            scroll.zoomScale = 1.0f;
            scroll.contentInset = UIEdgeInsetsZero;
            scroll.contentSize = CGSizeZero;
        }
        else
        {
            scroll.zoomScale = zoomScale;
            scroll.contentInset = UIEdgeInsetsMake(-VemptyPlace*zoomScale, 0, 0, 0);
            scroll.contentSize = CGSizeMake(scroll.frame.size.width*zoomScale, scroll.frame.size.height*zoomScale - VemptyPlace*zoomScale);
            scroll.contentOffset = CGPointMake(Xpoint, Ypoint);
        }
    }];
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews   objectAtIndex:0];
}


@end
