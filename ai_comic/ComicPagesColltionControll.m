//
//  ViewController.m
//  Tools
//
//  Created by lanou on 15/6/22.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
#define widthsFit  [UIScreen mainScreen].bounds.size.width/375
#define  heightsFit  [UIScreen mainScreen].bounds.size.height/667

#import "ComicPagesColltionControll.h"
#import "ComicSectionModel.h"
#import "DataRequest.h"
#import "imageDownLoad.h"
#import "myCollectionViewCell.h"
#import "SQLstoreHis.h"
#import "ComicDetailPageController.h"
#import "ComicDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ComicPagesColltionControll ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UICollectionView *collection;
    UISlider *progressSlider;
    UIImageView *accessoryView;
    UIView *bottomView;
    BOOL swapLeft;
    BOOL swapRight;
    UILabel *labelTime;
    NSTimer *timeNow;
    UILabel *labelBattery;
    NSTimer *timeBattery;
    UIButton *savePicture;
    UIImage *picture_save;
    UIAlertView *saveAlert;
    UIView *navView;
    UIImageView *catImages;
    UITapGestureRecognizer *showTap;
}
@property (nonatomic, retain) NSMutableArray *chaImageArr;
@property (nonatomic,retain) UILabel *page;
@property (nonatomic, retain) ComicDetailModel *detailModel;
@property(nonatomic, retain) UILabel *timeLabel;
@end

@implementation ComicPagesColltionControll
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)dealloc
{
    NSLog(@"dealoc---------------------------------------------------------------");
    [collection.delegate release];
    collection.delegate = nil;
    [saveAlert release];
    [_chaImageArr release];
    
    [_sectionsArray release];
    [_book_id release];
    [_bigbookid release];
    [_bigbookname release];
    [_name release];
    [_updatemessage release];
    [_partid release];
    [_page release];
    [_timeLabel release];
    [_detailModel release];
    [super dealloc];
}

- (NSMutableArray *)chaImageArr
{
    if (!_chaImageArr) {
        if (_sectionsArray == nil) {
            //若数组为空，则直接用part_id,bookid网络请求（!!!!!但detailArray的下标还需要修改）
            __block ComicPagesColltionControll *weak_one = self;
            [DataRequest getComicDetailWithBigBookID:weak_one.bigbookid ToResult:^(NSMutableArray *detailArray) {
                weak_one.detailModel = detailArray[0] ;
                weak_one.updatemessage = weak_one.detailModel.updatemessage;
                [DataRequest getComicSectionsWithBookID:_detailModel.book_id ToResult:^(NSMutableArray *requestArray) {
                    weak_one.sectionsArray = [requestArray mutableCopy];
                    [DataRequest getComicPagesWithBookID:_detailModel.book_id AndPartID:weak_one.partid
                                                ToResult:^(NSMutableArray *arr) {
                                                    _chaImageArr = [[NSMutableArray alloc]initWithArray:arr];
                                                    [collection reloadData];
                                                    [catImages stopAnimating];
                                                    [catImages removeFromSuperview];
                                                }];
                }];
            }];
        }
        else
        {
            
            NSLog(@"s_count = %ld",_sectionsArray.count);
            ComicSectionModel *model = _sectionsArray[_Sectionindex];
            
            
            [DataRequest getComicPagesWithBookID:_book_id  AndPartID:model.part_id ToResult:^(NSMutableArray *arr) {
                //如果不在block中alloc一个self.chaImageArr,出了block之后
                _chaImageArr = [arr mutableCopy];
                [collection reloadData];
                [catImages stopAnimating];
                [catImages removeFromSuperview];
            }];
        }
    }
    return _chaImageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    catImages = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    catImages.center = self.view.center;
    catImages.animationDuration = 0.35;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed: [NSString stringWithFormat:@"0%d",i ]];
        [array addObject:image];
    }
    catImages.animationImages = [array mutableCopy];
//    [array release];
    catImages.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:catImages];
//    [catImages release];
    
    //自定义导航栏
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, widths, 64)];
    navView.backgroundColor = [UIColor blackColor];
    navView.alpha = 0.6;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.titleLabel.font = [UIFont systemFontOfSize:17];
    UIImageView  *backView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 25, 20, 30)];
    backView.image = [UIImage imageNamed:@"back"];
    backButton.frame = CGRectMake(0, 20, 100, 40);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.textAlignment = NSTextAlignmentRight;

    
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];

