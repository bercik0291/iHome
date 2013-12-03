//
//  JMFetchTableViewController.h
//  OrderBook
//
//  Created by Jan Mazurczak on 30.11.2012.
//  Copyright (c) 2012 Jan Mazurczak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JMFetchTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSString *searchString;

@property (copy, nonatomic) NSString *entityName;
@property (copy, nonatomic) NSPredicate *predicate;
@property (copy, nonatomic) NSArray *sortDescriptors;
@property (copy, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) NSIndexPath *lastEditedIndex;
- (NSPredicate *)predicateSearchWord:(NSString *)word;

- (NSFetchRequest*)fetchRequest;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(NSManagedObject *)object;
- (void)performFetch;
- (void)fetchReset;
@end
