//
//  DRSegment.h
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, DRSegmentControlItemAlignType) {
    ///拉伸均分
    DRSegmentControlItemAlignType_stretch,
    ///靠拢居中
    DRSegmentControlItemAlignType_center
    ///靠拢左对齐
//    DRSegmentControlItemAlignType_left,
    ///靠拢右对齐
//    DRSegmentControlItemAlignType_right
};
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
@property (nonatomic,assign,readonly) DRSegmentControlItemAlignType itemAlignType;
@property (nonatomic,assign,readonly) CGFloat thumbWidth;

-(void)addItemStrings:(NSArray*)itemStringArray
        withThumbView:(UIView*)thumbView
       withThumbWidth:(NSInteger)thumbWidth
    withItemAlignType:(DRSegmentControlItemAlignType)alignType;
-(void)setSelectedIndexWithoutAction:(NSInteger)selectedIndex;

#pragma mark -
#pragma mark -- 子类继承实现
///实现自己thumb autolayout
-(NSArray*)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth
                            withThumbView:(UIView*)thumbView
                 withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
                            withItemCount:(NSInteger)itemCount;

///实现自己分段控件item布局 autolayout
-(NSArray*)segmentItemsConstraintsWithItemWidth:(CGFloat)itemWidth
                       withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
                                      withItems:(NSArray*)items;
#pragma mark -
@end
