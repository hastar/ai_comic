//
//  RecoTabController.m
//  ai_comic
//
//  Created by lanou on 15/7/3.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "RecoTabController.h"
//#import "BoardPageViewController.h"

//#import "BoardPageViewController.h"
//#import "LoopScroll.h"
#import "BoardTableViewCell.h"
#import "LoopScrollCellTableViewCell.h"
#import "ComicSubjectSecendPage.h"
#import "ScorllModel.h"

#import "ItemModel.h"
#import "NBWaterFlowLayout.h"
#import "WaterFlowCell.h"
#import "UIImageView+WebCache.h"
#import "DataRequest.h"
#import "MJRefresh.h"
#import "ComicDetailPageController.h"

#import "MBProgressHUD.h"
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
@interface RecoTabController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegateWaterFlowLayout>
@property(nonatomic,retain)NSMutableArray *BoardArray;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign)NSInteger index;//当前的数据索引
@property(nonatomic,retain)UIAlertView *alt;
@property(nonatomic, retain)NSMutableArray *scorllArray;
@property(nonatomic,retain)UIScrollView *boardScroView;
@property(nonatomic, retain)UIView *baseView;
@property(nonatomic,retain)UIPageControl *pageC;
@property(nonatomic, retain)UILabel *boardLable;
@property(nonatomic, assign)int page;
@property(nonatomic, retain) NSTimer *boardTimer;


@property (nonatomic, retain) UICollectionView *collectionView;//声明集合视图
@property (nonatomic, retain) NSMutableArray *datasource;//用于保存需要展示的所有数据
//@property (nonatomic, assign) NSInteger index;//当前的数据索引

@property (nonatomic, retain) UIScrollView *mainScroll;
@property (nonatomic, assign) CGPoint sourcePoint;
@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) UISegmentedControl *segment;
@end

@implementation RecoTabController



