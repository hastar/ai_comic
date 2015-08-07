//
//  dutyViewController.m
//  ai_comic
//
//  Created by lanou on 15/6/30.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "dutyViewController.h"

@interface dutyViewController ()

@end

@implementation dutyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.font = [UIFont systemFontOfSize:13];
    myLabel.textColor = [UIColor grayColor];
    
    myLabel.text = @"      冲冲漫画是一个漫画聚集与分享阅读的客户端，所有的漫画内容均来自网友分享和上传。转载的目的在于传递更多信息及用于网络分享，不做任何商业用途。由于漫画数量较多，冲冲漫画对非法转载等侵权行为的发生不具备充分的监控能力，所以冲冲漫画对用户在本产品上实施的侵权行为不承担法律责任，侵权的责任由上传侵权内容的用户本人或者被链接的网站承担。如果您发现本产品提供的内容有侵犯您的知识产权的作品，请与我们取得联系，我们会及时修改或删除。";
    myLabel.numberOfLines = 0;
    //Label自适应高度
    myLabel.frame = [myLabel textRectForBounds:CGRectMake(0, 74, self.view.frame.size.width, CGFLOAT_MAX) limitedToNumberOfLines:0];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myLabel];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"免责声明";
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
