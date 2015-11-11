//
//  ESDatePicker.m
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

#import "ESDatePicker.h"
#import "ESDateHelper.h"
#import "Masonry.h"
#import "ESObjectPool.h"


#if !__has_feature(objc_arc)
#   define __weak__block __block
#   define __wweak
#   define mrelease(obj) [obj release]
#   define mretain(obj) [obj retain]
#else
#   define __wweak __weak
#   define __weak__block __weak
#   define mrelease(obj)
#   define mretain(obj) obj
#endif

@interface _ESDatePickerTableViewCell : UITableViewCell
{
    NSMutableArray *_buttons;
    __wweak ESDatePicker *_datePicker;
}
@property (nonatomic, retain) NSDate *date;
@end

@implementation _ESDatePickerTableViewCell
@synthesize date=_date;

#pragma mark - Constructor
// ____________________________________________________________________________________________________________________

- (instancetype)initWithDatePicker:(ESDatePicker *)datePicker
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"]) {
        _datePicker = datePicker;
        [self setOpaque:YES];
        CGFloat tw = self.frame.size.width;
        [self setBackgroundColor:[UIColor clearColor]];
        const CGFloat lineHeight = 1.0f / [[UIScreen mainScreen] scale];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        _buttons = [[NSMutableArray alloc] init];
        UIControl *p = nil;
        UIControl *firstButton = nil;
        for (NSInteger i = 0; i < 7; i++) {
            UIControl *btn = [[UIControl alloc] init];
            [self addSubview:btn];
            [btn setTag:i];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                if (p == nil) {
                    make.left.equalTo(self.mas_left);
                } else {
                    make.width.equalTo(firstButton);
                    make.left.equalTo(p.mas_right);
                    if (i == 6) {
                        make.right.equalTo(self.mas_right);
                    }
                }
                make.top.equalTo(self.mas_top);
                make.bottom.equalTo(self.mas_bottom);
            }];
            if (p == nil) {
                firstButton = btn;
            }
            p = btn;
            [btn addTarget:self action:@selector(_up:) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            [btn addTarget:self action:@selector(_click:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(_down:) forControlEvents:UIControlEventTouchDown];
            
            CGFloat w = (tw / 7.0f) / 1.5;
            UIView *bg = [[UIView alloc] init];
            [bg setUserInteractionEnabled:NO];
            [btn addSubview:bg];
            [bg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(w));
                make.height.equalTo(@(w));
                make.center.equalTo(btn);
            }];
            [bg setTag:200];
            [bg.layer setCornerRadius:(w / 2)];
            if (_datePicker.shouldShowCurrentDay) {
                bg.layer.borderWidth = 0;
                bg.layer.borderColor = [_datePicker.selectedColor CGColor];
            }
            mrelease(bg);
            
            UILabel *label = [[UILabel alloc] init];
            [btn addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(btn);
            }];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTag:100];
            [label setFont:_datePicker.labelFont];
            [label setNumberOfLines:0];
            mrelease(label);
            [_buttons addObject:btn];
            mrelease(btn);
            
            if (_datePicker.showVerticalLines) {
                UIView *line = [[UIView alloc] init];
                [line setBackgroundColor:_datePicker.lineColor];
                [self addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@(lineHeight));
                    make.top.equalTo(self.mas_top);
                    make.bottom.equalTo(self.mas_bottom);
                    make.right.equalTo(btn.mas_right);
                }];
                mrelease(line);
            }
        }
        
        if (_datePicker.shouldShowHorizontalLines) {
            UIView *line = [[UIView alloc] init];
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.height.equalTo(@(lineHeight));
            }];
            [line setBackgroundColor:_datePicker.lineColor];
            mrelease(line);
        }
    }
    return self;
}

- (void)_up:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor clearColor]];
}

- (void)_down:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithWhite:0 alpha:.1]];
}

- (void)_click:(UIButton *)sender
{
    NSDate *d = [_date dateByAddingDays:sender.tag];
    [_datePicker setSelectedDate:d];
    if ([_datePicker.delegate respondsToSelector:@selector(datePicker:dateSelected:)]) {
        [_datePicker.delegate datePicker:_datePicker dateSelected:d];
    }
}

#pragma mark - Properties
// ____________________________________________________________________________________________________________________

