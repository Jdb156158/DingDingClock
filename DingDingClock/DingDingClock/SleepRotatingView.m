//
//  SleepRotatingView.m
//  NOVASleep
//
//  Created by db J on 2020/9/9.
//  Copyright © 2020 NOVA. All rights reserved.
//

#import "SleepRotatingView.h"
#import <Masonry/Masonry.h>
@interface SleepRotatingView ()

@property (nonatomic, strong) UIView *icon_View;
@property (nonatomic, strong) CAKeyframeAnimation *animation;

@end
@implementation SleepRotatingView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
    }
    return self;
}

- (void)addUI{
    //第一步，通过UIBezierPath设置圆形的矢量路径
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    //第二步，用CAShapeLayer沿着第一步的路径画一个完整的环（颜色灰色，起始点0，终结点1）
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);//设置Frame
    //    bgLayer.position = self.contView.center;//居中显示
    bgLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色=透明色
    bgLayer.lineWidth = 1.f;//线条大小
    bgLayer.strokeColor = [UIColor whiteColor].CGColor;//线条颜色
    bgLayer.strokeStart = 0.f;//路径开始位置
    bgLayer.strokeEnd = 1.f;//路径结束位置
    bgLayer.path = circle.CGPath;//设置bgLayer的绘制路径为circle的路径
    [self.layer addSublayer:bgLayer];//添加到屏幕上
    
    [self addSubview:self.icon_View];
    [self.icon_View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20.0f, 20.0f));
    }];
    
}

- (UIView *)icon_View {
    if (!_icon_View) {
        _icon_View = [[UIView alloc] init];
        _icon_View.backgroundColor = [UIColor whiteColor];
        _icon_View.layer.cornerRadius = 10.0f;
        _icon_View.layer.shadowColor = [[UIColor colorWithWhite:1 alpha:0.9] CGColor];
        _icon_View.layer.shadowOffset = CGSizeZero;
        _icon_View.layer.shadowOpacity = 1;
        _icon_View.layer.shadowRadius = 4;
    }
    return _icon_View;
}

- (void)startRotating{
    
    if (self.animation) {
        
        CFTimeInterval pausedTime = [self.icon_View.layer timeOffset];
        
        self.icon_View.layer.speed =1.0; // 让CALayer的时间继续行走
        
        self.icon_View.layer.timeOffset =0.0; //取消上次记录的停留时刻
        
        self.icon_View.layer.beginTime =0.0; //取消上次设置的时间
        
        // 计算暂停的时间(这里用CACurrentMediaTime()-pausedTime也是一样的)
        
        CFTimeInterval timeSincePause = [self.icon_View.layer convertTime:CACurrentMediaTime()fromLayer:nil] - pausedTime;
        // 设置相对于父坐标系的开始时间(往后退timeSincePause)
        
        self.icon_View.layer.beginTime = timeSincePause;
        
    }else{
        
        //第一步，通过UIBezierPath设置圆形的矢量路径
        UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        self.animation = [CAKeyframeAnimation animation];
        //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
        self.animation.keyPath = @"position";
        //设置动画时间
        self.animation.duration = 12;
        // 告诉在动画结束的时候不要移除
        self.animation.removedOnCompletion = NO;
        // 始终保持最新的效果
        self.animation.fillMode = kCAFillModeForwards;
        self.animation.calculationMode = kCAAnimationPaced;
        self.animation.repeatCount = HUGE;
        //旋转样式
        self.animation.rotationMode = kCAAnimationRotateAutoReverse;
        // 设置贝塞尔曲线路径
        self.animation.path = circle.CGPath;
        // 将动画对象添加到视图的layer上
        [self.icon_View.layer addAnimation:self.animation forKey:nil];
    }
}

- (void)stopRotating{
    //取得暂停时当前时间
    CFTimeInterval pause = [self.icon_View.layer convertTime:CACurrentMediaTime()fromLayer:nil];
    //速度跟开始时间置为0
    self.icon_View.layer.speed =0.0;
    self.icon_View.layer.beginTime =0.0;
    self.icon_View.layer.timeOffset = pause;
}
@end
