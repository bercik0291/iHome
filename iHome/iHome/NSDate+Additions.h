//
//  NSDate+Additions.h
//  iHome
//
//  Created by Hubert Drąg on 27.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alarm+Additions.h"
@interface NSDate (Additions)
+ (NSDate *)dateForAlarm:(Alarm *)alarm;
@end
