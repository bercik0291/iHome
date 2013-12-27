//
//  UIApplication+Additions.m
//  iHome
//
//  Created by Hubert Drąg on 27.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "UIApplication+Additions.h"


@implementation UIApplication (Additions)

- (BOOL)localNotificationExistWithDate:(NSDate *)date
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *local in notifications) {
        if ([local.fireDate isEqualToDate:date]) {
            return YES;
        }
    }
    
    return NO;
}

@end
