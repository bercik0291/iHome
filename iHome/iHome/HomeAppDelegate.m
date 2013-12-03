//
//  HomeAppDelegate.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "HomeAppDelegate.h"
#import "HDSharedDocument.h"
#import "NSDictionary+JSON.h"

#import "Option+Additions.h"
#import "Alarm+Additions.h"

@interface HomeAppDelegate () <UIAlertViewDelegate>
@property (nonatomic, strong) UILocalNotification *localNotification;
@property (nonatomic, strong) UIWebView *webView;
@end

const static NSString *URL =@ "http://192.168.1.10/";

@implementation HomeAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   	[[HDSharedDocument defaultDocument] openDocument:^{
        
        NSURL *jsonURL = [[NSBundle mainBundle] URLForResource:@"DefaultObject" withExtension:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
        NSDictionary *dict = [NSDictionary dictionaryFromJSON:jsonData];
        
        NSArray *options = [dict objectForKey:@"options"];
        for (NSDictionary *params in options) {
            [Option createNewOptionWithDictionary:params withContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
        }
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
    
    // show alert view
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:Nil message:@"Alarm" delegate:self cancelButtonTitle:@"Drzemka" otherButtonTitles:@"Ok", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: // drzemka
            [self rescheduleNotification]; break;
        default:
            [self cancelNotification]; break;
            break;
    }
}

- (void)rescheduleNotification
{
    // cancel notification
    [[UIApplication sharedApplication] cancelLocalNotification:self.localNotification];
    
    // set new fire date
    NSDate *date = [NSDate dateWithTimeInterval:600 sinceDate:self.localNotification.fireDate];
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
    
    // change alarm object (core data)
    [self changeAlarmWithState:NO];
}

- (void)changeAlarmWithState:(BOOL)state
{
    
    Alarm *alarm = [Alarm getAlarmWithFireDate:self.localNotification.fireDate withContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
    alarm.isOn = @(state);
    
//    self.webView = [[UIWebView alloc] init];
//    NSURL *url = [NSURL URLWithString:[URL stringByAppendingString:]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
    
    [[[[HDSharedDocument defaultDocument] document] managedObjectContext] performBlock:^{
        
        [[[[HDSharedDocument defaultDocument] document] managedObjectContext] save:nil];
        [[HDSharedDocument defaultDocument] saveDocument];
    }];
    
}
@end
