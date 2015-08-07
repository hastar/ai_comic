//
//  HisAndColViewController.m
//  ai_comic
//
//  Created by lanou on 15/6/30.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
#define grayWhite [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]
#import "HisAndColViewController.h"
#import "historyView.h"
#import "collectionView.h"
#import "HisAndColCell.h"
#import "dataModel.h"
#import "SQLStore.h"
#import "SQLstoreHis.h"
#import "loadLocalImage.h"
#import "ComicDetailPageController.h"
#import "ComicPagesColltionControll.h"
@interface HisAndColViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIAlertView *hisAlert;
    UIAlertView *colAlert;
    UIAlertView *singleDeleteAlert;
    CGPoint point;
}

@property(nonatomic,retain)UIScrollView *myScrollView;
@property(nonatomic,retain)historyView *historyView;
@property(nonatomic,retain)collectionView *collectionView;
@property(nonatomic,retain)UISegmentedControl *segment;
@property(nonatomic,retain)NSIndexPath  *indexPath;
@property(nonatomic,retain)UIButton *clearButton;


@end

@implementation HisAndColViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //防止scrollview翻页时抖动
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBarHidden = YES;
    
    
   
    
    //创建一个segmentControl
    self.segment = [[UISegmentedControl alloc]init];
    NSArray *array = @[@"历史",@"收藏"];
    self.segment = [[UISegmentedControl alloc] initWithItems:array];
    _segment.frame = CGRectMake(50*widths/375, 20, widths - 100*widths/375, 30*heights/667);
    _segment.tintColor = [UIColor colorWithRed:153/255.0 green:129/255.0 blue:125/255.0 alpha:1.0];
    _segment.selectedSegmentIndex = 0;
    //_segment.backgroundColor = [UIColor colorWithRed:153/255.0 green:129/255.0 blue:125/255.0 alpha:1.0];;
    _segment.layer.cornerRadius = 5;
    _segment.layer.borderWidth = 0.3;
    [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    //创建一个scrollView
    self.myScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myScrollView];
    _myScrollView.delegate = self;
    
    //可滚动区域
    _myScrollView.contentSize = CGSizeMake(widths*2, heights);
    //隐藏滚动条
    _myScrollView.showsHorizontalScrollIndicator = NO;
    
//    self.myScrollView.backgroundColor = [UIColor colorWithRed:70/255.0 green:137/255.0 blue:151/255.0 alpha:1.0];
    self.historyView = [[historyView alloc] initWithFrame:CGRectMake(0, 64, widths, heights - 40)];
    self.collectionView = [[collectionView alloc] initWithFrame:CGRectMake(widths,64, widths, heights - 40)];

    //指定代理
    self.historyView.myTabView.delegate = self;
    self.historyView.myTabView.dataSource = self;
    
    self.collectionView.myTabView.delegate = self;
    self.collectionView.myTabView.dataSource = self;
    
    self.historyView.myTabView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
    self.collectionView.myTabView.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:247/255.0 alpha:1.0];
    //往scrollView上加载历史、收藏的view
    [_myScrollView addSubview:_historyView];
    [_myScrollView addSubview:_collectionView];
    
    
    //添加删除按钮
    self.clearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clearButton.frame = CGRectMake(340*widths/375, 20, 30*widths/375, 30*heights/667);
    [self.clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_clearButton setTitle:nil forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widths, 64)];
    [view addSubview:_segment];
    [view addSubview:_clearButton];
    view.backgroundColor = [UIColor colorWithRed:254/255.0 green:250/255.0 blue:240/255.0 alpha:1.0];

    //控制分页
    _myScrollView.pagingEnabled = YES;
    [self.view addSubview:_myScrollView];
    [self.view addSubview:view];
//    [self.view addSubview:_segment];
//    [self.view addSubview:self.clearButton];
}

#pragma -mark点击segment触发的方法
-(void)segmentAction:(UISegmentedControl*)segemnt{
    switch (segemnt.selectedSegmentIndex) {
        case 0:
            _myScrollView.contentOffset = CGPointMake(0, 0);
            break;
        case 1:
            _myScrollView.contentOffset = CGPointMake(widths, 0);
            break;
        default:
            break;
    }
}


