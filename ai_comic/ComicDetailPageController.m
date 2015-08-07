//
//  ComicDetailPageController.m
//  ai_comic
//
//  Created by lanou on 15/6/23.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicDetailPageController.h"
#import "DataRequest.h"
#import "imageDownLoad.h"
#import "ComicDetailModel.h"
#import "ComicDetailViewCell.h"
#import "ComicDetailModel.h"
#import "ComicSectionModel.h"
#import "SectionsScrollView.h"
#import "ComicSearchSecondPage.h"
#import "ComicPagesColltionControll.h"
#import "SQLStore.h"
#import "dataModel.h"
#import "SQLstoreHis.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@interface ComicDetailPageController ()
{
    UIAlertView *colAlertView;
}
@property (nonatomic, retain) ComicDetailModel *detailModel;
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, assign) BOOL isSectionShow;

@property (nonatomic,retain)NSNumber *partNumber;
@property (nonatomic,retain)NSString *name;

@property (nonatomic, retain)MBProgressHUD *hud;
@end

@implementation ComicDetailPageController

-(void)dealloc
{
    [_bigbookid release];
    [_detailModel release];
    [_sectionsArray release];
    [_partNumber release];
    [_name release];
    [_hud release];
    [super dealloc];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.hud hide:YES];
 //   [self release];
    self.tabBarController.tabBar.hidden = NO;
    [DataRequest cancelAll];
}

//- (void)loadView
//{
//    [super loadView];
//}

-(void)p_setupProgressHud
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    _hud.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 108);
    _hud.minSize = CGSizeMake(100, 100);
    _hud.mode = MBProgressHUDModeCustomView;
    [self.navigationController.view addSubview:_hud];
    [_hud release];
    [_hud show:YES];
}

//- (NSMutableArray *)sectionsArray
//{
//    if (!_sectionsArray) {
//        __block ComicDetailPageController *weak_CDPC = self;
//        [DataRequest getComicDetailWithBigBookID:self.bigbookid ToResult:^(NSMutableArray *detailArray) {
//            weak_CDPC.detailModel = detailArray[0] ;
//            [DataRequest getComicSectionsWithBookID:weak_CDPC.detailModel.book_id ToResult:^(NSMutableArray *requestArray) {
//                //            NSLog(@"--------------------------------%ld",[DataRequest dataHandleArray].count);
//                //            if ([DataRequest dataHandleArray].count < 2) {
//                //                return ;
//                //            }
//                weak_CDPC.sectionsArray = [requestArray mutableCopy];
//                [weak_CDPC.tableView reloadData];
//                //            [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [weak_CDPC.hud hide:YES];
//            }];
//        }];
//    }
//    return _sectionsArray;
//}

