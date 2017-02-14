//
//  FFViewController.h
//  选项卡视图同步滚动测试
//
//  Created by 瓜木 on 16/2/16.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFView;

@protocol FFViewDelegate <NSObject>

//选项卡滑动到按钮上所得到的按钮索引和标题
-(void)scrollViewSelectAtIndex:(NSInteger)index andTitle:(NSString*)title;
//滚动视图在结束滚动时
-(void)FFView:(FFView*)view scrollViewDidEndScroll:(UIScrollView *)scrollerView andIndex:(NSInteger)index;

@end

@interface FFView : UIView

@property (nonatomic,strong) NSArray *dataArray;

//初始化选项卡界面
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray*)titleArray;

@property (nonatomic,weak) id<FFViewDelegate> delegate;
//选项卡滑动到那个索引
@property (nonatomic,assign) NSInteger index;

@end
