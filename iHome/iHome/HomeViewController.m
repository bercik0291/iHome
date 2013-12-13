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
#import "HomeDriver.h"

// models
#import "Option+Additions.h"

typedef NS_ENUM(NSInteger, HomeThingType)
{
    HomeThingTypeLights = 0,
    HomeThingTypeKettle,
};

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
    [cell.switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.switchButton setTag:indexPath.row];
}

- (void)switchButtonAction:(UISwitch *)sender
{
    switch (sender.tag) {
            
        case HomeThingTypeLights: {

            if ([sender isOn]) {
                [[HomeDriver mainDriver] turnLightsOn];
            } else {
                [[HomeDriver mainDriver] turnLightsOff];
            }
            
            break;
        }
            
        case HomeThingTypeKettle: {
            
            if ([sender isOn]) {
                [[HomeDriver mainDriver] turnLightsOn];
            } else {
                [[HomeDriver mainDriver] turnLightsOff];
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
