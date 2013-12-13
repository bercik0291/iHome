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
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    self.localNotification = nil;
    
    // change alarm object (core data)
    [self changeAlarmWithState:YES];
}

- (void)cancelNotification
{
    // cancel notification
    [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
    self.localNotification = nil;
    
    // change alarm object (core data)
    [self changeAlarmWithState:NO];
    
    // turn kettle
    [self turnKettleOn];
}

- (void)changeAlarmWithState:(BOOL)state
{
    self.currentAlarm = [Alarm getAlarmWithFireDate:self.localNotification.fireDate withContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
    self.currentAlarm.isOn = @(state);
    
    [self save];

    [self turnOptionsWithState:NO];
}

- (void)turnOptionsWithState:(BOOL)state
{
    // trun all options of this alarm
    for (Option *option in self.currentAlarm.options) {
        
        if ([option.title isEqualToString:@"Czajnik"]) continue;
        else {
            
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

@end