- (ComicDetailModel *)detailModel
{
    if (!_detailModel) {
//        _detailModel = [[[[ComicDetailModel alloc]init] retain] autorelease];
        __block ComicDetailPageController *weak_CDPC = self;
        [DataRequest getComicDetailWithBigBookID:self.bigbookid ToResult:^(NSMutableArray *detailArray) {
             _detailModel = [detailArray[0] retain];
            [DataRequest getComicSectionsWithBookID:weak_CDPC.detailModel.book_id ToResult:^(NSMutableArray *requestArray) {
                //            NSLog(@"--------------------------------%ld",[DataRequest dataHandleArray].count);
                //            if ([DataRequest dataHandleArray].count < 2) {
                //                return ;
                //            }
                weak_CDPC.sectionsArray = [requestArray mutableCopy];
                [weak_CDPC.sectionsArray release];
                [weak_CDPC.tableView reloadData];
                //            [MBProgressHUD hideHUDForView:self.view animated:YES];
                [weak_CDPC.hud hide:YES];
            }];
        }];
    }
    return _detailModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;
    NSLog(@"%@",self.bigbookid);
        NSLog(@"%ld", self.retainCount);

#pragma -小菊花开启
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self p_setupProgressHud];

    
    [self.tableView registerClass:[ComicDetailViewCell class] forCellReuseIdentifier:@"ComicDetailCell"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
     
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ComicDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComicDetailCell"];
    [self setDataToCell:cell];
        NSLog(@"%ld", self.retainCount);
#pragma -mark图片保存到沙盒中,已经写在setDataTocell 里面(修改:Lee)

    
    //继续阅读和加入收藏按钮触发的方法
    //加入收藏
    [cell.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    //继续阅读
    [cell.continueButton addTarget:self action:@selector(continueAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)setDataToCell:(ComicDetailViewCell *)cell
{
    //cell.sectionButton.backgroundColor = [UIColor yellowColor];
    //cell.backgroundColor = [UIColor grayColor];
    
    cell.delegate = self;
    cell.scrollView.delegate = self;
        NSLog(@"%ld", self.retainCount);
    cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1.0];
    if (self.detailModel == nil) {
        return;
    }
//    if ([self.name isEqualToString:@"未看"]) {
//        [cell.continueButton setTitle:@"开始阅读" forState:UIControlStateNormal];
//    }

    cell.titleLabel.text = _detailModel.bigbook_name;
    cell.comicDetailButton.label.text = _detailModel.bigbook_brief;
    
    NSAttributedString *authorTitle = [[NSAttributedString alloc]initWithString:_detailModel.bigbook_author attributes:@{ NSUnderlineStyleAttributeName : @1}];
    [cell.authorButton setAttributedTitle:authorTitle forState:UIControlStateNormal];
    //作者名不能重复push
    for (UIViewController *view in  self.navigationController.viewControllers) {
        if ([view.navigationItem.title isEqualToString:cell.authorButton.titleLabel.text]) {
            cell.authorButton.userInteractionEnabled = NO;
            [cell.authorButton setTintColor:[UIColor blackColor]];
            break;
        }
    }
    if ([_detailModel.source_name isEqualToString:@"漫画岛精品"]) {
        cell.sectionButton.sourceLabel.text = @"来源：漫画岛";
    }
    
    cell.sectionButton.currentSection.text = _detailModel.updatemessage;
    cell.sectionButton.updateTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@", _detailModel.updatedate];
    [cell.sectionButton addTarget:self action:@selector(doShowOutSections:) forControlEvents:UIControlEventTouchUpInside];
//    NSURL *URL = [NSURL URLWithString:_detailModel.coverurl];
//    [cell.coverImageView sd_setImageWithURL:URL placeholderImage:[UIImage new]];
    __block UIImageView *coverView = cell.coverImageView;
    [imageDownLoad imageDownWithUrlString:_detailModel.coverurl andResult:^(UIImage *img) {
        coverView.image = img;
        
        //将图片保存到沙盒中
#pragma -mark图片保存到沙盒中(修改:Lee)
        NSString *libPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSString *imageName = [NSString stringWithFormat:@"%@.png",self.bigbookid];
        NSString *fileName = [libPath stringByAppendingPathComponent:imageName];
        
        //使用fileManager在该路径下创建一个文件(系统单例)
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:fileName])
        {
            //NSLog(@"文件已经存在,可以直接使用");
        }
        else
        {
            //若果文件名不存在，则将图片保存到沙盒；
            [fm createFileAtPath:fileName contents:nil attributes:nil];
            NSData *imageData = UIImagePNGRepresentation(cell.coverImageView.image);
            [imageData writeToFile:fileName atomically:YES];
        }

    }];
}

/************        点击作者按钮        **********/
- (void)doClickAuthorButton: (id) sender{
    UIButton *button = sender;
    ComicSearchSecondPage *second = [[ComicSearchSecondPage alloc]init];
    second.searchName = button.titleLabel.text;
    [self.navigationController pushViewController:second animated:YES];
    [second release];
}

/************        点击章节按钮        **********/
- (void)doShowOutSections:(id)sender
{
    UIButton *button = sender;
    ComicDetailViewCell *cell = button.superview;
//    cell.scrollView.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0];
    if (!_isSectionShow) {
        if (cell.scrollView.isSetOut == NO) {
            [cell.scrollView creatButtonBySectionArray:_sectionsArray];
//            cell.scrollView.isSetOut = YES;
        }
        [cell.scrollView setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height, button.frame.size.width, [[UIScreen mainScreen]bounds].size.height/667*320)];
        _isSectionShow = YES;
    }
    else
    {
        [cell.scrollView setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y + button.frame.size.height, button.frame.size.width, 0)];
        _isSectionShow = NO;
    }

}




