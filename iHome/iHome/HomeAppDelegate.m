//
//  HomeAppDelegate.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "HomeAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

// other
#import "HDSharedDocument.h"
#import "NSDictionary+JSON.h"
#import "HomeDriver.h"

// models
#import "Option+Additions.h"
#import "Alarm+Additions.h"

@interface HomeAppDelegate () <UIAlertViewDelegate>
@property (nonatomic, strong) UILocalNotification *localNotification;
@property (nonatomic, strong) Alarm *currentAlarm;
@property (nonatomic, strong) AVAudioPlayer *player;
@end

@implementation HomeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
   	[[HDSharedDocument defaultDocument] openDocument:^{
        
        NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"DefaultObject" withExtension:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        NSDictionary *dict = [NSDictionary dictionaryFromJSON:jsonData];
        
        [Option loadOptionsFromArray:[dict objectForKey:@"options"] toContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
    }];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // get pointer to notification
    self.localNotification = notification;
    
    [self turnOptionsWithState:YES];
    
    // show alert view
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"Alarm" delegate:self cancelButtonTitle:@"Drzemka" otherButtonTitles:@"Ok", nil];
    
    [self.player play];
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // drzemka
            [self rescheduleNotification]; break;
        case 1: // ok
            [self cancelNotification]; break;
            break;
        default:
            break;
    }
    
    [self.player stop];
}

- (void)rescheduleNotification
{
    // cancel notification
    [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
    
    // set new fire date
    NSDate *date = [NSDate dateWithTimeInterval:30 sinceDate:self.localNotification.fireDate];
    self.localNotification.fireDate = date;
    
    // schedule notification
    [[UIApplication sharedApplication] scheduleLocalNotification:self.localNotification];
    
    // change alarm object (core data)
    [self changeAlarmWithState:YES];
}

- (void)cancelNotification
{
    // change alarm object (core data)
    [self changeAlarmWithState:NO];
    
    // turn kettle
    [self turnKettleOn];
    
    // cancel notification
    [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
}

- (void)changeAlarmWithState:(BOOL)state
{
    self.currentAlarm.isOn = @(state);
    
    [self turnOptionsWithState:NO];
}

- (void)turnOptionsWithState:(BOOL)state
{
    // trun all options of this alarm
    for (Option *option in self.currentAlarm.options) {
        
        if (![option.title isEqualToString:@"Czajnik"]) {
            
            int opt = state ? [option.codeOn integerValue] : [option.codeOff integerValue];;
            [[HomeDriver mainDriver] turnOptionWithType:opt];
            option.isOn = @(state);
        }
    }
    
    [self save];
}

- (void)turnKettleOn
{
    [[HomeDriver mainDriver] turnKettleOn];
    
    for (Option *option in self.currentAlarm.options) {
        if ([[option title] isEqualToString:@"Chajnik"]) {
            option.isOn = @(YES);
            break;
        }
    }
    
    [self save];
}

- (void)save
{
    [[[[HDSharedDocument defaultDocument] document] managedObjectContext] save:nil];
    [[HDSharedDocument defaultDocument] saveDocument];
}

- (AVAudioPlayer *)player
{
    if (!_player) {
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/alarm.mp3", [[NSBundle mainBundle] resourcePath]]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.numberOfLoops = INT64_MAX;
    }
    
    return _player;
}

- (Alarm *)currentAlarm
{
    if (!_currentAlarm) {
        _currentAlarm = [Alarm getAlarmWithFireDate:self.localNotification.fireDate withContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
    }
    
    return _currentAlarm;
}

@end
