//
//  aboutusViewController.m
//  ai_comic
//
//  Created by lanou on 15/6/30.
//  Copyright (c) 2015年 李少佳. All rights reserved.
//

#import "aboutusViewController.h"

@interface aboutusViewController ()

@end

@implementation aboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.font = [UIFont systemFontOfSize:13];
    myLabel.textColor = [UIColor blackColor];

    myLabel.text = @"\n\
    联系我们：  沈林平    401444084@qq.com\n\
                       李少佳    lsj0610201@163.com\n\
                       董奉翀    dfc901123@163.com\n\
    简介：\n\
    \n\
            冲冲漫画，专注于在线漫画阅读的神器！上万部各类题材的日、韩、欧、美、港台等免费漫画资源全面覆盖，更新速度紧随官网脚步，绝对零距离追漫；独有的图片下载方式和加载功能，能够在观看高清漫画的同时节省手机内存；简约雅致的UI界面，轻松进入漫画世界。\n\
    我们所有的努力，都旨在为您带来更流畅，更前线，更二次元的阅读体验。若您有好的建议或者想法，欢迎及时联系我们！"
;
    
    

    //Label自适应高度
    myLabel.numberOfLines = 0;
    myLabel.frame = [myLabel textRectForBounds:CGRectMake(0, 74, self.view.frame.size.width, CGFLOAT_MAX) limitedToNumberOfLines:0];
//    myLabel.backgroundColor = [UIColor redColor];

     self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"关于冲冲漫画";
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
