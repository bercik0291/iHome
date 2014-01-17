//
//  HomeDriver.m
//  iHome
//
//  Created by Hubert Drąg on 12.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "HomeDriver.h"

#define HOME_TYPE(x) [NSString stringWithFormat:@"%d", x]

typedef NS_ENUM(NSInteger, HomeDriverType)
{
    HomeDriverTypeKettleOn = 14,
    HomeDriverTypeKettleOff = 32,
    HomeDriverTypeLightsOn = 5,
    HomeDriverTypeLightsOff = 6
};

@interface HomeDriver()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation HomeDriver {
    NSInteger _type;
    NSInteger _typeOff;
}

+ (HomeDriver *)mainDriver
{
    static HomeDriver *mainDriver;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainDriver = [[HomeDriver alloc] init];
    });
    
    return mainDriver;
}

- (NSURL *)baseURL
{
    //  return service base URL
    return [[NSURL URLWithString:[self resourcePath]
                   relativeToURL:[NSURL URLWithString:[self host]]] absoluteURL];
}

- (NSString *)host
{
    return APP_SERVICE_HOST;
}

- (NSString *)resourcePath
{
    return [APP_SERVICE_PATH stringByAppendingString:HOME_TYPE(_type)];
}

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
    }
    return _webview;
}

#pragma mark - Home Functions

- (void)turnOptionWithType:(NSInteger)type
{
    _type = type;
    
    [self turnOption];
}

- (void)turnLightsOn
{
    // get home type
    _type = HomeDriverTypeLightsOn;
    
    [self turnOption];
}

- (void)turnLightsOff
{
    // get home type
    _type = HomeDriverTypeLightsOff;
    
    [self turnOption];
}

- (void)turnKettleOn
{
    // firstly desactive off option
    _type = HomeDriverTypeKettleOn;
    
   // _typeOff = HomeDriverTypeKettleOffNo;
    [self turnOption];

}

- (void)turnKettleOff
{
    _type = HomeDriverTypeKettleOff;
  //  _typeOff = HomeDriverTypeKettleOnNo;

    [self turnOption];
}

- (void)createLocalNotificationWithDate:(NSDate *)date
{
    // create local notification
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = date;
    alarm.alertBody = NSLocalizedString(@"Alarm", nil);
    alarm.alertAction = NSLocalizedString(@"Wyłącz", nil);
    alarm.applicationIconBadgeNumber = 0;
    alarm.timeZone = [NSTimeZone defaultTimeZone];
    alarm.soundName = @"alarm.mp3";
    
    // schedule local notification
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
}

- (void)removeLocalNotigicationWithDate:(NSDate *)date
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *local in notifications) {
        if ([local.fireDate isEqualToDate:date]) {
            [[UIApplication sharedApplication] cancelLocalNotification:local];
            return;
        }
    }
}


- (void)turnOption
{
    // create request
    NSURLRequest *req = [NSURLRequest requestWithURL:[self baseURL]];
    
    // load request in web view
    [self.webview loadRequest:req];
}

@end
