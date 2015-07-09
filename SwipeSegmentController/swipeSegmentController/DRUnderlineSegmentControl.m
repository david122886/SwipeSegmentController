//
//  DRUnderlineSegmentControl.m
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/9.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRUnderlineSegmentControl.h"

@implementation DRUnderlineSegmentControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(NSArray *)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth withThumbView:(UIView *)thumbView{
    NSMutableArray *constraints = @[].mutableCopy;
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thumbView(==width)]" options:0 metrics:@{@"width":@(thumbWidth)} views:NSDictionaryOfVariableBindings(thumbView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[thumbView(==2)]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thumbView)]];
    return constraints;
}
@end
