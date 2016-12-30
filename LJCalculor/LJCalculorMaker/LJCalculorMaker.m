//
//  LJCalculorMaker.m
//  HHKit
//
//  Created by hanryChen on 16/12/23.
//  Copyright © 2016年 hanryChen. All rights reserved.
//

#import "LJCalculorMaker.h"
#import <objc/runtime.h>

static NSDecimalNumber *decimalNumber(NSString *text) {
    return [NSDecimalNumber decimalNumberWithString:text];
}

static NSString *const kCalculorMakerResult;

@interface LJCalculorMaker()

@end

@implementation LJCalculorMaker

+ (NSString *)makeOriginal:(NSString *)original calculator:(void (^)(LJCalculorMaker *))makeCalculator {
    LJCalculorMaker *maker = [[LJCalculorMaker alloc] init];
    maker.result = original;
    makeCalculator(maker);
    NSArray *array = [maker.result componentsSeparatedByString:@"."];
    if ([array count] > 1 && [[array lastObject] length] > 8) {
        maker.result = [maker.result substringToIndex:maker.result.length - [[array lastObject] length] + 8];
    }
    return maker->_result;
}

- (LJCalculorMaker *(^)(NSString *,calculating))calculor {
    return ^LJCalculorMaker *(NSString * value,calculating calculator) {
        switch (calculator) {
            case calculatingDivide: {
                return self.divide(value);
            }
            case calculatingMult: {
                return self.mult(value);
            }
            case calculatingSub: {
                return self.sub(value);
            }
            case calculatingAdd: {
                return self.add(value);
            }
            default:
                break;
        }
        return self;
    };
    
}

- (LJCalculorMaker *(^)(NSString *))divide {
    return ^LJCalculorMaker *(NSString * value) {
        ;
        self.result = [[decimalNumber(self.result) decimalNumberByDividingBy:decimalNumber(value)] stringValue];
        return self;
    };
}

- (LJCalculorMaker *(^)(NSString *))mult {
    return ^LJCalculorMaker *(NSString * value) {
        self.result = [[decimalNumber(self.result) decimalNumberByMultiplyingBy:decimalNumber(value)] stringValue];
        return self;
    };
}

- (LJCalculorMaker *(^)(NSString *))sub {
    return ^LJCalculorMaker *(NSString * value) {
        self.result = [[decimalNumber(self.result) decimalNumberBySubtracting:decimalNumber(value)] stringValue];
        return self;
    };
}

- (LJCalculorMaker *(^)(NSString *))add {
    return ^LJCalculorMaker *(NSString * value) {
        self.result = [[decimalNumber(self.result) decimalNumberByAdding:decimalNumber(value)] stringValue];
        return self;
    };
}

- (void)setResult:(NSString *)result {
    _result = result;
    objc_setAssociatedObject(self, &kCalculorMakerResult, result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)result {
    return objc_getAssociatedObject(self, &kCalculorMakerResult);
}

@end
