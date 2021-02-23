//
//  SleepDetailViewController.m
//  NOVASleep
//
//  Created by db J on 2020/9/7.
//  Copyright © 2020 NOVA. All rights reserved.
//

#import "SleepDetailViewController.h"

#import <NOVAUtilities.h>
#import "JDBDatePickerView.h"
#import "SleepRotatingView.h"

@interface SleepDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *startSleepBtn;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *KeepOutBgView;
@property (weak, nonatomic) IBOutlet UILabel *expectedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sleepBgImageView;
@property (assign, nonatomic) BOOL isStart;
@property (strong, nonatomic) JDBDatePickerView *pickerView;
@property (strong, nonatomic) SleepRotatingView *rotatingView;
@property (strong, nonatomic) NSTimer *currentTimer;
@property (strong, nonatomic) UILabel *currentTimeLabel;
@property (strong, nonatomic) UILabel *stopTimeLabel;
@property (assign, nonatomic) NSInteger hours;//预期睡眠几小时
@property (assign, nonatomic) NSInteger minute;//预期睡眠几分钟

@property (nonatomic, strong) NSDate *startDate;//开始统计时候时间
@end

@implementation SleepDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //关闭定时器
    if (self.currentTimer && !self.isStart) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = @"钉钉打卡助手";
    
    @weakify(self);
    self.startSleepBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
    self.pickerView = [[JDBDatePickerView alloc] initWithFrame:CGRectMake(0, 0, self.datePickerView.frame.size.width, self.datePickerView.frame.size.height)];
    [self.datePickerView addSubview:self.pickerView];
    self.pickerView.completeHandler = ^(NSInteger hours, NSInteger minute) {
        weak_self.hours = hours;
        weak_self.minute = minute;
        [weak_self timeDifferenceTheHours:hours theMinute:minute];
    };
    
    
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold"size:16];
    self.expectedLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:20];
    
    self.rotatingView = [[SleepRotatingView alloc] initWithFrame:CGRectMake(kScreenWidth/2-200/2, kScreenHeight/2-220, 200, 200)];
    self.rotatingView.hidden = YES;
    [self.view addSubview:self.rotatingView];
    
    self.currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rotatingView.frame.size.width/2-100/2, self.rotatingView.frame.size.height/2-50/2, 100, 50)];
    self.currentTimeLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:48];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.rotatingView addSubview:self.currentTimeLabel];
    
    self.stopTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.rotatingView.frame.size.width/2-70/2, self.rotatingView.frame.size.height/2+40, 70, 26)];
    self.stopTimeLabel.font = [UIFont fontWithName:@"BebasNeueBold" size:14];
    self.stopTimeLabel.textColor = [UIColor whiteColor];
    self.stopTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.stopTimeLabel.layer.cornerRadius = 13;
    self.stopTimeLabel.layer.masksToBounds = YES;
    self.stopTimeLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
    [self.rotatingView addSubview:self.stopTimeLabel];
    
    [self.startSleepBtn setTitle:@"开始" forState:UIControlStateNormal];

    
    //初始化一个默认睡眠时长
    [self initTimePickerView];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)clickCloseBtn:(id)sender {
        
    if (self.isStart) {
        NSDate *currentTimestamp = [NSDate date];
        NSTimeInterval timeInterval = [currentTimestamp timeIntervalSinceDate:self.startDate];
        if ((timeInterval/60>30)) {
            [self updateSleepState:0];
            [self back];
        }else{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确定结束，不准备自动打卡了吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self updateSleepState:1];
                [self back];
            }];
            [controller addAction:cancelAction];
            [controller addAction:confirmAction];
            [[[UIApplication sharedApplication] delegate].window.rootViewController  presentViewController:controller animated:true completion:nil];
        }
    }else{
        [self back];
        
    }
    
}

- (IBAction)clickSleepBtn:(id)sender {
        
    if (self.isStart) {
        NSDate *currentTimestamp = [NSDate date];
        NSTimeInterval timeInterval = [currentTimestamp timeIntervalSinceDate:self.startDate];
        if ((timeInterval/60>30)) {
            [self updateSleepState:0];
        }else{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"确定结束，不准备自动打卡了吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self updateSleepState:1];
            }];
            [controller addAction:cancelAction];
            [controller addAction:confirmAction];
            [[[UIApplication sharedApplication] delegate].window.rootViewController  presentViewController:controller animated:true completion:nil];
        }
    }else{
        [self updateSleepState:0];
        
    }
        
}

