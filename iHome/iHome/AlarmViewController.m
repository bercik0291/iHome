//
//  AlarmViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

// controller
#import "AlarmViewController.h"

// cell
#import "AlarmCell.h"

// other
#import "HDSharedDocument.h"
#import "NSDateFormatter+Additions.h"

// models
#import "Alarm+Additions.h"

@interface AlarmViewController ()
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
    Alarm *alarm = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = [[NSDateFormatter defaultDateFormatter] stringFromDate:alarm.clock];
}

@end
