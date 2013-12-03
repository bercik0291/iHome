//
//  EditAlarmViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "EditAlarmViewController.h"
#import "OptionViewController.h"

@interface EditAlarmViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) OptionViewController *optionViewController;
@end

@implementation EditAlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.datePicker setDate:self.alarm.clock];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"Options"]) {
        
        _optionViewController = [segue destinationViewController];
        [_optionViewController setSelectedOptions:[NSMutableArray arrayWithArray:[self.alarm.options allObjects]]];
    }
}

@end