-(void)dealloc
{
    [_BoardArray release];
    [_tableView release];
    [_alt release];
    [_scorllArray release];
    [_boardScroView release];
    [_baseView release];
    [_pageC release];
    [_boardLable release];
    [_boardTimer release];
    [_collectionView release];
    [_datasource release];
    [_mainScroll release];
    [_hud release];
    [_segment release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [DataRequest cancelAll];
    self.hud.hidden = YES;
}

- (void)loadView
{
    [super loadView];
    [DataRequest cancelAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainScroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _mainScroll.backgroundColor = [UIColor colorWithRed:255/256.0 green:251/256.0 blue:241/256.0 alpha:1.0];
    _mainScroll.contentSize = CGSizeMake(2 * self.view.frame.size.width, self.view.frame.size.height);
    _mainScroll.showsHorizontalScrollIndicator = NO;
    _mainScroll.showsVerticalScrollIndicator = NO;
    _mainScroll.bounces = NO;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_mainScroll];
    [_mainScroll release];
    
    [self setSegmentView];

    
    [self p_setupProgressHud];
    [self loadBoardView];
    [self loadRecomView];
}

- (void)setSegmentView
{
    self.segment = [[UISegmentedControl alloc]init];
    NSArray *array = @[@"推荐",@"榜单"];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    _segment.frame = CGRectMake(50*widths/375, 20, widths - 100*widths/375, 30*heights/667);
    _segment.tintColor = [UIColor colorWithRed:153/255.0 green:129/255.0 blue:125/255.0 alpha:1.0];
    _segment.selectedSegmentIndex = 0;
    //_segment.backgroundColor =  [UIColor colorWithRed:153/255.0 green:129/255.0 blue:125/255.0 alpha:1.0];
    _segment.layer.cornerRadius = 5;
    _segment.layer.borderWidth = 0.3;
    [self.view addSubview:_segment];
    [_segment release];
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
}

-(void)segmentAction:(UISegmentedControl*)segemnt{
    switch (segemnt.selectedSegmentIndex) {
        case 0:
            _mainScroll.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            _mainScroll.contentOffset = CGPointMake(widths, 0);
            break;
        default:
            break;
    }
}

-(void)p_setupProgressHud
{
//    self.hud = [[[MBProgressHUD alloc] initWithView:self.view]autorelease];
//    _hud.frame = self.view.bounds;
//    _hud.minSize = CGSizeMake(100, 100);
//    _hud.mode = MBProgressHUDModeCustomView;
//    [self.view addSubview:_hud];
//    [_hud show:YES];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void)loadRecomView
{
    [self.mainScroll addSubview:[self collectionView]];
    self.collectionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    //注册集合视图的cell
    [self.collectionView registerClass:[WaterFlowCell class] forCellWithReuseIdentifier:@"Cell"];
    
    
    __block RecoTabController *weak_recommen = self;
    [DataRequest recommendInterfaceWithPageno:[NSNumber numberWithInt:1] ToResult:^(NSMutableArray *arr) {
        weak_recommen.datasource =[arr mutableCopy];
        [weak_recommen.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    static int page = 1;
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        [DataRequest recommendInterfaceWithPageno:[NSNumber numberWithInt:page] ToResult:^(NSMutableArray *arr) {
            NSMutableArray *array =[arr mutableCopy];
            [weak_recommen.datasource addObjectsFromArray:array];
            page ++;
            //[self.collectionView reloadData];
        }];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(0, dispatch_get_main_queue(), ^{
            [weak_recommen.collectionView reloadData];
            
            // 结束刷新
            [weak_recommen.collectionView.footer endRefreshing];
        });
    }];
    [self.collectionView.header beginRefreshing];

}


- (void)loadBoardView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width,64, self.view.frame.size.width, self.view.frame.size.height-108) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    _tableView.delegate  = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    [self.tableView registerClass:[BoardTableViewCell class] forCellReuseIdentifier:@"BoardCell"];
    [self.mainScroll addSubview:_tableView];
    [_tableView release];
    
    __block RecoTabController *weak_one = self;
    [DataRequest boardListInterfaceWithResult:^(NSMutableArray *arr) {
        weak_one.BoardArray = [arr mutableCopy];
        [weak_one.tableView reloadData];
    }];
    
    //----------------------------------------------榜单ScroView
    self.baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height/667*160)];
    
    self.boardScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen]bounds].size.height/667*160)];
    self.boardScroView.backgroundColor = [UIColor lightGrayColor];
    //控制分页
    self.boardScroView.pagingEnabled = YES;
    //是否允许反弹
    self.boardScroView.bounces = NO;
    self.boardScroView.delegate = self;
    self.boardScroView.showsVerticalScrollIndicator = NO;
    self.boardScroView.showsHorizontalScrollIndicator = NO;
    self.boardScroView.contentOffset = CGPointMake(self.boardScroView.frame.size.width, 0);
    [self.baseView addSubview:_boardScroView];
    [_boardScroView release];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen]bounds].size.height/667*130, self.boardScroView.frame.size.width, [[UIScreen mainScreen]bounds].size.height/667*30)];
    view.backgroundColor = [UIColor redColor];
    view.alpha = 0.9;
    [self.baseView addSubview:view];
    [view release];
    
    self.boardLable = [[UILabel alloc]initWithFrame:CGRectMake(10, [[UIScreen mainScreen]bounds].size.height/667*130, [[UIScreen mainScreen]bounds].size.width/375*250, [[UIScreen mainScreen]bounds].size.height/667*30)];
    _boardLable.font = [UIFont boldSystemFontOfSize:14];
    _boardLable.textColor = [UIColor whiteColor];
    [self.baseView addSubview:_boardLable];
    [_boardLable release];
    //    [self.view addSubview:self.boardScroView];mm
    //    [self.boardScroView release];