//    [backView release];
    
    self.page = [[UILabel alloc] initWithFrame:CGRectMake(widths/2 - 25*widthsFit, heights - 30, 50*widthsFit, 30)];
    self.page.textAlignment = NSTextAlignmentCenter;
    self.page.textColor = [UIColor whiteColor];
    self.page.font = [UIFont systemFontOfSize:15];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSLog(@"************%@",self.bigbookid);
 
    
    //***************UICollectionView布局的类************
    //1、创建一个布局类的对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //2、每个item的大小（不规则不瀑流不会直接使用该属性来设置大小）
//    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    //3、设置最小列间距
//    flowLayout.minimumInteritemSpacing = 0;
    //4、设置最小行间距（必须吧行间距设置为0才可以是实现画页无缝连接）
    flowLayout.minimumLineSpacing = 0;
    //5、设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //6、设置外部边距的属性(上，左，下，右)
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 30, 40);

    
    
    //**************UIcollectionView的相关设置**********
    //创建一个集合视图
    collection =[[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collection.delegate=self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor blackColor];
    //控制分页
    collection.pagingEnabled = YES;
    //是否允许反弹
  //collection.bounces = NO;
   
   //隐藏滚动条
    collection.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:collection];
    [flowLayout release];
    [collection release];
    
    //3**********注册一个item(cell)**********
    [collection registerClass:[myCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, heights, widths, heights/667*80)];

    
//    accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*4/5, self.view.frame.size.width, self.view.frame.size.height/5)];
     accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widths, heights/667*80)];
    accessoryView.userInteractionEnabled = YES;
  
    //设置进度条
    progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(20*widthsFit, 20*heightsFit,widths - 40, 20*heightsFit)];
    progressSlider.minimumValue = 0;
    progressSlider.maximumValue = 100;
   
    
    accessoryView.backgroundColor = [UIColor blackColor];
    accessoryView.alpha = 0.7;
    progressSlider.minimumTrackTintColor = [UIColor redColor];
    //添加点击隐藏accessoryView的方法；
    showTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAccessoryView)];
    [self.view addGestureRecognizer:showTap];
    [showTap release];
    
    //设置保存图片到本地相册的按钮
    savePicture = [UIButton buttonWithType:UIButtonTypeSystem];
    savePicture.frame = CGRectMake(self.view.frame.size.width, heights/2 - 20*heightsFit, 40*widthsFit, 40*heightsFit);
    UIImage *image = [UIImage imageNamed:@"save"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [savePicture setImage:image forState:UIControlStateNormal];
    [savePicture addTarget:self action:@selector(savePicture) forControlEvents:UIControlEventTouchUpInside];
//    savePicture.backgroundColor = [UIColor grayColor];
    [self.view addSubview:savePicture];
    
    [bottomView addSubview:accessoryView];
    [bottomView addSubview:progressSlider];
    [self.view addSubview:bottomView];
    [self.view addSubview:self.page];
    [self.view addSubview:navView];
    [accessoryView release];
    [progressSlider release];
    [bottomView release];
    [self.page release];
    [navView release];
    
    swapLeft = NO;
    swapRight = NO;
    
    
    //显示时间的Label
    labelTime = [[UILabel alloc] initWithFrame:CGRectMake(240*widthsFit, heights - 25, 50*widthsFit, 20)];
    labelTime.textColor = [UIColor whiteColor];
    labelTime.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:labelTime];
    [labelTime release];
    timeNow = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFunc) userInfo:nil repeats:YES];

   //显示电量的Label
   labelBattery = [[UILabel alloc] initWithFrame:CGRectMake(300*widthsFit, heights - 25, 65*widthsFit, 20)];
   labelBattery.textColor = [UIColor whiteColor];
   labelBattery.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:labelBattery];
    [labelBattery release];
    timeBattery = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(batteryFunc) userInfo:nil repeats:YES];

    //打开电池的监听
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    //进度条手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [progressSlider addGestureRecognizer:tap];
    [tap release];

    
    //    [cell addSubview:accessoryView];
    
    //进度条添加滑动页面的方法
    [progressSlider addTarget:self action:@selector(turnToPage:) forControlEvents:UIControlEventValueChanged];
    [progressSlider addTarget:self action:@selector(touchesEnded:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [navView addSubview:backView];
    [navView addSubview:backButton];
    


}




#pragma -mark 手势点击隐藏accessoryView的方法
-(void)showAccessoryView
{
    if ( navView.frame.origin.y == 0) { //隐藏
        [UIView animateWithDuration:0.5 animations:^{
            bottomView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, bottomView.frame.size.height);
            savePicture.frame = CGRectMake(self.view.frame.size.width, savePicture.frame.origin.y, savePicture.frame.size.width, savePicture.frame.size.height);
            navView.frame = CGRectMake(0, -64, self.view.frame.size.width, navView.frame.size.height);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{ // 显示
            bottomView.frame = CGRectMake(0, self.view.frame.size.height - bottomView.frame.size.height, self.view.frame.size.width, bottomView.frame.size.height);
            savePicture.frame = CGRectMake(self.view.frame.size.width - savePicture.frame.size.width, savePicture.frame.origin.y, savePicture.frame.size.width, savePicture.frame.size.height);
            navView.frame = CGRectMake(0, 0, self.view.frame.size.width, navView.frame.size.height);
        }];
    }
    bottomView.hidden = NO;
    savePicture.hidden = NO;
    navView.hidden = NO ;


}

#pragma -mark UICollectionViewDataSource代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//        self.page.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.chaImageArr.count];
         return self.chaImageArr.count ;
}

