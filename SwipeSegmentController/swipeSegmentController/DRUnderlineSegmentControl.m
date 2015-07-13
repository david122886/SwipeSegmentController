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
-(NSArray *)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth
                             withThumbView:(UIView *)thumbView
                  withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
                             withItemCount:(NSInteger)itemCount
{
    NSMutableArray *constraints = @[].mutableCopy;
    if (thumbWidth < 0.00001 || itemAlignType == DRSegmentControlItemAlignType_stretch) {
        ///均分
        CGFloat itemWidth = itemCount<=0?CGRectGetWidth([[UIScreen mainScreen] bounds]):CGRectGetWidth([[UIScreen mainScreen] bounds])/itemCount;
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thumbView(==width)]" options:0 metrics:@{@"width":@(itemWidth)} views:NSDictionaryOfVariableBindings(thumbView)]];
    }else{
        ///中间靠拢
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thumbView(==width)]" options:0 metrics:@{@"width":@(thumbWidth)} views:NSDictionaryOfVariableBindings(thumbView)]];
    }
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[thumbView(==2)]-1-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thumbView)]];
    return constraints;
}

/////实现自己分段控件item布局 autolayout
//-(NSArray*)segmentItemsConstraintsWithItemWidth:(CGFloat)itemWidth
//                       withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
//                                      withItems:(NSArray*)items
//{
//    
//    return nil;
//}
@end
