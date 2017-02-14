//
//  FFViewController.m
//  选项卡视图同步滚动测试
//
//  Created by 瓜木 on 16/2/16.
//  Copyright © 2016年 黄飞. All rights reserved.
//

#import "FFView.h"

#define Define_Tag_add 1000
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define RELATIVE_WIDTH(m) kScreenWidth/750.0*m
#define selectViewHeight 30
#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define margin RELATIVE_WIDTH(20)
#define fontSize RELATIVE_WIDTH(28)
#define bottomLineH RELATIVE_WIDTH(4)

@interface FFView () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *myScrollView;    //下面大的主滚动视图
@property (nonatomic,strong) NSArray *titleArray;           //标题数组
@property (nonatomic,strong) UIView *selectTitleView;       //选项卡视图
@property (nonatomic,strong) UIScrollView *titleScrollView; //标题的滚动视图
@property (nonatomic,strong) UIView *bottomLineView;        //下划线
@property (nonatomic,strong) NSMutableArray *btnArray;      //按钮的数组

@end

@implementation FFView
{
    
    NSInteger selectIndex;          //选择的按钮
    float marginSize;               //按钮的间距
    float maxOffset;                //最大的偏移量
    BOOL isNotAnimate;              //判断是否需要动画效果
    CGFloat preLeftScale;           //上一次的向左边滑动的滑动百分数
    CGFloat preRightScale;          //上一次向右边滑动的滑动百度数
}


//选项卡界面
-(UIView *)selectTitleView
{
    if (!_selectTitleView) {
        _selectTitleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
        [self addSubview:_selectTitleView];
    }
    return _selectTitleView;
}

//选项卡界面上的滚动视图
-(UIScrollView *)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.selectTitleView.frame.size.height)];
        _titleScrollView.showsHorizontalScrollIndicator=NO;
        _titleScrollView.delegate=self;
        _titleScrollView.bounces=NO;
        _titleScrollView.tag=200;
        [self.selectTitleView addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

//下面大的主界面的滚动视图
-(UIScrollView *)myScrollView
{
    if (!_myScrollView) {
        _myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectTitleView.frame)+10, self.frame.size.width, self.frame.size.height- CGRectGetMaxY(self.selectTitleView.frame))];
        _myScrollView.delegate=self;
        
        _myScrollView.tag=100;
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
        label.text=@"fasfdsafsda";
        _myScrollView.contentSize=CGSizeMake(self.frame.size.width*self.titleArray.count, 0);
        _myScrollView.backgroundColor=[UIColor redColor];
        [_myScrollView addSubview:label];
        _myScrollView.pagingEnabled=YES;
        [self addSubview:_myScrollView];
    }
    return _myScrollView;
}

