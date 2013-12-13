//
//  AlarmViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

// controller
#import "AlarmViewController.h"
#import "EditAlarmViewController.h"

// cell
#import "AlarmCell.h"

// other
#import "HomeDriver.h"
#import "HDSharedDocument.h"
#import "NSDateFormatter+Additions.h"

// models
#import "Alarm+Additions.h"

@interface AlarmViewController ()
@property (nonatomic, strong) Alarm *selectedAlarm;
@end

@implementation AlarmViewController

- (NSPredicate *)predicate
{
    return nil;
}

- (NSArray *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"clock" ascending:YES]];
}

- (NSManagedObjectContext *)context
{
    return [[[HDSharedDocument defaultDocument] document] managedObjectContext];
}

- (NSString *)entityName
{
    return @"Alarm";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlarmCell";
    AlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(AlarmCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    // get alarm object
    Alarm *alarm = [self.resultsController objectAtIndexPath:indexPath];
    
    // fill cell
    cell.titleLabel.text = [[NSDateFormatter defaultDateFormatter] stringFromDate:alarm.clock];
    [cell.switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.switchButton setOn:[alarm.isOn boolValue]];
    [cell.switchButton setTag:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedAlarm = [self.resultsController objectAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source
        Alarm *alarm = [self.resultsController objectAtIndexPath:indexPath];
        [[[[HDSharedDocument defaultDocument] document] managedObjectContext] deleteObject:alarm];
    }
}

#pragma mark - Button's Actions

- (void)switchButtonAction:(UISwitch *)sender
{
    if ([sender isOn]) {
        // get index path
        NSIndexPath *ip = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        // get alarm
        Alarm *alarm = [self.resultsController objectAtIndexPath:ip];

        // update alarm data
        NSDate *date;
        NSComparisonResult result = [[NSDate date] compare:alarm.clock];
        
        if (result == NSOrderedDescending) {
            date = [NSDate dateWithTimeInterval:86400 sinceDate:alarm.clock];
        } else {
            date = alarm.clock;
        }
        
        alarm.isOn = @(YES);
        alarm.clock = date;
        
        // create local notification
        [[HomeDriver mainDriver] createLocalNotificationWithDate:date];
    }
    
    [[[[HDSharedDocument defaultDocument] document] managedObjectContext] save:nil];
    [[HDSharedDocument defaultDocument] saveDocument];
}

- (IBAction)editButtonAction:(id)sender
{
    [self setEditing:!self.isEditing animated:YES];
}

#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"EditAlarm"]) {
//        EditAlarmViewController *vc = [segue destinationViewController];
//        [vc setAlarm:self.selectedAlarm];
//    }
//}

@end
