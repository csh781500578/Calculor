//
//  LJCalculorMaker.h
//  HHKit
//
//  Created by hanryChen on 16/12/23.
//  Copyright © 2016年 hanryChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, calculating){
    calculatingDivide = 0,  //除法
    calculatingMult,        //乘法
    calculatingSub,         //减法
    calculatingAdd          //加法
};

@interface LJCalculorMaker : NSObject
{
    NSString *_result;
}
/** 结果 */
@property(nonatomic,readonly, copy) NSString *result;

+ (NSString *)makeOriginal:(NSString *)original calculator:(void (^)(LJCalculorMaker *))makeCalculator;

- (LJCalculorMaker *(^)(NSString *,calculating))calculor;

//除法
- (LJCalculorMaker *(^)(NSString *))divide;
//乘法
- (LJCalculorMaker *(^)(NSString *))mult;
//减法
- (LJCalculorMaker *(^)(NSString *))sub;
//加法
- (LJCalculorMaker *(^)(NSString *))add;



@end
