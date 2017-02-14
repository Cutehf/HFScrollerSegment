//
//  ViewController.m
//  选项卡视图同步滚动测试
//
//  Created by 瓜木 on 16/2/1.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "ViewController.h"
#import "FFView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface ViewController ()<FFViewDelegate>
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *controllersArray;
@property (nonatomic,strong) FFView *myFFView;

@end

@implementation ViewController


-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray=@[@"火男",@"小鱼",@"维克多",@"拉克丝",@"石头人",@"狐狸",@"武器大师",@"武器武器大师大师",@"鱼"];
    }
    return _titleArray;
}


-(NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=@[@"1",@"2",@"3",@"4",@"5"];
    }
    return _dataArray;
}

-(NSArray *)controllersArray
{
    if (!_controllersArray) {
        _controllersArray=@[@"FirstViewController",@"SecondViewController",@"FirstViewController",@"FirstViewController",@"SecondViewController"];
    }
    return _controllersArray;
}

-(FFView *)myFFView
{
    if (!_myFFView) {
        
        _myFFView=[[FFView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20)titleArray:self.titleArray];
        _myFFView.delegate=self;
//        _myFFView.index=3;
        [self.view addSubview:_myFFView];
    }
    return _myFFView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self addControllers];
    self.myFFView.userInteractionEnabled=YES;
    
}

-(void)addControllers
{
    for (int i=0; i<self.controllersArray.count; i++) {
        
        UIViewController *VC=[[NSClassFromString(self.controllersArray[i]) alloc]init];
        
        [self addChildViewController:VC];
        
    }
}


-(void)scrollViewSelectAtIndex:(NSInteger)index andTitle:(NSString *)title
{
    NSLog(@"---%ld---%@-",index,title);
}

-(void)FFView:(FFView *)view scrollViewDidEndScroll:(UIScrollView *)scrollerView andIndex:(NSInteger)index
{
    
    NSLog(@"------滚动结束代理方法---%ld--",index);
    if (index<self.controllersArray.count) {
        
        UIViewController *VC=self.childViewControllers[index];
        
        //判断是否上一次视图还存在，存在就不加载
        if (VC.view.superview) {
            return;
        }
        
        VC.view.frame=scrollerView.bounds;
        [scrollerView addSubview:VC.view];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