- (void)setDate:(NSDate *)aDate
{
    mrelease(_date);
    _date = mretain(aDate);
    [self setBackgroundColor:_datePicker.backgroundColor];
    NSDate *d = _date;
    NSDateFormatter *fm = [[NSDateFormatter alloc] init];
    [fm setLocale:_datePicker.locale];
    [fm setDateFormat:@"d"];
    for (NSInteger i = 0; i < 7; i++) {
        UIControl *btn = _buttons[i];
        UILabel *lbl = (UILabel *)[btn viewWithTag:100];
        if (d.day == 1) {
            [fm setDateFormat:@"LLL'\n'd"];
        } else {
            [fm setDateFormat:@"d"];
        }
        BOOL b = [d isSameDay:_datePicker.selectedDate];
        UIView *bg = [btn viewWithTag:200];
        
        if (b) {
            [bg setBackgroundColor:_datePicker.selectedColor];
        } else {
            [bg setBackgroundColor:[UIColor clearColor]];
        }
        bg.layer.borderWidth = [d isToday] && _datePicker.shouldShowCurrentDay ? 1 : 0;
        
        
        if (b) {
            [lbl setTextColor:_datePicker.selectedLabelTextColor];
        } else {
            [lbl setTextColor:_datePicker.labelTextColor];
            
        }
        
        if (_datePicker.hasZebraPrint && (d.month % 2) == 0) {
            [lbl setBackgroundColor:[UIColor colorWithWhite:0 alpha:.03]];
        } else {
            [lbl setBackgroundColor:[UIColor clearColor]];
        }
        [lbl setText:[fm stringFromDate:d]];
        d = [d dateByAddingDays:1];
    }
    mrelease(fm);
}

#pragma mark - Destructor
// ____________________________________________________________________________________________________________________

- (void)dealloc
{
    _datePicker = nil;
    mrelease(_buttons);
    mrelease(_date);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end


@interface ESDatePicker () <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    BOOL _dragVisible;
    NSDate *_beginDate;
    ESObjectPool *_objectPool;
    NSDate *_endDate;
    NSDateFormatter *_monthDateFormatter;
    NSInteger _rows;
    UIScrollView *_monthScrollView;
    UIView *_monthScrollViewContainer;
    NSMutableDictionary *_monthViews;
}
- (void)_init;
- (void)_endDrag;
- (void)_showDrag:(BOOL)show;
@end

@implementation ESDatePicker
@synthesize visibleRows=_visibleRows,rowHeight=_rowHeight,beginOfWeek=_beginOfWeek,zebraPrint,monthIndicatorFont=_monthIndicatorFont,labelFont=_labelFont,monthIndicatorTextColor=_monthIndicatorTextColor,labelTextColor=_labelTextColor,selectedDate=_selectedDate,delegate,selectedColor=_selectedColor,selectedLabelTextColor=_selectedLabelTextColor,lineColor=_lineColor,showHorizontalLines=_showHorizontalLines,showVerticalLines=_showVerticalLines,locale=_locale,showCurrentDay=_showCurrentDay;

- (instancetype)initWithDelegate:(id<ESDatePickerDelegate>)aDelegate
{
    
    if (self = [super init]) {
        [self _init];
        [self setDelegate:aDelegate];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    _monthScrollView = [[UIScrollView alloc] init];
    [self addSubview:_monthScrollView];
    [_monthScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_monthScrollView setUserInteractionEnabled:NO];
    _monthScrollViewContainer = [[UIView alloc] init];
    [_monthScrollView addSubview:_monthScrollViewContainer];
    [_monthScrollViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_monthScrollView);
        make.width.equalTo(_monthScrollView.mas_width);
        make.height.equalTo(@(0));
    }];
    mrelease(_monthScrollViewContainer);
    _selectedDate = mretain([NSDate date]);
    
    _objectPool = mretain([ESObjectPool dynamicObjectPool]);
    _monthViews = [[NSMutableDictionary alloc] init];
    
    _monthIndicatorFont = mretain([UIFont boldSystemFontOfSize:17]);
    _labelFont = mretain([UIFont systemFontOfSize:12]);
    _monthIndicatorTextColor = mretain([UIColor blackColor]);
    _labelTextColor = mretain([UIColor blackColor]);
    _locale = mretain([NSLocale currentLocale]);
    _showVerticalLines = YES;
    _showHorizontalLines = YES;
    _lineColor = mretain([UIColor colorWithWhite:0 alpha:0.075]);
    _selectedColor = mretain([UIColor colorWithRed:(160.0f / 255.0f) green:(235.0f / 255.0f) blue:(255.0f / 255.0f) alpha:1]);
    _selectedLabelTextColor = mretain([UIColor whiteColor]);
    
    
    __weak__block typeof(self) blockSelf = self;
    __weak__block typeof(_monthScrollViewContainer) blockMonthScrollViewContainer = _monthScrollViewContainer;
    [_objectPool allocObjectsWithCapacity:4 withClass:[UILabel class] withInitBlock:^(UILabel *label) {
        [label performSelector:NSSelectorFromString(@"init")];
        [label setHidden:YES];
        [blockMonthScrollViewContainer addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(blockMonthScrollViewContainer.mas_left);
            make.right.equalTo(blockMonthScrollViewContainer.mas_right);
            make.height.equalTo(@30);
            make.top.equalTo(blockMonthScrollViewContainer.mas_top).offset(0);
        }];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:blockSelf.monthIndicatorFont];
    }];
    
    _beginOfWeek = 2;
    [self setZebraPrint:YES];
    _tableView = [[UITableView alloc] init];
    [_tableView setDelegate:self];
    [_tableView setOpaque:YES];
    [_tableView setBackgroundView:nil];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setDataSource:self];
    [_tableView setSeparatorColor:[UIColor redColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    _showCurrentDay = YES;
    [_monthScrollView setHidden:YES];
    mrelease(_tableView);
    mrelease(_monthScrollView);
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self setVisibleRows:5];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [_tableView setBackgroundColor:backgroundColor];
}