#pragma -mark item的重用方法____________________________________________________
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    myCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [showTap requireGestureRecognizerToFail:cell.doubleTap];
    cell.scrollV.zoomScale = 1.0;
    //改变进度条的值
//    if (indexPath.row == 0) {
//         progressSlider.value = 0;
//    }
//    else{
//    progressSlider.value = (indexPath.row + 1)*100/self.chaImageArr.count;
//    }
    
    //显示当前页码
    //self.page.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row + 1,(unsigned long)self.chaImageArr.count];
    
    [cell addSubview:catImages];
    [catImages startAnimating];
    //给slider添加点击手势
    NSURL *URL = [NSURL URLWithString: [self.chaImageArr[indexPath.row] valueForKey:@"imgurl"]];
//    [cell.imageV sd_setImageWithURL:URL placeholderImage:[UIImage new]];
//    picture_save = cell.imageV.image;

    [cell.imageV sd_setImageWithURL:URL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            return ;
        }
        [catImages stopAnimating];
        [catImages removeFromSuperview];
        cell.imageV.image = image;
        picture_save = image;
//        [catImages stopAnimating];
//        catImages.hidden = YES;
    }];
//        [imageDownLoad imageDownWithUrlString: [self.chaImageArr[indexPath.row] valueForKey:@"imgurl"] andResult:^(UIImage *img) {
//            cell.imageV.image = img;
//            picture_save = img;
//            [catImages stopAnimating];
//            catImages.hidden = YES;
//        }];

    
    //***************将漫画名、漫画id，章节id等写入数据库。(可改为写入到pop回来的方法里面)
#pragma -mark Name后的参数需要从上一个页面传来的章节名字的数组获取；
//    NSNumber *partid = [_sectionsArray[_Sectionindex] valueForKey:@"part_id"];
////    int currentPartnumber = [[_sectionsArray[_Sectionindex] valueForKey:@"partnumber"] intValue];
//    [SQLstoreHis addbigbookid:[self.bigbookid intValue] Bigbookname:self.bigbookname Bookid:[self.book_id intValue] Partid:partid.intValue Name:[_sectionsArray[_Sectionindex] valueForKey:@"name"] Updatemassage:self.updatemessage  AndPartnumber:(int)_Sectionindex ];
    return cell;
}

#pragma -mark触摸UISlider结束时执行的方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int page = progressSlider.value/100.0*self.chaImageArr.count;

    if(page < self.chaImageArr.count){
    collection.contentOffset = CGPointMake(page*self.view.frame.size.width, collection.contentOffset.y);
//    [collection reloadData];
    }
    if(page == self.chaImageArr.count)
    {
        collection.contentOffset = CGPointMake((page - 1)*self.view.frame.size.width, collection.contentOffset.y);
//        [collection reloadData];
    }
