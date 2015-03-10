ESDatePicker
============

[![Build](https://travis-ci.org/e-sites/ESDatePicker.svg)](https://travis-ci.org/e-sites/ESDatePicker)
[![Platform](https://cocoapod-badges.herokuapp.com/p/ESDatePicker/badge.png)](http://cocoadocs.org/docsets/ESDatePicker)
[![Version](https://cocoapod-badges.herokuapp.com/v/ESDatePicker/badge.png)](http://cocoadocs.org/docsets/ESDatePicker)
[![Coverage Status](https://coveralls.io/repos/e-sites/ESDatePicker/badge.png)](https://coveralls.io/r/e-sites/ESDatePicker)

A custom date picker similar like the date picker of the Sunrise app and the Google Calendar android app

## Example
<br>
![Example](https://raw.github.com/e-sites/ESDatePicker/master/Assets/example2.gif)


## Features

- Works both in ARC as in MRC
- Choose your own colors (background, highlight, selection, text)
- Choose your own font
- Completelly usable in your own viewcontroller or view

## Installation
Use cocoapods:

	pod 'ESDatePicker'
	
And then import the desired .h file:
	
	#import "ESDatePicker.h"

## Implementation
```objective-c
- (void)viewDidLoad
{
 	ESDatePicker *p = [[ESDatePicker alloc] initWithFrame:CGRectMake(20, 50, 280, 300)];
 	[p setDelegate:self];
    [p show];
    [self.view addSubview:p];
}
	
- (void)datePicker:(ESDatePicker *)datePicker dateSelected:(NSDate *)date
{
	NSLog(@"Selected date: %@", date);
}
```

## Documentation
The official documentation can be found [here](http://cocoadocs.org/docsets/ESDatePicker/).

## Dependencies
- [Masonry](https://github.com/Masonry/Masonry)
- [ESDateHelper](https://github.com/e-sites/ESDateHelper)
- [ESObjectPool](https://github.com/e-sites/ESObjectPool)

## License
Copyright (C) 2014 e-sites, [http://e-sites.nl/](http://www.e-sites.nl/). Licensed under the BSD license.
