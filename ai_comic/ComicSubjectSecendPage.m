//
//  ComicSubjectSecendPage.m
//  ai_comic
//
//  Created by lanou on 15/6/27.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicSubjectSecendPage.h"
#import "SecondPageCell.h"
#import "DataRequest.h"
#import "specialBoardModel.h"
#import "imageDownLoad.h"
#import "ComicDetailPageController.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
@interface ComicSubjectSecendPage ()

@property (nonatomic, retain)NSMutableArray *subjectsArray;
@property (nonatomic, assign) int pageNo;
@property (nonatomic, retain) MBProgressHUD *hud;

@end

@implementation ComicSubjectSecendPage

-(void)dealloc
{
    [_subject release];
    [_subjectsArray release];
    [_hud release];
    [super dealloc];
}

-(void)p_setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeCustomView;
    [self.navigationController.view addSubview:_hud];
    [_hud release];
    [_hud show:YES];
}

- (NSMutableArray *)subjectsArray
{
    
    if (!_subjectsArray) {
         _subjectsArray = [[[[NSMutableArray alloc]init]retain]autorelease];
        __block ComicSubjectSecendPage *weak_secondPage = self;
        if (_subject) {
            [DataRequest getComicSubjects:self.subject WithPageNo: [NSNumber numberWithInt:_pageNo] ToResult:^(NSMutableArray *array) {
                if (weak_secondPage!=nil && array.count!=0) {
                     _subjectsArray = [array mutableCopy];
                    [weak_secondPage.tableView reloadData];
                }
                [weak_secondPage.hud hide:YES];
            }];
        }
        else if(_specialid)
        {
            [DataRequest specialBoardInterfaceWithPageno:[NSNumber numberWithInt:_pageNo]  AndID:_specialid ToResult:^(NSMutableArray *array) {
                if (weak_secondPage!=nil && array.count!=0) {
                     _subjectsArray = [array mutableCopy];
                    [weak_secondPage.tableView reloadData];
                }
                [weak_secondPage.hud hide:YES];
            }];
        }
    }
    return [[_subjectsArray retain] autorelease];
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [DataRequest cancelAll];
    [self.hud hide:YES];
}

- (void)loadView
{
    [super loadView];
    [DataRequest cancelAll];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.pageNo = 0;
    [self p_setupProgressHud];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.tableView registerClass:[SecondPageCell class] forCellReuseIdentifier:@"SecondPageCell"];
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
    specialBoardModel *modle = _subjectsArray[indexPath.row];
    cell.bookName.text =  modle.bigbook_name;
    cell.authorName.text = [NSString stringWithFormat:@"作者: %@", modle.bigbook_author];
    cell.keyLabel.text = [NSString stringWithFormat:@"类型: %@", modle.key_name];
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
    __block ComicSubjectSecendPage *weak_page = self;
    if (_subject) {
        [DataRequest getComicSubjects:_subject WithPageNo: [NSNumber numberWithInt:_pageNo] ToResult:^(NSMutableArray *array) {
            [weak_page.subjectsArray addObjectsFromArray:array];
            [weak_page.tableView reloadData];
        }];
    }
    else if(_specialid)
    {
        [DataRequest specialBoardInterfaceWithPageno:[NSNumber numberWithInt:_pageNo] AndID:_specialid ToResult:^(NSMutableArray *array) {
            [weak_page.subjectsArray addObjectsFromArray:array];
            [weak_page.tableView reloadData];
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    specialBoardModel *modle = _subjectsArray[indexPath.row];
    ComicDetailPageController *detail = [[ComicDetailPageController alloc]init];
    detail.bigbookid =  modle.bigbook_id;
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];

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