//   NSLog(@"触摸结束");
}

#pragma -mark点击集合视图的item执行的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"--%ld---%ld",indexPath.section,indexPath.row);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark设置每个item大小的方法
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}

#pragma -mark实现缩放的代理方法

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews   objectAtIndex:0];
}

#pragma -mark只要一滑动就会走的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int page = scrollView.contentOffset.x / self.view.frame.size.width;
//    if ((page == 0 && scrollView.contentOffset.x<0) || ((page == self.chaImageArr.count - 1) && scrollView.contentOffset.x > (page-1)*self.view.frame.size.width )) {
//        NSLog(@"滑页");
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    if ( navView.hidden == NO) {
//        [UIView animateWithDuration:0.5 animations:^{
//            bottomView.hidden = YES;
//            savePicture.hidden = YES;
//            navView.hidden = YES ;
//        }];
//    }
    
}

#pragma -mark只要结束拖拽就会走的方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

//    int page = scrollView.contentOffset.x / self.view.frame.size.width;
//    NSLog(@"%f, %f, %d", scrollView.contentOffset.x,  (page - 1)*self.view.frame.size.width, page);
    if(scrollView.contentOffset.x < 0)
    {
        swapLeft = YES;
    }
    if (scrollView.contentOffset.x > (self.chaImageArr.count-1)*self.view.frame.size.width)
    {
        swapRight = YES;
    }

}

#pragma -mark结束减速执行的方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    float  proportion = scrollView.contentOffset.x/(self.view.frame.size.width*(self.chaImageArr.count - 1));
    //改变进度条的值
    progressSlider.value = proportion*progressSlider.maximumValue;
    ComicPagesColltionControll *weak_page = self;

    //左拉刷新
    if(swapLeft)
    {
        progressSlider.value = progressSlider.maximumValue;
        
        swapLeft = NO;
        if ((_Sectionindex == _sectionsArray.count-1) && scrollView.contentOffset.x == 0) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"前面没有了哦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            progressSlider.value = progressSlider.minimumValue;
            
            [alert show];
            [alert release];
            alert = nil;
            return;
        }
        _Sectionindex++;
        ComicSectionModel *model = _sectionsArray[_Sectionindex];
        
        [DataRequest getComicPagesWithBookID:_book_id  AndPartID:model.part_id ToResult:^(NSMutableArray *arr) {
            [weak_page.chaImageArr removeAllObjects];
            scrollView.contentOffset = CGPointMake(self.view.frame.size.width*(arr.count-1), 0);
            //如果不在block中alloc一个self.chaImageArr,出了block之后将不能访问到arr的内容
            NSMutableArray *array = [arr mutableCopy];
            [array addObjectsFromArray:self.chaImageArr];
             weak_page.chaImageArr = array;
            [collection reloadData];
            
        }];
        
    }
    
    
    //右拉刷新
    if (swapRight)
    {
        progressSlider.value = progressSlider.minimumValue;
        swapRight = NO;
        NSLog(@"*********%f",scrollView.contentOffset.x);
        NSLog(@"%f",self.view.frame.size.width*(self.chaImageArr.count - 1));
        if ((_Sectionindex == 0 ) &&  scrollView.contentOffset.x == (self.view.frame.size.width*(self.chaImageArr.count - 1))) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您已经看完啦" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            progressSlider.value = progressSlider.maximumValue;
            [alert show];
            [alert release];
            alert = nil;
            return;
        }
        _Sectionindex--;
        
        ComicSectionModel *model = _sectionsArray[_Sectionindex];
        [DataRequest getComicPagesWithBookID:_book_id  AndPartID:model.part_id ToResult:^(NSMutableArray *arr) {
            [weak_page.chaImageArr removeAllObjects];
            scrollView.contentOffset = CGPointMake(0, 0);
            [weak_page.chaImageArr addObjectsFromArray:arr];
            [collection reloadData];
            
        }];
    }
    
    if (progressSlider.value > 0 && progressSlider.value < 100) {
        self.page.text = [NSString stringWithFormat:@"%d/%ld",(int)(((progressSlider.value/100))*self.chaImageArr.count) + 1,(unsigned long)self.chaImageArr.count];
    }
