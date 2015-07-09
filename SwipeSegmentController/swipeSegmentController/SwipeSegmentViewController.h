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
@property (nonatomic,strong) UIView *thumbView;
-(void)addChildViewControllers:(NSArray*)childControllers withSegmentControl:(Class)segmentControl;
@end
