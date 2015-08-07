//
//  UserViewController.m
//  ai_comic
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//
#define widths  [UIScreen mainScreen].bounds.size.width
#define  heights   [UIScreen mainScreen].bounds.size.height
#define widthsFit  [UIScreen mainScreen].bounds.size.width/375
#define  heightsFit  [UIScreen mainScreen].bounds.size.height/667

#import "UserViewController.h"
#import "SDImageCache.h"
#import "aboutusViewController.h"
#import "dutyViewController.h"
#import "SDImageCache.h"
#import <ShareSDK/ShareSDK.h>
#import "SDWebImageManager.h"

@interface UserViewController ()<UIAlertViewDelegate>
{
    float imageSize;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

#pragma -mark分区头设置
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 150*heightsFit;
}

#pragma -mark设置分区头图片
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 60, 40,120, 80)];
    imageView.image = [UIImage imageNamed:@"1.png"];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

#pragma -mark 设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*heightsFit;
}
#pragma -mark重用机制
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell ) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    SDImageCache *cache = [[SDImageCache alloc] init];
   imageSize = [cache getSize]/1024.0/1024.0;
    NSLog(@"**********size = %f",imageSize);
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"分享冲冲";
            cell.imageView.image = [UIImage imageNamed:@"share"];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareAction:)];
            [cell addGestureRecognizer:tap];
            
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"清除缓存：%.1fM",imageSize];
            cell.imageView.image = [UIImage imageNamed:@"clear"];
            break;
        case 2:
            cell.textLabel.text = @"免责声明";
            cell.imageView.image = [UIImage imageNamed:@"declare"];
            break;
        case 3:
            cell.textLabel.text = @"关于冲冲漫画";
            cell.imageView.image = [UIImage imageNamed:@"about"];
            break;
        default:
            break;
    }
    return cell;
}

#pragma -mark选中单元格
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要清理缓存数据？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    if (indexPath.row == 2)
    {
        dutyViewController *duty = [[dutyViewController alloc] init];
        [self.navigationController pushViewController:duty animated:YES];
    }
    if (indexPath.row == 3)
    {
      aboutusViewController *aboutus = [[aboutusViewController alloc] init];
        [self.navigationController pushViewController:aboutus animated:YES];
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //只是清除内存里的图片，本地还有
        [[SDImageCache sharedImageCache] clearMemory];
        //清除磁盘里面的资源，彻底的删除
        [[SDImageCache sharedImageCache] clearDisk];
        
        [self.tableView reloadData];
    }
}


-(void)shareAction:(UITapGestureRecognizer*)gesture
{
    //注意，弹出菜单容器的方法中的参数sender,必须是UIVIEW及其子类的类型参数，不能用手势
    UITableViewCell *sender = (UITableViewCell*)gesture.view;
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"冲冲漫画，专注于在线漫画阅读的神器！上万部各类题材的日、韩、欧、美、港台等免费漫画资源全面覆盖，更新速度紧随官网脚步，绝对零距离追漫；独有的图片下载方式和加载功能，能够在观看高清漫画的同时节省手机内存；简约雅致的UI界面，轻松进入漫画世界。 赶快到APP STORE上免费下载吧~"
                                       defaultContent:@"冲冲漫画，专注于在线漫画阅读的神器！上万部各类题材的日、韩、欧、美、港台等免费漫画资源全面覆盖，更新速度紧随官网脚步，绝对零距离追漫；独有的图片下载方式和加载功能，能够在观看高清漫画的同时节省手机内存；简约雅致的UI界面，轻松进入漫画世界。赶快到APP STORE上免费下载吧~"
                                                image:[ShareSDK imageWithPath:@"/Users/lan/Desktop/demo/ai_comic/1.jpg"]
                                                title:@"冲冲漫画"
                                                  url:@"http://www.mob.com"
                                          description:@"冲冲漫画"
                                            mediaType:SSPublishContentMediaTypeNews];
    
       //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
     self.navigationItem.title = @"我的";
}








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
