//
//  SwipeSegmentViewController.h
//  SwipeSegementControllerContainer
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSegmentViewController.h"
#import "DRSegmentControl.h"
#import "DRUnderlineSegmentControl.h"
@interface SwipeSegmentViewController : UIViewController
///顶部滑竿view
@property (nonatomic,strong) UIView *thumbView;
///顶部滑竿view宽度，不指定宽度的话均分分段控件宽度
@property (nonatomic,assign) NSInteger thumbViewWidth;
///分段控件里面每项对齐方式，默认平铺均分效果
@property (nonatomic,assign) DRSegmentControlItemAlignType segmentAlignType;
-(void)addChildViewControllers:(NSArray*)childControllers withSegmentControl:(Class)segmentControl;

-(void)addChildViewTitles:(NSArray*)titleStrings
       withSegmentControl:(Class)segmentControl
 withSegmentItemAlignType:(DRSegmentControlItemAlignType)alignType
       withThumbViewWidth:(NSInteger)thumbWidth
           withThumbColor:(UIColor*)thumbColor;
@end
