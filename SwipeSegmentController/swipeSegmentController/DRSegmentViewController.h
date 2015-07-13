//
//  DRSegmentViewController.h
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
///需要自己实现content，继承此类
@interface DRSegmentViewController : UIViewController
#pragma mark -
#pragma mark -- content view左右切换时scrollview回调，子类可以重写，不能主动调用
-(void)segmentScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

-(void)segmentScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

-(void)segmentScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

-(void)segmentScrollViewDidScroll:(UIScrollView *)scrollView;

-(void)segmentScrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

-(void)segmentScrollViewWillBeginDragging:(UIScrollView *)scrollView;
#pragma mark -
@end