#pragma mark - Properties
// ____________________________________________________________________________________________________________________

- (void)setSelectedDate:(NSDate *)selectedDate
{
    mrelease(_selectedDate);
    _selectedDate = mretain(selectedDate);
    [_tableView reloadData];
}

- (void)setMonthIndicatorFont:(UIFont *)monthIndicatorFont
{
    mrelease(_monthIndicatorFont);
    _monthIndicatorFont = mretain(monthIndicatorFont);
    for (UILabel *lbl in _objectPool.objects) {
        [lbl setFont:_monthIndicatorFont];
    }
}

- (void)setBeginOfWeek:(NSInteger)beginOfWeek
{
    _beginOfWeek = beginOfWeek;
    [_tableView reloadData];
}

- (void)setMonthIndicatorTextColor:(UIColor *)monthIndicatorTextColor
{
    mrelease(_monthIndicatorTextColor);
    _monthIndicatorTextColor = mretain(monthIndicatorTextColor);
    for (UILabel *lbl in _objectPool.usedObjects) {
        [lbl setTextColor:_monthIndicatorTextColor];
    }
}

- (void)setLabelFont:(UIFont *)labelFont
{
    mrelease(_labelFont);
    _labelFont = mretain(labelFont);
    [_tableView reloadData];
}

- (void)setLineColor:(UIColor *)lineColor
{
    mrelease(_lineColor);
    _lineColor = mretain(lineColor);
    [_tableView reloadData];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    mrelease(_selectedColor);
    _selectedColor = mretain(selectedColor);
    [_tableView reloadData];
}

- (void)setSelectedLabelTextColor:(UIColor *)selectedLabelTextColor
{
    mrelease(_selectedLabelTextColor);
    _selectedLabelTextColor = mretain(selectedLabelTextColor);
    [_tableView reloadData];
}

- (void)setShowHorizontalLines:(BOOL)showHorizontalLines
{
    _showHorizontalLines = showHorizontalLines;
    [_tableView reloadData];
}

- (void)setShowCurrentDay:(BOOL)showCurrentDay
{
    _showCurrentDay = showCurrentDay;
    [_tableView reloadData];
}

- (void)setShowVerticalLines:(BOOL)showVerticalLines
{
    _showVerticalLines = showVerticalLines;
    [_tableView reloadData];
}

- (void)setLabelTextColor:(UIColor *)labelTextColor
{
    mrelease(_labelTextColor);
    _labelTextColor = mretain(labelTextColor);
    [_tableView reloadData];
}

- (void)setRowHeight:(CGFloat)aRowHeight
{
    _rowHeight = aRowHeight;
    _visibleRows = ceil(self.frame.size.height / _rowHeight);
}

- (void)setVisibleRows:(NSInteger)aVisibleRows
{
    _visibleRows = aVisibleRows;
    _rowHeight = (self.frame.size.height / _visibleRows);
}