#pragma -mark 滑动停止触发的方法；
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_myScrollView.contentOffset.x < self.view.frame.size.width/2)
    {
        _segment.selectedSegmentIndex = 0;
    }
    else if(_myScrollView.contentOffset.x >= self.view.frame.size.width/2)
    {
        _segment.selectedSegmentIndex = 1;
    }
}

#pragma -mark UITableView相关的代理方法

#pragma -mark重用方法
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.historyView.myTabView){
        static NSString* cellID = @"hisCell";
        //2、在重用队列里获取里面的单元格
        HisAndColCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //3、判断单元格是否为空，为空则创建
        if (!cell ) {
            cell = [[HisAndColCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
         cell.continueButton.hidden = NO;
        //给续看按钮关联方法
        [cell.continueButton addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.continueButton.tag = 10000 + indexPath.row;
        //从沙盒、数据库中获取数据
        dataModel *model = [[dataModel alloc] init];
        
        if (self.historyArr.count != 0) {
            
            model = self.historyArr[indexPath.row];
            //沙盒读取图片
            cell.posterView.image = [loadLocalImage loadLocalImage:[NSString stringWithFormat:@"%d.png",model.bigbookid]];
            cell.titleLable.text = model.bigbook_name;
//            cell.recordLable.text = model.name;
            cell.recordLable.text = [NSString stringWithFormat:@"看到：%@",model.name];
//            cell.lastChapterLable.text = model.updatemessage;
             cell.lastChapterLable.text = [NSString stringWithFormat:@"最新：%@", model.updatemessage];
        }
        //添加手势
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressAction:)];
        [cell addGestureRecognizer:press];
        return cell;
    }
    else{
        static NSString* cellID = @"colCell";
        //2、在重用队列里获取里面的单元格
        HisAndColCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //3、判断单元格是否为空，为空则创建
        if (!cell ) {
            cell = [[HisAndColCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        dataModel *model = self.collectionArr[indexPath.row];
        //从沙盒、数据库中获取数据
        if (self.collectionArr.count != 0) {
            //沙盒读取图片
            cell.posterView.image = [loadLocalImage loadLocalImage:[NSString stringWithFormat:@"%d.png",model.bigbookid]];
            cell.titleLable.text =model.bigbook_name;
            for (dataModel *Mol in self.historyArr) {
                if ([Mol.bigbook_name isEqualToString:model.bigbook_name]) {
                cell.recordLable.text = [NSString stringWithFormat:@"看到：%@",Mol.name];
                }
            }
            if(cell.recordLable.text == nil){
            cell.recordLable.text = @"未看";
            }
//            cell.lastChapterLable.text = model.updatemessage;
            cell.lastChapterLable.text = [NSString stringWithFormat:@"最新：%@", model.updatemessage];

        }
        
        //添加手势
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressAction:)];
        [cell addGestureRecognizer:press];
        cell.continueButton.hidden = YES;
        return cell;
    }
}


#pragma -mark 设置分区内的单元格个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.historyView.myTabView) {
        return self.historyArr.count;
    }
    else
    {
        return self.collectionArr.count;
    }
}

#pragma -mark设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130*heights/667;
}

#pragma -mark选中单元格时执行的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.historyView.myTabView){
        ComicDetailPageController *detailPage = [[ComicDetailPageController alloc] init];
        if (self.historyArr.count != 0) {
            NSNumber *number = [self.historyArr[indexPath.row] valueForKey:@"bigbookid"];
            detailPage.bigbookid = number;
        }
        
        [self.navigationController pushViewController:detailPage animated:YES];
        
    }
    
    if (tableView == self.collectionView.myTabView){
        ComicDetailPageController *detailPage = [[ComicDetailPageController alloc] init];
        if (self.collectionArr.count != 0) {
            NSNumber *number = [self.collectionArr[indexPath.row] valueForKey:@"bigbookid"];
            detailPage.bigbookid = number;
        }
        
        [self.navigationController pushViewController:detailPage animated:YES];
    }
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma -mark 手势触发的方法

