//
//  AddAlarmViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

// controller
#import "AddAlarmViewController.h"
#import  "OptionViewController.h"

// model
#import "Alarm+Additions.h"

// other
#import "HDSharedDocument.h"

@interface AddAlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) OptionViewController *optionViewController;
@end

@implementation AddAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Button's Actions

- (IBAction)saveButtonAction:(id)sender
{
    // compare date
    NSComparisonResult result = [[NSDate date] compare:[self.datePicker date]];

    NSDate *date;
    
    // set date
    if (result == NSOrderedDescending) {
        date = [NSDate dateWithTimeInterval:86400 sinceDate:[self.datePicker date]];
    } else {
        date = [self.datePicker date];
    }

    // create local notification
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.fireDate = date;
    alarm.alertBody = @"Alarm";
    alarm.alertAction = @"Drzemka";
    alarm.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    alarm.timeZone = [NSTimeZone defaultTimeZone];
    
    // schedule local notification
    [[UIApplication sharedApplication] scheduleLocalNotification:alarm];
    
    // create new alarm
    NSDictionary *params = @{@"clock" : date,
                             @"options" : _optionViewController.selectedOptions
                             };
    [Alarm createNewAlarmWithDictionary:params withContext:[[[HDSharedDocument defaultDocument] document] managedObjectContext]];
    
    // save
    [self save];
}

- (IBAction)cancelButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Additions

- (void)save
{
    [[[[HDSharedDocument defaultDocument] document] managedObjectContext] performBlock:^{
        [[[[HDSharedDocument defaultDocument] document] managedObjectContext] save:nil];
        [[HDSharedDocument defaultDocument] saveDocument];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // dismiss view controller
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Options"]) {
        _optionViewController = (OptionViewController *)[segue destinationViewController];
    }
}

@end