- (void)setLocale:(NSLocale *)locale
{
    mrelease(_locale);
    _locale = mretain(locale);
    [_tableView reloadData];
}

#pragma mark - Methods
// ____________________________________________________________________________________________________________________

- (void)scrollToDate:(NSDate *)date animated:(BOOL)animated
{
    NSInteger weeksDif = [date weeksFromDate:_beginDate];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weeksDif inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)show
{
    NSDate *d = [[NSDate date] dateByAddingYears:5];
    [self showDates:[NSDate date] :d];
}

- (void)showDates:(NSDate *)beginDate :(NSDate *)endDate
{
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    mrelease(_beginDate);
    mrelease(_endDate);
    
    beginDate = [[beginDate dateAtBeginningOfDay] dateBySettingDays:1];
    beginDate = [beginDate dateBySettingWeekDay:self.beginOfWeek];
    endDate = [[endDate dateAtBeginningOfDay] dateBySettingDays:1];
    endDate = [endDate dateBySettingWeekDay:self.beginOfWeek];
    endDate = [endDate dateByAddingMonths:1];
    
    _beginDate = mretain(beginDate);
    _endDate = mretain(endDate);
    _rows = [_endDate weeksFromDate:_beginDate];
    [_monthScrollViewContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(_rows * self.rowHeight));
    }];
    [_tableView reloadData];
    [self scrollToDate:[self.selectedDate dateBySettingDays:1] animated:NO];
}

#pragma mark - UITableView Delegate and Datasource methods
// ____________________________________________________________________________________________________________________

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    _ESDatePickerTableViewCell *cell = (_ESDatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[_ESDatePickerTableViewCell alloc] initWithDatePicker:self];
#if !__has_feature(objc_arc)
        [cell autorelease];
#endif
    }
    NSInteger index = [indexPath row];
    NSDate *date = [_beginDate dateByAddingWeeks:index];
    if (date.weekOfMonth == 3) {
        UILabel *lbl = (UILabel *)[_objectPool pull];
        [lbl setHidden:NO];
        _monthViews[@(index)] = lbl;
        
        [lbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.rowHeight));
            make.top.equalTo(_monthScrollViewContainer.mas_top).offset(self.rowHeight * index);
        }];
        
        if (_monthDateFormatter == nil) {
            NSDateFormatter *fm = [[NSDateFormatter alloc] init];
            [fm setLocale:self.locale];
            [fm setDateFormat:@"MMMM YYYY"];
            _monthDateFormatter = fm;
        }
        [lbl setText:[_monthDateFormatter stringFromDate:date]];
    }
    [cell setDate:date];
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *n = @(indexPath.row);
    if (_monthViews[n] != nil) {
        UILabel *lbl = _monthViews[n];
        [_objectPool push:lbl];
        [_monthViews removeObjectForKey:n];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_monthScrollView setContentOffset:scrollView.contentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(datePickerDragStarted:)]) {
        [self.delegate datePickerDragStarted:self];
    }
    [self _showDrag:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self _endDrag];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self _endDrag];
}

- (void)_endDrag
{
    [self _showDrag:NO];
    [_tableView setContentOffset:CGPointMake(0, floorf(_tableView.contentOffset.y / self.rowHeight) * self.rowHeight) animated:YES];
}

- (void)_showDrag:(BOOL)show
{
    if (_dragVisible == show) { return; }
    
    _dragVisible = show;
    [_monthScrollView setHidden:NO];
    [_monthScrollView setAlpha:(show ? 0 : 1)];
    [UIView animateWithDuration:(show ? .125 : .25) delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [_monthScrollView setAlpha:(!show ? 0 : 1)];
        [_tableView setAlpha:(show ? .25 : 1)];
    } completion:^(BOOL finished) {
        if (!show) {
            [_monthScrollView setHidden:YES];
        }
    }];
}

#pragma mark - Destructor
// ____________________________________________________________________________________________________________________

- (void)dealloc
{
    mrelease(_selectedDate);
    mrelease(_beginDate);
    mrelease(_monthIndicatorTextColor);
    mrelease(_monthIndicatorFont);
    mrelease(_selectedColor);
    mrelease(_lineColor);
    mrelease(_locale);
    mrelease(_selectedLabelTextColor);
    self.delegate = nil;
    mrelease(_labelTextColor);
    mrelease(_labelFont);
    mrelease(_monthViews);
    mrelease(_objectPool);
    mrelease(_monthDateFormatter);
    mrelease(_endDate);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end
