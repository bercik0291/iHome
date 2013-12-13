//
//  HomeDriver.h
//  iHome
//
//  Created by Hubert Drąg on 12.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_SERVICE_HOST @"http://192.168.1.3"
#define APP_SERVICE_PATH @"/$"

@interface HomeDriver : NSObject

+ (HomeDriver *)mainDriver;

- (void)turnOptionWithType:(NSInteger)type;

// lights
- (void)turnLightsOn;
- (void)turnLightsOff;

// kettle
- (void)turnKettleOn;

- (void)createLocalNotificationWithDate:(NSDate *)date;
@end