//创建选项卡界面
-(void)createSelectView
{
    self.btnArray=[[NSMutableArray alloc]initWithCapacity:self.titleArray.count];
    //记录下前一个按钮右边缘的X坐标
    CGFloat preX=0;
    
    //设置按钮之间的间隙
    marginSize=margin;
    
    //记录下按钮的总的宽度
    float totalSizeWidth=0;
    for (int i = 0; i<[self.titleArray count]; i++) {
        
        CGRect btnRect=[self.titleArray[i] boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
        
        //少于3个字体时追加使得其按钮的宽度至少为3个字体的宽度在加上20像素
        if ([self.titleArray[i] length]<3) {
            totalSizeWidth+=(3-[self.titleArray[i] length])*btnRect.size.width/[self.titleArray[i] length]+btnRect.size.width+marginSize;
        }else
        {
            totalSizeWidth+=btnRect.size.width+marginSize;
        }
    }
    
    /**如果按钮总的宽度加上之间的间距小于屏幕的宽度的话，这时按钮的布局将重新
     改变，将使得现在的按钮正好是整个屏幕
     */
    if (totalSizeWidth + (self.titleArray.count+1)*marginSize<kScreenWidth) {
        
        marginSize=(kScreenWidth-totalSizeWidth)/(self.titleArray.count+1);
        
    }
    
    for (int i = 0; i<[self.titleArray count]; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect btnRect=[self.titleArray[i] boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil];
        
        /**
         
         
         */
        
        //得到当前按钮的宽度
        float Btn_W=btnRect.size.width;
        //按钮的宽度加上20
        Btn_W+=RELATIVE_WIDTH(20);
        
        //添加字体的宽度,使得按钮的字体的宽度至少为3个字体的自适应的宽度
        if ([self.titleArray[i] length]<3) {
            
            Btn_W+=(3-[self.titleArray[i] length])*btnRect.size.width/[self.titleArray[i] length];
        }else
        {
            //                Btn_W+=btnRect.size.width/[titles[i] length];
        }
        
        
        btn.frame = CGRectMake( marginSize + preX , .0f, Btn_W, selectViewHeight);
        
        if (i==self.titleArray.count-1) {
            self.titleScrollView.contentSize=CGSizeMake(btn.frame.size.width+btn.frame.origin.x+marginSize, 0);
            maxOffset= btn.frame.size.width+btn.frame.origin.x+marginSize-kScreenWidth;
        }
        
        [btn setTitleColor:UIColorFromRGBValue(0x999999) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [btn setTitleColor:UIColorFromRGBValue(0xe74e3e) forState:UIControlStateSelected];
        [btn setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = Define_Tag_add+i;
        
        preX=btn.frame.size.width+btn.frame.origin.x;
        //        btn.backgroundColor=[UIColor yellowColor];
        [self.titleScrollView addSubview:btn];
        [self.btnArray addObject:btn];
        
        if (i == 0) {
            
            btn.selected = YES;
//            self.preBtn=btn;
            _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x-RELATIVE_WIDTH(5), selectViewHeight-RELATIVE_WIDTH(4), btn.frame.size.width + RELATIVE_WIDTH(10), bottomLineH)];
            
            //下划线的颜色
            //        _bottomLineView.backgroundColor = UIColorFromRGBValue(0x454545);
            _bottomLineView.backgroundColor=UIColorFromRGBValue(0xe74e3e);
            [self.titleScrollView addSubview:_bottomLineView];
            
            [self addSubview:self.titleScrollView];
            
        }
    }
    
}

#pragma mark 按钮点击的方法
- (void)segmentedControlChange:(UIButton *)btn
{
    
    
    btn.selected = YES;
    for (UIButton *subBtn in self.btnArray) {
        if (subBtn != btn) {
            subBtn.selected = NO;
        }
    }
    
    //下划线的frame
    CGRect rect4boottomLine = self.bottomLineView.frame;
    rect4boottomLine.origin.x = btn.frame.origin.x - RELATIVE_WIDTH(5);
    rect4boottomLine.size.width=btn.frame.size.width + RELATIVE_WIDTH(10);
    
    CGPoint pt = CGPointZero;
    /**
     
     当前界面使得按钮居中显示
     
     */
    float currentBtnX=(kScreenWidth-(btn.frame.size.width+2*marginSize))/2;
    //距离中间坐标多远
    float offset=btn.frame.origin.x-currentBtnX-marginSize;
    
    //上面的同这句方法，使得其居中显示
    //float offset=btn.frame.origin.x-self.center.x+btn.frame.size.width/2;
    
    if (offset>=0) {
        pt.x=offset;
    }else
    {
        pt.x=0;
    }
    
    if (pt.x>maxOffset) {
        pt.x=maxOffset;
    }
    
    //动画滑动
    if (!isNotAnimate) {
        
        NSTimeInterval  duration=0.3;
        [UIView animateWithDuration:duration animations:^{
            self.titleScrollView.contentOffset=pt;
            self.bottomLineView.frame = rect4boottomLine;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration animations:^{
                //                self.bottomLineView.frame = rect4boottomLine;
            }];
        }];
        
    }else
    {
        self.titleScrollView.contentOffset=pt;
        self.bottomLineView.frame = rect4boottomLine;
        isNotAnimate=NO;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewSelectAtIndex:andTitle:)]) {
        [self.delegate scrollViewSelectAtIndex:btn.tag - 1000 andTitle:btn.titleLabel.text];
    }
    
    NSInteger index=btn.tag-Define_Tag_add;

    //使得下面的大的滚动视图滚动
    [self.myScrollView setContentOffset:CGPointMake(kScreenWidth*index, 0) animated:NO];
    
}

//初始化
-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    if (self=[super initWithFrame:frame]) {
        
        self.titleArray=titleArray;

        self.myScrollView.userInteractionEnabled=YES;

        [self createSelectView];
    }
    return self;
}

/**
    滚动条同步滚动需要放在didScroll代理中，并且其在快速滚动时为了同步滚动条，只能把实现方法放在这个代理中
    快速滚动有可能不进去scrollView的其他代理方法
 */