/************        点击加入收藏按钮        **********/
//-(void)collectAction:(id)sender
//{
//    NSLog(@"%@",self.bigbookid);
//    [SQLStore addbigbookid:self.bigbookid.intValue Bigbookname:_detailModel.bigbook_name Bookid:_detailModel.book_id.intValue Partid:_detailModel.currentPartid.intValue Name:self.name Updatemassage:_detailModel.updatemessage Coverurl:_detailModel.coverurl AndPartnumber:self.partNumber.intValue];
//   
//}


/************        点击继续阅读按钮      **********/
-(void)continueAction:(id)sender
{
    
    ComicPagesColltionControll *VC = [[ComicPagesColltionControll alloc]init];
    VC.sectionsArray = self.sectionsArray;
    VC.book_id = _detailModel.book_id;
    VC.bigbookid = self.bigbookid;
    VC.bigbookname =_detailModel.bigbook_name;
    VC.updatemessage = _detailModel.updatemessage;
    VC.Sectionindex =  self.partNumber.integerValue;
    NSLog(@"*******%ld",(long)self.partNumber.integerValue);
    
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
    
}

- (void)kanManHua:(id)sender
{
    UIButton *button = sender;
    ComicPagesColltionControll *VC = [[ComicPagesColltionControll alloc]init];
    VC.sectionsArray = self.sectionsArray;
    VC.Sectionindex = button.tag;
    VC.book_id = _detailModel.book_id;
    VC.bigbookid = self.bigbookid;
    VC.bigbookname =_detailModel.bigbook_name;
    VC.updatemessage = _detailModel.updatemessage;
    [self.navigationController pushViewController:VC animated:YES];
    [VC release];
}


/************        点击加入收藏按钮        **********/
- (void)collectAction:(id)sender
{
    NSMutableArray *arr = [SQLStore findBook];
    for (dataModel *model in arr) {
        if ([model.bigbook_name isEqual: _detailModel.bigbook_name]) {
            colAlertView = [[UIAlertView alloc] initWithTitle:@"已收藏" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            //待添加计时器让aleriView自动消失
            [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector: @selector(alertViewDismissAction:)  userInfo:nil repeats:NO];
            [colAlertView show];
            return;
        }
    }
    [SQLStore addbigbookid:self.bigbookid.intValue Bigbookname:_detailModel.bigbook_name Bookid:_detailModel.book_id.intValue Partid:_detailModel.currentPartid.intValue Name:self.name Updatemassage:_detailModel.updatemessage Coverurl:_detailModel.coverurl AndPartnumber:self.partNumber.intValue];
    colAlertView = [[UIAlertView alloc] initWithTitle:@"收藏成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    //待添加计时器让aleriView自动消失
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector: @selector(alertViewDismissAction:)  userInfo:nil repeats:NO];
    [colAlertView show];
}

#pragma -mark提示框定时消失的方法
-(void)alertViewDismissAction:(NSTimer*)timer
{
    [colAlertView dismissWithClickedButtonIndex:0 animated:NO];
    colAlertView = NULL;
}


#pragma -mark在视图将要出现时获取currentPartid
-(void)viewWillAppear:(BOOL)animated
{
//    self.detailModel = [[ComicDetailModel alloc] init];
        NSLog(@"%ld", self.retainCount);
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[SQLstoreHis findBook]];
    NSLog(@"count = %ld",arr.count);
    self.name = @"未看";
    //先从数据库中获取章节id
    for (dataModel *model in arr)
    {   //这里的bigbookid应该从上一个页面获取
        if ([NSNumber numberWithInt:model.bigbookid] == self.bigbookid) {
            //这里的bigbookid应该从上一个一面获取
            [_detailModel setValue:[NSNumber numberWithInt:model.part_id] forKey:@"currentPartid"];
            self.partNumber = [NSNumber numberWithInt: model.partnumber];
            if (model.name != nil) {
                NSLog(@"model.name = %@",model.name);
                self.name = model.name;
            }
        }
    }
    //若章节id为空，则设置为0
    if (_detailModel.currentPartid == nil){
        _detailModel.currentPartid = 0;
    }
    [arr release];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