//    if (progressSlider.value == 0) {
//        self.page.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.chaImageArr.count];
//    }
//    if (progressSlider.value == 100) {
//        self.page.text = [NSString stringWithFormat:@"%ld/%ld",(unsigned long)self.chaImageArr.count,(unsigned long)self.chaImageArr.count];
//    }
}
#pragma -mark 点击slider触发的方法

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row == 0||indexPath.row == _chaImageArr.count-1)
        self.page.text = [NSString stringWithFormat:@"%ld/%ld",indexPath.row+1,(unsigned long)self.chaImageArr.count];
}

-(void)tapAction:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:progressSlider];
    progressSlider.value = (point.x)/(self.view.frame.size.width-40)*100;
    NSLog(@"%f",point.x);
    int page = (point.x)/(self.view.frame.size.width - 40)*(self.chaImageArr.count);
    NSLog(@"page = %d",page);
    if (page < self.chaImageArr.count) {
   
     collection.contentOffset = CGPointMake(page*self.view.frame.size.width, collection.contentOffset.y);
    }
}


#pragma -mark 进度条翻页的方法
-(void)turnToPage:(id)sender;
{
    progressSlider = (UISlider*)sender;
    int page = progressSlider.value/progressSlider.maximumValue*self.chaImageArr.count + 1;
    self.page.text = [NSString stringWithFormat:@"%d/%ld",page, self.chaImageArr.count];
}



#pragma -mark调节亮度的方法
-(void)adjustBrightness:(UISlider*)sender
{
    NSLog(@"end = %f",sender.value);
    [UIScreen mainScreen].brightness = sender.value;
     NSLog(@"now = %f",[UIScreen mainScreen].brightness);
}

#pragma -mark更新时间Label的方法
- (void)timerFunc
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    [labelTime setText:timestamp];//时间在变化的语句
    [formatter release];
}

#pragma -mark更新电量Label的方法
- (void)batteryFunc
{
    //获取电池的状态
//    UIDeviceBatteryState Batterystate = [UIDevice currentDevice].batteryState;
    //获取电池的剩余电量
    CGFloat batteryLevel = [UIDevice currentDevice].batteryLevel;
    float level = batteryLevel*100;
    [labelBattery setText:[NSString stringWithFormat:@"电量:%.0f%%",level]];
}


#pragma -mark
-(void)backAction:(id)sender
{
    [timeNow invalidate];
    [timeBattery invalidate];
    [self release];
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma -mark保存图片到本地相册的方法
-(void)savePicture
{
    UIImageWriteToSavedPhotosAlbum(picture_save, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

#pragma - 实现imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:方法
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        saveAlert = [[UIAlertView alloc] initWithTitle:@"成功保存到相册" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        //待添加计时器让aleriView自动消失
//        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector: @selector(alertViewDismissAction:)  userInfo:nil repeats:NO];
        [saveAlert show];

    }else
    {
        saveAlert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        //待添加计时器让aleriView自动消失
//        [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector: @selector(alertViewDismissAction:)  userInfo:nil repeats:NO];
        [saveAlert show];
        message = [error description];
    }
    
}

#pragma -mark提示框定时消失的方法
-(void)alertViewDismissAction:(NSTimer*)timer
{
    [saveAlert dismissWithClickedButtonIndex:0 animated:NO];
    saveAlert = NULL;
}


-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self.view bringSubviewToFront:catImages];
    [catImages startAnimating];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    //***************将漫画名、漫画id，章节id等写入数据库。(可改为写入到pop回来的方法里面)
#pragma -mark Name后的参数需要从上一个页面传来的章节名字的数组获取；
    NSNumber *partid = [_sectionsArray[_Sectionindex] valueForKey:@"part_id"];
    //    int currentPartnumber = [[_sectionsArray[_Sectionindex] valueForKey:@"partnumber"] intValue];
    [SQLstoreHis addbigbookid:[self.bigbookid intValue] Bigbookname:self.bigbookname Bookid:[self.book_id intValue] Partid:partid.intValue Name:[_sectionsArray[_Sectionindex] valueForKey:@"name"] Updatemassage:self.updatemessage  AndPartnumber:(int)_Sectionindex ];
    [DataRequest cancelAll];
}
-(void)viewDidDisappear:(BOOL)animated
{
   
}

- (void)loadView
{
    [super loadView];
    [DataRequest cancelAll];
}
@end