#pragma mark ------ UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.tag==100) {
        
        
        //**--------------------------------------------------------------------------**//
        
        CGFloat value=ABS(scrollView.contentOffset.x/scrollView.frame.size.width);
        
        UIButton *selectBtn=self.btnArray[(int)(value+0.5)];
        selectBtn.selected=YES;
        for (UIButton *subBtn in self.btnArray) {
            if (subBtn!=selectBtn) {
                subBtn.selected = NO;
            }
        }
        
        //前一个按钮索引
        NSUInteger leftIndex=(int)value;
        
        //            NSLog(@"++++++++%lf----------------",scrollView.contentOffset.x);
        
        NSUInteger rightIndex=leftIndex+1;
        //向右边滚动时的滚动百分比
        CGFloat scaleRight=value-leftIndex;
        //向左边滚动时的滚动百分比
        CGFloat scaleLeft=1-scaleRight;
        
        //当前按钮的索引
        NSInteger nowIndex;
        
        //下一个按钮
        UIButton *btn;
        //偏移量
        float offsetX=0;
        //偏移的宽度
        float width=0;
        //下划线的X
        float bottomX;
        //下划线的宽度
        float bottomWidth;
        //滑动的百分比
        float percentage;
        
        //当为最后面的按钮时
        if (rightIndex==self.btnArray.count) {
            rightIndex=self.btnArray.count-1;
        }
        
        //-----向右边滑动-----
        if (preRightScale<scaleRight) {
            
            //下一个按钮
            btn=self.btnArray[rightIndex];
            
            percentage=scaleRight;
            
            //得到当前按钮的索引
            nowIndex=leftIndex;
            
            //当成功滑动了一页
            if (value==leftIndex) {
                nowIndex-=1;
            }
            
        }else
        {
//            NSLog(@"----向左边滑动--------");
            btn=self.btnArray[leftIndex];
            percentage=scaleLeft;
            
            nowIndex=rightIndex;
            
        }
        
        //当前的按钮
        UIButton *nowBtn=self.btnArray[nowIndex];
        
        preRightScale=scaleRight;
        preLeftScale=scaleLeft;
        
        if (nowIndex==0) {
            preRightScale=0;
        }
        
        //下一个下划线的X
        bottomX=btn.frame.origin.x-RELATIVE_WIDTH(5);
        //下一个下划线的宽度
        bottomWidth=btn.frame.size.width+RELATIVE_WIDTH(10);
        //现在的下划线的X
        CGFloat nowBottomX=nowBtn.frame.origin.x-RELATIVE_WIDTH(5);
        CGFloat nowBottomW=nowBtn.frame.size.width+RELATIVE_WIDTH(10);
        
        offsetX=(bottomX-nowBottomX)*percentage;
        
        width=(bottomWidth-nowBottomW)*percentage;
        
        //如果为第一个索引的话向左滑动时
        if (scrollView.contentOffset.x<0) {
            offsetX=0;
        }
        
        CGRect rect4boottomLine = self.bottomLineView.frame;
        rect4boottomLine.origin.x = nowBottomX+offsetX;
        rect4boottomLine.size.width=nowBottomW + width;
        
        self.bottomLineView.frame = rect4boottomLine;
        
    }
}

//结束滚动时实现相应的方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    if (scrollView.tag==100) {
        
        NSInteger index=scrollView.contentOffset.x/kScreenWidth;
        
        if (index==self.btnArray.count) {
            index=self.btnArray.count-1;
        }
        
        if (index<0) {
            index=0;
        }
        
        UIButton *btn=self.btnArray[index];
        
        CGPoint pt = CGPointZero;
        float offset=0;
        
        offset=btn.frame.origin.x-self.center.x+btn.frame.size.width/2;
        
        if (offset>=0) {
            pt.x=offset;
        }else
        {
            pt.x=0;
        }
        
        //大于最大的偏移量时
        if (pt.x>maxOffset) {
            pt.x=maxOffset;
        }
        
        //使得标题的滚动视图动画滑动
        [UIView animateWithDuration:0.3f animations:^{
            
            self.titleScrollView.contentOffset=pt;
        }];
        
        //传回当前的按钮的标题
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewSelectAtIndex:andTitle:)]) {
            [self.delegate scrollViewSelectAtIndex:btn.tag - 1000 andTitle:btn.titleLabel.text];
        }
        
        if (_delegate&&[_delegate respondsToSelector:@selector(FFView:scrollViewDidEndScroll:andIndex:)]) {
            [self.delegate FFView:self scrollViewDidEndScroll:scrollView andIndex:index];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


-(void)setIndex:(NSInteger)index
{
    if (index > [self.btnArray count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [self.btnArray objectAtIndex:index];
    
    //判断是否需要动画效果
    //    isNotAnimate=YES;
    
    [self segmentedControlChange:btn];
}

@end