#pragma -mark ScroView这是一个非常重要的属性
    
    [DataRequest getRecommenScrollDataToResult:^(NSMutableArray *array) {
        weak_one.scorllArray = [array mutableCopy];
        NSLog(@"%@",array);
        for (int i = 0; i<weak_one.scorllArray.count+2 ; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.boardScroView.frame.size.width*i, 0, self.boardScroView.frame.size.width, self.boardScroView.frame.size.height)];
            ScorllModel *model = nil;
            
            if (i == 0) {
                model =  weak_one.scorllArray[weak_one.scorllArray.count-1];
            }
            else if(i == array.count +1)
            {
                model = weak_one.scorllArray[0];
            }
            else
                model = weak_one.scorllArray[i-1];
            
            if (i == 1) {
                _boardLable.text = model.title;
            }
            [imageDownLoad imageDownWithUrlString:model.imageurl andResult:^(UIImage *img) {
                imageV.image = img;
            }];
            
            [self.boardScroView addSubview:imageV];
        }
        weak_one.boardScroView.contentSize = CGSizeMake(self.boardScroView.frame.size.width*(weak_one.scorllArray.count+2), self.boardScroView.frame.size.height);
    }];
    
    //-----------------------------------------分页控制UIpageC
    // self.pageC = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.boardScroView.frame.size.height-50, self.boardScroView.frame.size.width, 50)];
    self.pageC.backgroundColor = [UIColor blackColor];
    //添加
    [self.boardScroView addSubview:self.pageC];
    //控制页码
    self.pageC.numberOfPages = 5;
    //当前页
    self.pageC.currentPage = 0;
    //未选中点的颜色
    self.pageC.pageIndicatorTintColor = [UIColor darkGrayColor];
    //选中点的颜色
    self.pageC.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    //添加时间
    [self.pageC addTarget:self action:@selector(YouTouchMe:) forControlEvents:UIControlEventValueChanged];
    [self.pageC release];
    
    self.boardTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(scrollViewDoScroll:) userInfo:nil repeats:YES];
}





- (void)scrollViewDoScroll:(id)sender
{
    //NSLog(@"%@", [NSDate timeIntervalSince1970])
    if (_page == self.scorllArray.count + 1) {
        _page = 1;
        [self.boardScroView setContentOffset:CGPointMake( _page * self.boardScroView.frame.size.width, 0) animated:NO];
    }
    _page ++;
    [self.boardScroView setContentOffset:CGPointMake( _page * self.boardScroView.frame.size.width, 0) animated:YES];
    ScorllModel *model = nil;
    if (_page == self.scorllArray.count + 1) {
        model = self.scorllArray[0];
    }
    else
    {
        model = self.scorllArray[_page-1];
    }
    _boardLable.text = model.title;
}

-(void)YouTouchMe:(UIPageControl *)control
{
    //获取到第几页
    NSInteger pageNumber = control.currentPage;
    //根据偏移量让scroView滑动到指定的位置
    self.boardScroView.contentOffset = CGPointMake(self.boardScroView.frame.size.width*pageNumber, 0);
}

//只要一滑动就会走的方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainScroll) {
        if(_mainScroll.contentOffset.x < self.view.frame.size.width/2)
        {
            _segment.selectedSegmentIndex = 0;
        }
        else if(_mainScroll.contentOffset.x >= self.view.frame.size.width/2)
        {
            _segment.selectedSegmentIndex = 1;
        }
    }
}
- (void)scrollStart
{
    self.boardTimer.fireDate = [NSDate dateWithTimeIntervalSinceNow:3];
}

- (void)scrollPause
{
    self.boardTimer.fireDate = [NSDate distantFuture];
}

