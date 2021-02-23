//
//  JDBDatePickerView.h
//  NOVASleep
//
//  Created by db J on 2020/9/8.
//  Copyright © 2020 NOVA. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^returnHoursAndMinute)(NSInteger hours,NSInteger minute);

@interface JDBDatePickerView : UIView
@property (nonatomic, assign) NSInteger hoursIndex;
@property (nonatomic, assign) NSInteger minuteIndex;
@property (nonatomic, copy) returnHoursAndMinute completeHandler;

@end

NS_ASSUME_NONNULL_END
