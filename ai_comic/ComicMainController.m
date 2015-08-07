//
//  ComicMainController.m
//  ai_comic
//
//  Created by lanou on 15/6/29.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "ComicMainController.h"
#import "ComicPagesColltionControll.h"
#import "HisAndColViewController.h"
#import "ComicSubjectsController.h"
#import "UserViewController.h"
#import "RecoTabController.h"
@interface ComicMainController ()

@end

@implementation ComicMainController

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    return YES;
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HisAndColViewController *HisAndCol = [[HisAndColViewController alloc]init];
    UINavigationController *His = [[UINavigationController alloc]initWithRootViewController:HisAndCol];
    [HisAndCol release];
    
    ComicSubjectsController *subjects = [[ComicSubjectsController alloc]init];
    UINavigationController *subjectsNavigation = [[UINavigationController alloc]initWithRootViewController:subjects];
    [subjects release];
    
    UserViewController *user = [[UserViewController alloc]init];
    UINavigationController *userNavigation = [[UINavigationController alloc]initWithRootViewController:user];
        [user release];
    His.tabBarItem.title = @"书架";
    His.tabBarItem.image = [UIImage imageNamed:@"bookrack"];
    
//    UITabBarController *recomTab = [[UITabBarController alloc]init];
//    [recomTab setViewControllers:@[recomNavi, boardNavigation] animated:YES];
//    recomTab.tabBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    

    
    subjectsNavigation.tabBarItem.title = @"分类";
    subjectsNavigation.tabBarItem.image = [UIImage imageNamed:@"sort"];

    userNavigation.tabBarItem.title = @"我的";
    userNavigation.tabBarItem.image = [UIImage imageNamed:@"mine"];

    RecoTabController *reco = [[RecoTabController alloc]init];
    UINavigationController *recoNavi = [[UINavigationController alloc]initWithRootViewController:reco];
    [reco release];
    
    
    reco.tabBarItem.title = @"主页";
    reco.tabBarItem.image = [UIImage imageNamed:@"home"];
    
    [self setViewControllers:@[His,recoNavi,subjectsNavigation,userNavigation] animated:YES];
    self.selectedIndex = 1;

    self.tabBar.tintColor = [UIColor colorWithRed:153/255.0 green:129/255.0 blue:125/255.0 alpha:1.0];

    
    
    // Do any additional setup after loading the view.
}

//
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

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
