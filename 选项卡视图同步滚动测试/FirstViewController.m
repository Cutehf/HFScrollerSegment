//
//  FirstViewController.m
//  选项卡视图同步滚动测试
//
//  Created by 瓜木 on 16/3/1.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FirstViewController.h"
#import "ThirdViewController.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor blueColor];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
   
    [btn addTarget:self action:@selector(btnMethod) forControlEvents:UIControlEventTouchUpInside];

    btn.backgroundColor=[UIColor blackColor];
    
    btn.frame=CGRectMake(10, 100, 100, 30);
     [self.view addSubview:btn];
   }

-(void)btnMethod
{
//    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
 ThirdViewController *thirdVC=    [ThirdViewController new];
    thirdVC.view.backgroundColor=[UIColor greenColor];
    [self presentViewController:thirdVC animated:YES completion:nil];
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
