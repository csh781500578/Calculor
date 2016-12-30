//
//  ViewController.m
//  LJCalculor
//
//  Created by hanryChen on 16/12/30.
//  Copyright © 2016年 hanryChen. All rights reserved.
//

#import "ViewController.h"
#import "LJCalculorMaker.h"

@interface ViewController ()
{
    BOOL _isStart; //开始计算
    BOOL _isEditing; //正在输入
}
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
/** 输入的数据 **/
@property(nonatomic,copy) NSString *result;
/** 计算类型 */
@property(nonatomic, assign) calculating calcultor;
@end

@implementation ViewController

@synthesize resultLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initialize];
}

- (void)initialize {
    self.result = @"0";
    resultLabel.text = @"0";
    _isStart = NO;
    _isEditing = NO;
}

/**
 正在输入中...
 
 */
- (IBAction)calculatingNumberAction:(UIButton *)sender {
    int number = (int)sender.tag - 1000;
    if (!_isEditing) {
        resultLabel.text = @"0";
    }
    
    if (number >= 0) {
        resultLabel.text = [resultLabel.text stringByAppendingFormat:@"%@",@(number)];
    }else {
        if (![resultLabel.text containsString:@"."]) {
            resultLabel.text = [resultLabel.text stringByAppendingString:@"."];
        }
    }
    //清除前面的0
    if ([resultLabel.text hasPrefix:@"0"] && [resultLabel.text rangeOfString:@"."].location != 1) {
        resultLabel.text = [resultLabel.text substringFromIndex:1];
    }
    
    _isEditing = YES;
}

/**
 开始计算
 
 @param sender 算法
 */
- (IBAction)calculatingAction:(UIButton *)sender {
    __block int tag = (int)sender.tag - 2000;
    
    if (tag >= 0 && tag < 100) {
        if (_isStart && _isEditing) {
            [self setCalcultorResult:resultLabel.text];
        }else {
            _isStart = YES;
        }
        self.calcultor = (calculating)tag;
    }else if (tag == 100) {
        //百分比
        self.calcultor = calculatingMult;
        self.result = resultLabel.text;
        [self setCalcultorResult:@"0.01"];
    } else if (tag == 101) {
        //相反数
        self.result = resultLabel.text;
        self.calcultor = calculatingMult;
        [self setCalcultorResult:@"-1"];
    } else if (tag == 1000) {
        //等于
        [self setCalcultorResult:resultLabel.text];
    }
    _isEditing = NO;
    self.result = [NSString stringWithString:resultLabel.text];
}

//归零
- (IBAction)clearAction:(id)sender {
    [self initialize];
}


/**
 计算
 
 @param orginal 参与计算数据
 */
- (void)setCalcultorResult:(NSString *)orginal {
    __weak ViewController *weakSelf = self;
    
    __block NSString *result = [NSString stringWithString:orginal];
    self.result = [LJCalculorMaker makeOriginal:self.result calculator:^(LJCalculorMaker *maker) {
        maker.calculor(result,weakSelf.calcultor);
    }];
    resultLabel.text = [NSString stringWithString:self.result];
    
    _isStart = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
