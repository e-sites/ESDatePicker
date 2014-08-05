//
//  ESDatePicker.h
//  Datepicker
//
//  Created by Bas van Kuijck on 04-08-14.
//
//

#import <UIKit/UIKit.h>
@class ESDatePicker;
@protocol ESDatePickerDelegate <NSObject>
@required
- (void)datePicker:(ESDatePicker *)datePicker dateSelected:(NSDate *)date;
@end

@interface ESDatePicker : UIView
@property (nonatomic, readwrite) CGFloat rowHeight;
@property (nonatomic, readwrite) NSInteger visibleRows;
@property (nonatomic, readwrite) NSInteger beginOfWeek;
@property (nonatomic, readwrite, getter=hasZebraPrint) BOOL zebraPrint;
@property (nonatomic, retain) UIFont *labelFont;
@property (nonatomic, retain) UIFont *monthIndicatorFont;
@property (nonatomic, retain) UIColor *monthIndicatorTextColor;
@property (nonatomic, retain) UIColor *labelTextColor;
@property (nonatomic, retain) UIColor *selectedLabelTextColor;
@property (nonatomic, retain) UIColor *lineColor;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic, assign) id<ESDatePickerDelegate> delegate;
@property (nonatomic, readwrite, getter=shouldShowVerticalLines) BOOL showVerticalLines;
@property (nonatomic, readwrite, getter=shouldShowHorizontalLines) BOOL showHorizontalLines;
@property (nonatomic, retain) UIColor *selectedColor;
- (instancetype)initWithDelegate:(id<ESDatePickerDelegate>)aDelegate;

- (void)showDates:(NSDate *)beginDate :(NSDate *)endDate;
- (void)show;
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;
@end
