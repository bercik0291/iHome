//
//  OptionViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

// controller
#import "OptionViewController.h"

// other
#import "HDSharedDocument.h"

// model
#import "Option+Additions.h"

@implementation OptionViewController

- (NSPredicate *)predicate
{
    return nil;
}

- (NSArray *)sortDescriptors
{
    return @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (NSManagedObjectContext *)context
{
    return [[[HDSharedDocument defaultDocument] document] managedObjectContext];
}

- (NSString *)entityName
{
    return @"Option";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Option *option = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = option.title;
    
    if ([_selectedOptions containsObject:option]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Option *option = [self.resultsController objectAtIndexPath:indexPath];
    
    if ([self.selectedOptions containsObject:option]) {
        [self.selectedOptions removeObject:option];
    } else {
        [self.selectedOptions addObject:option];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)selectedOptions
{
    if (!_selectedOptions) {
        _selectedOptions = [NSMutableArray new];
    }
    return _selectedOptions;
}

@end
