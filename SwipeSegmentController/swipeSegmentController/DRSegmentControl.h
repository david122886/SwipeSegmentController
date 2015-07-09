//
//  DRSegment.h
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DRSegmentControl;
@protocol DRSegmentControlDelegate <NSObject>
-(void)segmentControl:(DRSegmentControl*)segmentControl withSelectedAtIndex:(NSInteger)index;
@end
/**
 * 选中下划线控件
 */
@interface DRSegmentControl : UIView
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong,readonly) UIView *thumbView;
///设置thumb位置,设置thumbLeadingConstraint
@property (nonatomic,assign) CGFloat thumbProgress;
@property (nonatomic,weak) id<DRSegmentControlDelegate> delegate;
@property (nonatomic,strong) UIColor *itemTitleTextColor;

-(void)addItemStrings:(NSArray*)itemStringArray withThumbView:(UIView*)thumbView;
-(void)setSelectedIndexWithoutAction:(NSInteger)selectedIndex;

#pragma mark -
#pragma mark -- 子类继承实现
///实现自己thumb autolayout
-(NSArray*)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth withThumbView:(UIView*)thumbView;
#pragma mark -
@end
