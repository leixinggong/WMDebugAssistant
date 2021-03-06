//
//  WMAssistantInfoController.m
//  Pods
//
//  Created by roronoa on 2017/3/11.
//
//

#import "WMAssistantInfoController.h"
#import "WMChartLine.h"

#define WMWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;/** 弱引用自己 */

@interface WMAssistantInfoController () {

    UIButton *dButton;
    WMChartLine *v;
    UILabel *pointLbl; //点击的标签
}

@property (nonatomic, strong) NSMutableArray *x_vls;        //x轴
@property (nonatomic, strong) NSMutableArray *y_vls;        //y

@end

@implementation WMAssistantInfoController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];

    [self chartDidLoad];
    [self dismissDidLoad];
}

- (void)dismissDidLoad {
    dButton = [UIButton new];
    dButton.frame = CGRectMake(0, 0, 56, 32);
    [dButton setTitle:@"返回" forState:UIControlStateNormal];
    [dButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    dButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [dButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dButton];
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}


- (void)chartDidLoad {

    self.x_vls = [NSMutableArray new];
    self.y_vls = [NSMutableArray new];

    //日期对应数据
    for (int i =0; i<self.records.count; i++) {
        NSDictionary *dict = self.records[i];

        [self.x_vls addObject:@(i).stringValue];

        NSString *yText = [dict[@"value"] stringValue];
        [self.y_vls addObject:yText];
    }
    //创建折线图
    v = [[WMChartLine alloc] init];
    v.frame = self.view.bounds;
    //折线名称
    v.y_titles = @[self.title];
    // x轴坐标数组
    v.x_values = self.x_vls;
    // y轴坐标数组
    v.y_values = @[self.y_vls];
    // y 轴单位
    v.y_unit = self.unit;

    [v setXCoordinatesLocationInYValue:0];
    [v setCoordPlusAndMinusSymmetryShowZeroPoint:NO];
    [self.view addSubview:v];

    [v startDrawWithLineType:WMChartLineTypeCurve];

    WMWS(__self)
    v.clickPoint = ^(NSInteger index) {
        [__self clickPoint:index];
    };

}

- (void)clickPoint:(NSInteger)index  {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm:ss";

    NSDictionary *dict = self.records[index];
    NSDate *date =  dict[@"date"];
    CGFloat value =  [dict[@"value"] floatValue];
    NSString *d = [formatter stringFromDate:date];

    NSString *title = [NSString stringWithFormat:@"%@", self.title];
    NSString *info = [NSString stringWithFormat:@"%@ : %.2f%@", d, value, self.unit];

    if (!pointLbl) {
        pointLbl = [UILabel new];
        pointLbl.numberOfLines = 1;
        pointLbl.font = [UIFont systemFontOfSize:13];
        pointLbl.frame = CGRectMake(72, 0, 240, 32);
        [self.view addSubview:pointLbl];
    }

    pointLbl.text = [NSString stringWithFormat:@"%@:%@", title, info];
}

@end
