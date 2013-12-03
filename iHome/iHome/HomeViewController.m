//
//  HomeViewController.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

// controller
#import "HomeViewController.h"

// cells
#import "HomeCell.h"

// other
#import "HDSharedDocument.h"

// models
#import "Option+Additions.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

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
    static NSString *CellIdentifier = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell withIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(HomeCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    Option *option = [self.resultsController objectAtIndexPath:indexPath];
    
    cell.titleLabel.text = option.title;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
