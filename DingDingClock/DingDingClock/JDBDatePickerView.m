//
//  JDBDatePickerView.m
//  NOVASleep
//
//  Created by db J on 2020/9/8.
//  Copyright © 2020 NOVA. All rights reserved.
//

#import "JDBDatePickerView.h"

@interface JGTimeChoosePickerView2 : UIView

@property(nonatomic,strong) UILabel *TitleLbl;

@end


@implementation JGTimeChoosePickerView2

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _TitleLbl = [[UILabel alloc] initWithFrame:self.bounds];
        _TitleLbl.font = [UIFont fontWithName:@"BebasNeueBold"size:48];
        _TitleLbl.textColor = [UIColor whiteColor];
        _TitleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_TitleLbl];
    }
    return self;
}

@end

@interface JDBDatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerBackView;

@property(nonatomic,strong) NSArray *hoursDataArrM;

@property(nonatomic,strong) NSArray *minuteDataArrM;

@property(nonatomic,assign) NSInteger hours;

@property(nonatomic,assign) NSInteger minute;

@end

@implementation JDBDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.pickerBackView = [[UIPickerView alloc] initWithFrame:frame];
        self.pickerBackView.delegate = self;
        self.pickerBackView.dataSource = self;
        [self addSubview:self.pickerBackView];
        self.hoursDataArrM = @[@"0",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
        self.minuteDataArrM = @[@"00",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"];
        
        UILabel *minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pickerBackView.frame.size.width/2-6, self.pickerBackView.frame.size.height/2-38, 12, 60)];
        minuteLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold"size:48];
        minuteLabel.textColor = [UIColor whiteColor];
        minuteLabel.text = @":";
        minuteLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:minuteLabel];
        
    }
    return self;
}
- (void)setHoursIndex:(NSInteger)hoursIndex{
    self.hours = hoursIndex;
    [self.pickerBackView selectRow:hoursIndex inComponent:0 animated:YES];
}

- (void)setMinuteIndex:(NSInteger)minuteIndex
{
    self.minute = minuteIndex;
    [self.pickerBackView selectRow:minuteIndex inComponent:1 animated:YES];
}
#pragma mark -- UIPickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.hoursDataArrM.count;
    }else{
        return self.minuteDataArrM.count;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    //这里返回的是component的宽度,即每列的宽度
    return 100;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 60;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //去除pickerview分割线
    if (pickerView.subviews.count>=2) {
        for (UIView *subView2 in pickerView.subviews) {
            if (subView2.frame.size.height<1) {
                subView2.hidden = YES;
            }else if(subView2.frame.size.height >= 60 && subView2.frame.size.height <= 77){
                subView2.backgroundColor = [UIColor clearColor];
            }
            //NSLog(@"subView2的高：%f",subView2.frame.size.height);
        }
    }
    
    JGTimeChoosePickerView2 *pView =(JGTimeChoosePickerView2 *)view;
    if (!pView) {
        pView = [[JGTimeChoosePickerView2 alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 60)];
    }
    if (component == 0) {
        pView.TitleLbl.text = self.hoursDataArrM[row];
    }else{
        pView.TitleLbl.text = self.minuteDataArrM[row];
    }
    return pView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     if (component == 0) {
         self.hours = [self.hoursDataArrM[row] integerValue];
         NSLog(@"小时时间：%d",[self.hoursDataArrM[row] intValue]);
     }else{
         self.minute= [self.minuteDataArrM[row] integerValue];
         NSLog(@"分钟时间：%d",[self.minuteDataArrM[row] intValue]);
     }
    if (self.completeHandler) {
        self.completeHandler(self.hours, self.minute);
    }
}

@end
