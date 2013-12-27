//
//  NSDate+Additions.m
//  iHome
//
//  Created by Hubert Drąg on 27.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "NSDate+Additions.h"

#define DAY_TIME 86400.0

@implementation NSDate (Additions)

+ (NSDate *)dateForAlarm:(Alarm *)alarm
{
    // update alarm data
    NSDate *date;
    
    NSComparisonResult result = [[NSDate date] compare:alarm.clock];
    
    if (result == NSOrderedDescending) {
        
        NSTimeInterval diff = [[NSDate date] timeIntervalSinceDate:alarm.clock];
        
        int time = (floor(diff / DAY_TIME));
        
        date = [NSDate dateWithTimeInterval:DAY_TIME * (time + 1) sinceDate:alarm.clock];
        
    } else {
        
        date = alarm.clock;
    }
    
    return date;
}

@end