-(void)pressAction:(UILongPressGestureRecognizer *)sender
{
    
    if (sender.state  == UIGestureRecognizerStateBegan) {
    HisAndColCell *cell = (HisAndColCell*)sender.view;
         point = [sender locationInView:self.myScrollView];
        if (point.x < widths) {
            self.indexPath = [self.historyView.myTabView indexPathForCell:(HisAndColCell*)sender.view];
        }
        else
        {
             self.indexPath = [self.collectionView.myTabView indexPathForCell:(HisAndColCell*)sender.view];
        }
           NSLog(@"row2 = %ld",self.indexPath.row);
    NSString *bookNme = cell.titleLable.text;
   singleDeleteAlert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定把%@从书架删除吗？",bookNme] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alertView.delegate = self;
    [singleDeleteAlert show];
    }

    
}



#pragma -mark点击alertView上得按钮触发的方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    NSLog(@"indexPath = %ld",self.indexPath.row);
    
    if(buttonIndex == 1 && point.x < widths && singleDeleteAlert == alertView)
    {
        int bigbookid = [[self.historyArr[self.indexPath.row] valueForKey:@"bigbookid"] intValue];

        [self.historyArr removeObjectAtIndex:self.indexPath.row];
        [SQLstoreHis deleteBookByBigbookid:bigbookid];

        //编辑UI
        [self.historyView.myTabView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.historyView.myTabView reloadData];
        
    }
    //收藏页面
    if (buttonIndex == 1 && point.x > widths  && singleDeleteAlert == alertView)
    {
         NSLog(@"count = %ld",self.collectionArr.count);
        
        //删除数据源
           int bigbookid = [[self.collectionArr[self.indexPath.row] valueForKey:@"bigbookid"] intValue];
        [SQLStore deleteBookByBigbookid:bigbookid];
         [self.collectionArr removeObjectAtIndex:self.indexPath.row];

        //编辑UI
        //???????????
       [self.collectionView.myTabView deleteRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.collectionView.myTabView reloadData];
    }
   
#pragma -mark确认是否全部删除
    if(alertView == hisAlert && buttonIndex == 1)
    {
        
        //删除数据源
        [SQLstoreHis deleteAllBooks];
        [self.historyArr removeAllObjects];
        
        //编辑UI
         [self.historyView.myTabView reloadData];

    }
    
    if(alertView == colAlert && buttonIndex == 1)
    {
        //删除数据源
        [SQLStore deleteAllBooks];
        [self.collectionArr removeAllObjects];
        
        //编辑UI
        [self.collectionView.myTabView reloadData];
    }
    
}







#pragma -mark点击"续看"按钮触发的方法
-(void)continueAction:(UIButton*)sender
{
//    NSIndexPath *indexPath = [self.historyView.myTabView indexPathForCell:(HisAndColCell*)[sender superview]];
    if (self.historyArr.count != 0) {
        ComicPagesColltionControll *page = [[ComicPagesColltionControll alloc] init];
        page.book_id = [self.historyArr[sender.tag - 10000] valueForKey:@"book_id"];
        page.partid = [self.historyArr[sender.tag - 10000] valueForKey:@"part_id"];
        page.bigbookid = [self.historyArr[sender.tag - 10000] valueForKey:@"bigbookid"];
        page.bigbookname = [self.historyArr[sender.tag - 10000] valueForKey:@"bigbook_name"];
        NSNumber *number =  [self.historyArr[sender.tag - 10000] valueForKey:@"partnumber"];
        page.Sectionindex = number.integerValue;
        [self.navigationController pushViewController:page animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.historyArr = [[NSMutableArray alloc] initWithArray:[SQLstoreHis findBook]];
    self.collectionArr = [[NSMutableArray alloc] initWithArray:[SQLStore findBook]];
    [self.historyView.myTabView reloadData];
    [self.collectionView.myTabView reloadData];
}

#pragma -mark点击删除按钮
-(void)clearAction
{
    if (_segment.selectedSegmentIndex == 0) {
        hisAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除全部历史记录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [hisAlert show];
    }
    else
    {
        colAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除全部收藏？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [colAlert show];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