- (void)back{
    if (self.isStart) {
        self.isStart = NO;
        
        if (self.currentTimer) {
            //定时器暂停
            [self.currentTimer setFireDate:[NSDate distantFuture]];
        }
        [self.rotatingView stopRotating];
        
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateSleepState:(int)type{//0：生成数据 1：不生成
    
    self.isStart = !self.isStart;
    
    if (self.isStart) {
        //隐藏时间选择器
        self.startSleepBtn.layer.borderWidth = 1;
        self.startSleepBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.startSleepBtn.backgroundColor = [UIColor clearColor];
        [self.startSleepBtn setTitle:@"重置" forState:UIControlStateNormal];
        self.pickerView.hidden = YES;
        self.expectedLabel.hidden = YES;
        self.rotatingView.hidden = NO;
        self.KeepOutBgView.hidden = NO;
        self.currentTimeLabel.text = [[NSDate date] stringWithFormat:@"HH : mm"];
        if (self.currentTimer) {
            //定时器开始
            [self.currentTimer setFireDate:[NSDate date]];
        }else{
            //定时器 反复执行
            self.currentTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.currentTimer forMode:NSRunLoopCommonModes];
        }
        [self.rotatingView startRotating];
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.hours forKey:@"hours"];
        [[NSUserDefaults standardUserDefaults] setInteger:self.minute forKey:@"minute"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        self.startDate = [NSDate date];
        
    }else{
        //显示时间选择器
        self.startSleepBtn.layer.borderWidth = 0;
        self.startSleepBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.startSleepBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.25];
        [self.startSleepBtn setTitle:@"开始" forState:UIControlStateNormal];
        self.pickerView.hidden = NO;
        self.expectedLabel.hidden = NO;
        self.rotatingView.hidden = YES;
        self.KeepOutBgView.hidden = YES;
        if (self.currentTimer) {
            //定时器暂停
            [self.currentTimer setFireDate:[NSDate distantFuture]];
        }
        [self.rotatingView stopRotating];
        
        
    }
    
}



#pragma mark - 开始睡眠后，时间沙漏
- (void)updateTime{
    
    self.currentTimeLabel.text = [[NSDate date] stringWithFormat:@"HH : mm"];
    
    [self timeDifferenceTheHours:self.hours theMinute:self.minute];
    
}

#pragma mark - 初始化预期睡眠时间选择器
- (void)initTimePickerView{
    
    NSInteger userDefaultsHours = [[NSUserDefaults standardUserDefaults] integerForKey:@"hours"];
    NSInteger userDefaultsMinute = [[NSUserDefaults standardUserDefaults] integerForKey:@"minute"];
    
    if (userDefaultsHours) {
        self.pickerView.hoursIndex = userDefaultsHours;
        self.pickerView.minuteIndex = userDefaultsMinute;
        self.hours = userDefaultsHours;
        self.minute = userDefaultsMinute;
        
        [self timeDifferenceTheHours:userDefaultsHours theMinute:userDefaultsMinute];
    }else{
       
        //设置时间
        NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        // 获取代表公历的NSCalendar对象
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        // 获取当前日期
        NSDate* dt = [NSDate date];
        // 获取不同时间字段的信息
        NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
        // 没有保留用户选择时间的情况，再当前时间+8小时
        NSDate* newDate = nil;
        if ((comp.hour+7)>23) {
            newDate = [NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",comp.year,comp.month,(comp.day+1),(comp.hour+7-23),comp.minute] format:@"yyyy-MM-dd HH:mm"];
        }else{
            newDate = [NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",comp.year,comp.month,comp.day,(comp.hour+7),comp.minute] format:@"yyyy-MM-dd HH:mm"];
        }
        
        NSDateComponents* compExpected = [gregorian components: unitFlags fromDate:newDate];
        self.pickerView.hoursIndex = compExpected.hour;
        self.pickerView.minuteIndex = compExpected.minute;
        self.hours = compExpected.hour;
        self.minute = compExpected.minute;
        
        [self timeDifferenceTheHours:compExpected.hour theMinute:compExpected.minute];
    }
}

#pragma mark - 预期睡眠时长计算
- (void)timeDifferenceTheHours:(NSInteger)hours theMinute:(NSInteger)minute{
    
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:dt];
    
    NSDateComponents *cmps = nil;
    
    if (hours>comp.hour) {
        //选择的时间未垮天
        //NSLog(@"未跨天");
        NSDate* newDate =[NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",comp.year,comp.month,comp.day,hours,minute] format:@"yyyy-MM-dd HH:mm:ss"];

        cmps = [gregorian components:unitFlags fromDate:dt toDate:newDate options:0];
        
    }else if(hours==comp.hour){
        
        if (minute>comp.minute) {
            //NSLog(@"未跨天");
            NSDate* newDate =[NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",comp.year,comp.month,comp.day,hours,minute] format:@"yyyy-MM-dd HH:mm:ss"];

            cmps = [gregorian components:unitFlags fromDate:dt toDate:newDate options:0];
        }else{
            //NSLog(@"跨天了");
            NSDate* newDate =[NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",comp.year,comp.month,(comp.day+1),hours,minute] format:@"yyyy-MM-dd HH:mm:ss"];
            
            cmps = [gregorian components:unitFlags fromDate:dt toDate:newDate options:0];
        }
        
    }else{
        //选择的时间垮天
        //NSLog(@"跨天了");
        NSDate* newDate =[NSDate dateWithString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",comp.year,comp.month,(comp.day+1),hours,minute] format:@"yyyy-MM-dd HH:mm:ss"];
        
        cmps = [gregorian components:unitFlags fromDate:dt toDate:newDate options:0];
        
    }
    
    if (cmps != nil) {
        //NSLog(@"===时间差：%ld小时：%ld分钟==",cmps.hour,cmps.minute);
        self.expectedLabel.text = [NSString stringWithFormat:@"%@ : %ld %@ %ld %@",@"距离打卡时间",cmps.hour,@"小时",cmps.minute,@"分"];
        self.stopTimeLabel.text = [NSString stringWithFormat:@"%ld : %ld : %ld",cmps.hour,cmps.minute,cmps.second];
    }
    
}


- (void)dealloc{
    
    NSLog(@"=====SleepDetailViewControllerdealloc=====");
    if (self.currentTimer) {
        [self.currentTimer invalidate];
        self.currentTimer = nil;
    }
}

@end
