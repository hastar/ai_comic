//
//  ComicSearchSecondPage.m
//  ai_comic
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSearchSecondPage.h"
#import "SearchComicModel.h"
#import "SecondPageCell.h"
#import "ComicDetailPageController.h"
#import "UIImageView+WebCache.h"
@interface ComicSearchSecondPage ()

@property (nonatomic, retain)NSMutableArray *subjectsArray;
@property (nonatomic, assign) int pageNo;

@end

@implementation ComicSearchSecondPage

-(void)dealloc
{
    [_searchName release];
    [_subjectsArray release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)loadView
{
    [super loadView];
    [DataRequest cancelAll];
}

- (NSMutableArray *)subjectsArray
{
    if (!_subjectsArray) {
        _subjectsArray = [[[[NSMutableArray alloc]init]retain]autorelease];
        __block ComicSearchSecondPage *weak_secondPage = self;
        [DataRequest searchComicWithName:self.searchName AndPageIndex:[NSNumber numberWithInt:self.pageNo] ToResult:^(NSMutableArray *array) {
            _subjectsArray = [array mutableCopy];
            [weak_secondPage.tableView reloadData];
        }];
    }
    return _subjectsArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.tableView.delegate release];
//    self.tableView.delegate = nil;
//    [self.tableView.dataSource release];
//    self.tableView.delegate = nil;
    [DataRequest cancelAll];
}

- (void)viewDidLoad {
    
    self.pageNo = 0;
    self.navigationItem.title = self.searchName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerClass:[SecondPageCell class] forCellReuseIdentifier:@"SecondPageCell"];
    //[self.tableView registerClass:[SecondPageCell class] forCellReuseIdentifier:@"SecondPageCell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.subjectsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height/667.0;
    return 130*ybounds;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // SecondPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondPageCell" forIndexPath:indexPath];
    SecondPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecondPageCell" forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[SecondPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondPageCell"];
//    }
    SearchComicModel *modle = _subjectsArray[indexPath.row];
    cell.bookName.text =  modle.name;
    cell.authorName.text = [NSString stringWithFormat:@"作者: %@", modle.author];
    cell.keyLabel.text = [NSString stringWithFormat:@"类型: %@", modle.subject_name];
    int num = 0;
    if (modle.bigbookview.intValue/10000 > 0) {
        num = modle.bigbookview.intValue/10000;
    }
    else
        num = modle.bigbookview.intValue;
    cell.bookView.text = [NSString stringWithFormat:@"人气: %d万", num];
    
    if (modle.progresstype.boolValue == YES) {
        cell.progressType.text = @"已完结";
        cell.progressType.textColor = [UIColor redColor];
    }
    else
    {
        cell.progressType.text = @"更新中";
        cell.progressType.textColor = [UIColor colorWithRed:131/255.0 green:192/255.0 blue:87/255.0 alpha:1.00f];
    }
    
    NSURL *URL = [NSURL URLWithString:modle.coverurl];
    [cell.coverImageView sd_setImageWithURL:URL placeholderImage:nil];
    
//    __block SecondPageCell *weak_cell = cell;
//    [imageDownLoad imageDownWithUrlString:modle.coverurl andResult:^(UIImage *img) {
//        weak_cell.coverImageView.image = img;
//    }];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"scorll");
    CGFloat ybounds = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"tableView = %f, scrollView = %f", scrollView.contentSize.height -  ybounds, scrollView.contentOffset.y);
    if (scrollView.contentSize.height -  ybounds>= scrollView.contentOffset.y) {
        return;
    }
    self.pageNo++;
    __block ComicSearchSecondPage *weak_page = self;

    [DataRequest searchComicWithName:self.searchName AndPageIndex:[NSNumber numberWithInt:self.pageNo] ToResult:^(NSMutableArray *array) {
        if (array.count == 0) {
            return ;
        }
        [weak_page.subjectsArray addObjectsFromArray:array];
        [weak_page.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchComicModel *modle = _subjectsArray[indexPath.row];
    ComicDetailPageController *detail = [[ComicDetailPageController alloc]init];
    detail.bigbookid =  modle.ID;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}




@end
