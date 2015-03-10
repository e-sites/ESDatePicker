//
//  ESDatePicker.h
//  ios-library
//
//  Created by Bas van Kuijck on 04-08-2014.
//
//
//  Copyright (c) 2014, e-sites B.V. (www.e-sites.nl)
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
//  Neither the name of the e-sites B.V. nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>
@class ESDatePicker;
@protocol ESDatePickerDelegate <NSObject>
@required
- (void)datePicker:(ESDatePicker *)datePicker dateSelected:(NSDate *)date;
@end

@interface ESDatePicker : UIView


// __________________________________________________________________________________________

/// @name Properties

// __________________________________________________________________________________________


/*!
 *  The height of the rows
 * @discussion Default value is 20% of the height of the view itself
 */
@property (nonatomic, readwrite) CGFloat rowHeight;

/*!
 * The number of rows that should be visible
 * @discussion Default = 5
 */
@property (nonatomic, readwrite) NSInteger visibleRows;

/*!
 * The day that marks the beginning of the week
 * @discussion Default = 2 (monday)
 */
@property (nonatomic, readwrite) NSInteger beginOfWeek;


/**
 * Should the months be seperated using different colors
 * @discussion Default = YES
 */
@property (nonatomic, readwrite, getter=hasZebraPrint) BOOL zebraPrint;

/**
 * The font of the labels of the individuel days
 * @discussion Default = systemFont size 12
 */
@property (nonatomic, retain) UIFont *labelFont;

/**
 * The font of the month indicators
 * @discussion Default = bold system font size 17
 */
@property (nonatomic, retain) UIFont *monthIndicatorFont;

/**
 * The color of the month indicators
 * @discussion Default = black
 */
@property (nonatomic, retain) UIColor *monthIndicatorTextColor;


/**
 * The color of the labels of the individual days
 * @discussion Default = black
 */
@property (nonatomic, retain) UIColor *labelTextColor;

/**
 * The text color of the current selected day
 * @discussion Default = white
 */
@property (nonatomic, retain) UIColor *selectedLabelTextColor;

/**
 * Should the current day be highlighted
 * @discussion Default = YES
 */
@property (nonatomic, readwrite, getter=shouldShowCurrentDay) BOOL showCurrentDay;

/**
 * The color of the dividers
 * @discussion Default = light grey
 */
@property (nonatomic, retain) UIColor *lineColor;


/**
 * The current selected date
 * @discussion Default = today
 */
@property (nonatomic, retain) NSDate *selectedDate;


/**
 * The locale that needs to be used for formatting the days
 * @discussion Default = system default
 */
@property (nonatomic, retain) NSLocale *locale;


/**
 * The delegate to send methods to
 */
@property (nonatomic, assign) id<ESDatePickerDelegate> delegate;

/**
 * Should the vertical lines be shown
 * @discussion Default = YES
 */
@property (nonatomic, readwrite, getter=shouldShowVerticalLines) BOOL showVerticalLines;

/**
 * Should the horizontal lines be shown
 * @discussion Default = YES
 */
@property (nonatomic, readwrite, getter=shouldShowHorizontalLines) BOOL showHorizontalLines;



/**
 * The background color of the current selected day
 * @discussion Default = light blue
 */
@property (nonatomic, retain) UIColor *selectedColor;


// __________________________________________________________________________________________

/// @name Constructor

// __________________________________________________________________________________________

/**
 *  The default constructor
 *
 *  @param aDelegate (id<ESDatePickerDelegate>)
 *
 *  @return a `ESDatePicker` instance
 */
- (instancetype)initWithDelegate:(id<ESDatePickerDelegate>)aDelegate;


// __________________________________________________________________________________________

/// @name Public methods

// __________________________________________________________________________________________

/**
 *  Sets the date range
 *
 *  @param beginDate NSDate*
 *  @param endDate  NSDate *
 */
- (void)showDates:(NSDate *)beginDate :(NSDate *)endDate;

/**
 *  This sets the date range to today + 5 years
 */
- (void)show;

/**
 *  Scroll to a specific date
 *
 *  @param date     NSDate *
 *  @param animated BOOL
 */
- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated;
@end
