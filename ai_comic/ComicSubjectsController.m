//
//  ComicSubjectsController.m
//  ai_comic
//
//  Created by lanou on 15/6/26.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSubjectsController.h"
#import "ComicSearchBarView.h"
#import "SearchComicModel.h"
#import "ComicSubjectModel.h"
#import "ComicSubjectsViewCell.h"
#import "ComicSubjectSecendPage.h"
#import "ComicSearchSecondPage.h"
#import "UIImageView+WebCache.h"
@interface ComicSubjectsController ()


@property(nonatomic, retain)ComicSearchBarView *searchBar;
@property(nonatomic, retain)UICollectionView *colltionView;
@property(nonatomic, retain)UITableView *tableV;
@property(nonatomic, retain)UIView *coverView;


@property(nonatomic, retain)NSMutableArray *subjectsArray;
@property(nonatomic, retain)NSMutableArray *searchResults;


@end

@implementation ComicSubjectsController
-(void)dealloc
{
    [_searchBar release];
    [_colltionView release];
    [_tableV release];
    [_coverView release];
    [_subjectsArray release];
    [_searchResults release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.searchBar.hidden = NO;
    [self.navigationController.view bringSubviewToFront:self.searchBar];
    [self.navigationController.view bringSubviewToFront:_tableV];
    self.tabBarController.tabBar.hidden = NO;
    //self.navigationController.navigationBar.alpha = 0.001;
}

- (void)viewWillDisappear:(BOOL)animated
{
   // [DataRequest cancelAll];
}

- (void)loadView
{
    [super loadView];
    [DataRequest cancelAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =  [UIColor whiteColor];
    //self.navigationController.navigationBar.hidden = YES;
    CGFloat xbounds = [[UIScreen mainScreen] bounds].size.width/375.0;
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
    ComicSubjectsController *weak_controller = self;

    
    
    self.searchBar = [[ComicSearchBarView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    [_searchBar.button addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    _searchBar.searchBar.delegate = self;
    _searchBar.searchBar.placeholder = @"漫画名 | 作者   (´･ω･｀)";
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar release];
    
    //***************UICollectionView布局的类************
    //1、创建一个布局类的对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    //2、每个item的大小（不规则不瀑流不会直接使用该属性来设置大小）
    flowLayout.itemSize = CGSizeMake(self.view.frame.size.width/3-20 , self.view.frame.size.width/3 );
    //3、设置最小列间距
    flowLayout.minimumInteritemSpacing = 10;
    //4、设置最小行间距（必须吧行间距设置为0才可以是实现画页无缝连接）
    flowLayout.minimumLineSpacing = 10;
    //5、设置滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //6、设置外部边距的属性(上，左，下，右)
    flowLayout.sectionInset = UIEdgeInsetsMake(10, flowLayout.minimumLineSpacing, 30, flowLayout.minimumLineSpacing);

    
    //**************UIcollectionView的相关设置**********
    //创建一个集合视图
    self.colltionView =[[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.colltionView.delegate=self;
    self.colltionView.dataSource = self;
    self.colltionView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
    //控制分页
//    self.colltionView.pagingEnabled = YES;
    //是否允许反弹
    //collection.bounces = NO;
    
    //隐藏滚动条
    self.colltionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.colltionView];
    [flowLayout release];
    [_colltionView release];
    

    //3**********注册一个item(cell)**********
    [self.colltionView registerClass:[ComicSubjectsViewCell class] forCellWithReuseIdentifier:@"SubjectsCell"];
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchResultCell"];
    
    
#warning 数据申请
    [DataRequest getComicSubjectsToResult:^(NSMutableArray *array) {
        weak_controller.subjectsArray = array;
        if (array) {
            [weak_controller.colltionView reloadData];
        }
        
    }];
    
    
    
     //**********      覆盖视图       **********
    
    
    
    self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //_coverView.backgroundColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:0.3];
    _coverView.backgroundColor = [UIColor blackColor];
    _coverView.alpha = 0.3;
    _coverView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSearch)];
    [_coverView addGestureRecognizer:tap];
    [self.view addSubview:_coverView];
    [tap release];
    [_coverView release];
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(_searchBar.searchBar.frame.origin.x+8, 53, XSIZETOFIT(295), 0) style:UITableViewStylePlain];
    _tableV.scrollEnabled = NO;
    _tableV.delegate = self;
    _tableV.dataSource = self;
    _tableV.hidden = YES;
    [self.navigationController.view addSubview:_tableV];
    [_tableV release];
    

    // Do any additional setup after loading the view.
}

/**********************************  分类部分  *************************************/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _subjectsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComicSubjectsViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SubjectsCell" forIndexPath:indexPath];
    ComicSubjectModel *subject = _subjectsArray[indexPath.row];
    
    NSURL *URL = [NSURL URLWithString:subject.cover3url];
    [cell.coverImageView sd_setImageWithURL:URL placeholderImage:nil];
    
//    __block ComicSubjectsViewCell *weak_cell = cell;
//    [imageDownLoad imageDownWithUrlString:subject.cover3url andResult:^(UIImage *img) {
//        weak_cell.coverImageView.image = img;
//    }];
    cell.nameLabel.text = subject.name;
    //cell.backgroundColor = [UIColor redColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushSubjectsTableViewAtIndex:indexPath.row];
}




/**********************************  搜索部分  *************************************/

#pragma -mark  tableView的代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultCell"];
    }
    SearchComicModel *modle = _searchResults[indexPath.row];
    cell.textLabel.text = modle.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchComicModel *modle = _searchResults[indexPath.row];
    self.searchBar.searchBar.text = modle.name;
    [self searchBarSearchButtonClicked:self.searchBar.searchBar];
    NSLog(@"select");
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.coverView.hidden = NO;
    return YES;
}



#pragma -mark    searchBar代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0 || searchText == nil) {
        [self cancelSearch];
        [searchBar becomeFirstResponder];
        return;
    }
    ComicSubjectsController *weak_controller = self;
    [DataRequest searchComicWithName:searchText AndPageIndex:@0 ToResult:^(NSMutableArray *array) {
        weak_controller.searchResults = nil;
        weak_controller.searchResults = [array mutableCopy];
        if (weak_controller.searchResults.count != 0) {
            weak_controller.tableV.frame = CGRectMake(_tableV.frame.origin.x, _tableV.frame.origin.y, _tableV.frame.size.width, _searchResults.count * 30+11);
            [weak_controller.tableV reloadData];
            weak_controller.coverView.hidden = NO;
            weak_controller.tableV.hidden = NO;
        }
        else
        {
            weak_controller.tableV.hidden = YES;
        }
    }];
}


#warning 搜索跳转函数
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked:");
    [self cancelSearch];
    ComicSearchSecondPage *search = [[ComicSearchSecondPage alloc]init];
    search.searchName = searchBar.text;
    self.searchBar.hidden = YES;
    [self.navigationController pushViewController:search animated:YES];
    [search release];
}

#pragma -mark cancelSearch
- (void)cancelSearch
{
    self.coverView.hidden = YES;
    self.tableV.hidden = YES;
    [self.searchBar.searchBar resignFirstResponder];
}


#warning 分类跳转函数
- (void)pushSubjectsTableViewAtIndex:(NSInteger)index
{
    ComicSubjectModel *model = _subjectsArray[index];
    ComicSubjectSecendPage *second = [[ComicSubjectSecendPage alloc]init];
    second.subject = model.subjectid;
    [self.navigationController pushViewController:second animated:YES];
    [second release];
    self.searchBar.hidden = YES;
    //NSLog(@"pushSubjectsTableView");
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