//开始拖拽
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.boardScroView)
        [self scrollPause];
}
//结束拖拽
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.boardScroView)
        [self scrollStart];
    

}
//开始减速
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}
//结束减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.boardScroView) {
        _page = floor(scrollView.contentOffset.x/self.boardScroView.frame.size.width);
        NSLog(@"%d", _page);
        if (_page == 0) {
            _page = (int)self.scorllArray.count;
            [scrollView setContentOffset:CGPointMake( _page * self.boardScroView.frame.size.width, 0) animated:NO];
        }
        if (_page == self.scorllArray.count + 1) {
            _page = 1;
            [scrollView setContentOffset:CGPointMake( _page * self.boardScroView.frame.size.width, 0) animated:NO];
        }
        ScorllModel *model = self.scorllArray[_page-1];
        _boardLable.text = model.title;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    return [[UIScreen mainScreen]bounds].size.height/667*160;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return [[[UIView alloc]init]autorelease];
    }
    
    return self.baseView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return self.BoardArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 1;
    }
    return [[UIScreen mainScreen] bounds].size.height/667*100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BoardTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"BoardCell" forIndexPath:indexPath];
    //从数组中拿到boardListModel对象让cell展示图片
    boardListModel *boardList = [self.BoardArray objectAtIndex:indexPath.row];
    [imageDownLoad imageDownWithUrlString:boardList.coverurl andResult:^(UIImage *img) {
        if (cell.BoardimageView) {
            cell.BoardimageView.image = img;
        }
    }];
    cell.nameLabel.text = boardList.name;
    cell.desLabel.text = boardList.descriptions;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    boardListModel *board = [self.BoardArray objectAtIndex:indexPath.row];
    ComicSubjectSecendPage *inPage = [[ComicSubjectSecendPage alloc]init];
    inPage.specialid = board.specialid;
    [self.navigationController pushViewController:inPage animated:YES];
    [inPage release];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 150;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------*/

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat x = [[UIScreen mainScreen]bounds].size.width/375.0;
        CGFloat y = [[UIScreen mainScreen]bounds].size.height/677.0;
        NBWaterFlowLayout *layout = [[NBWaterFlowLayout alloc] init];
        //移植到你的工程中只需要改变下面两行就行了
        layout.itemSize = CGSizeMake(175*x, 90*y);
        layout.numberOfColumns = 2;
        
        layout.delegate = self;
        layout.sectionInsets = UIEdgeInsetsMake(10*y, 5*x, 5*y, 5*x);
        
        //创建collectionView对象时必须为其指定layout参数，否则会出现crash
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-108) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}


//懒加载初始化数组
- (NSMutableArray *)datasource{
    if (!_datasource) {
        self.datasource = [NSMutableArray array];
    }
    return _datasource;
}

#pragma -mark一个分区有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datasource.count;
}

#pragma -mark自定义每个item的方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //创建重用队列
    WaterFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    // cell.backgroundColor = [UIColor clearColor];
    //从数组中拿到itemModel对象让cell展示图片
    ItemModel *item = [self.datasource objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[item valueForKey:@"coverurl"]];
    
    
    cell.bookName.text = item.bigbook_name;
    [cell.bookName setFont:[UIFont fontWithName: @"Helvetica"   size : 15 ]];
    cell.lastPartName.text = item.lastpartname;
    cell.lastPartName.textAlignment = NSTextAlignmentRight;
    [cell.lastPartName setFont:[UIFont fontWithName:@"Marker Felt" size:12]];
    
    
    
    //使用SDWebImage第三方，直接利用url请求回来图片使用
    cell.imageView.image = nil;
    [cell.imageView sd_setImageWithURL:url placeholderImage:nil];
    return cell;
}
#pragma mark -FootView

#pragma -mark返回每个item的高度的方法<UICollectionViewDelegateWaterFlowLayout>协议方法
- (CGFloat)collectionView:(UICollectionView *)collectionView waterFlowLayout:(NBWaterFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //把宽度先取出来
    CGFloat width = layout.itemSize.width;
    //根据索引把对应的图片取出来
    ItemModel *item = self.datasource[indexPath.item];
    //根据请求回来的宽高比，算出在集合视图上的高
    //CGFloat height = width * item.imageHeight / item.imageWidth;
    CGFloat height = width * item.cover_height / item.cover_width;
    return height;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemModel *model = _datasource[indexPath.row];
    ComicDetailPageController *page = [[ComicDetailPageController alloc]init];
    page.bigbookid = model.bigbook_id;
    [self.navigationController pushViewController:page animated:YES];
    [page release];
}



@end

