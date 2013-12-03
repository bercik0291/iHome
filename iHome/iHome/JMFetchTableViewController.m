//
//  JMFetchTableViewController.m
//  OrderBook
//
//  Created by Jan Mazurczak on 30.11.2012.
//  Copyright (c) 2012 Jan Mazurczak. All rights reserved.
//

#import "JMFetchTableViewController.h"

@interface JMFetchTableViewController () {
}

@end

@implementation JMFetchTableViewController
@synthesize resultsController = _resultsController;

#pragma mark - to override:

- (NSPredicate *)predicate {
    return _predicate;
}

- (NSString *)entityName {
    return _entityName;
}

- (NSArray *)sortDescriptors {
    return _sortDescriptors;
}

- (NSPredicate *)predicateSearchWord:(NSString *)word {
    return [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",word];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForObject:(NSManagedObject *)object {
    static NSString *cellID = @"DefaultCellForFetchTableView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.textLabel setText:[object valueForKey:@"name"]];
    return cell;
}

#pragma mark - resultsController

- (void)fetchReset {
    if (_resultsController) {
        self.resultsController = nil;
        [self resultsController];
    }
}

- (NSFetchedResultsController*)resultsController {
    if (_resultsController==nil) {
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:[self context] sectionNameKeyPath:[self sectionNameKeyPath] cacheName:nil];
    }
    return _resultsController;
}

- (void)setResultsController:(NSFetchedResultsController *)resultsController {
    if (resultsController != _resultsController) {
        _resultsController.delegate = nil;
        _resultsController = resultsController;
        _resultsController.delegate = self;
        [self performFetch];
    }
}

-(void)performFetch {
    if (_resultsController) {
        [_resultsController performFetch:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - appearance

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self resultsController];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.resultsController = nil;
}

#pragma mark - fetch change

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    /*switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }*/
    [self.tableView reloadData];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            _lastEditedIndex = newIndexPath;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

#pragma mark - tableView source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_resultsController sections] count];
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_resultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView cellForObject:[_resultsController objectAtIndexPath:indexPath]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_resultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [_resultsController sectionIndexTitles];
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_resultsController sectionForSectionIndexTitle:title atIndex:index];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - searching

- (NSFetchRequest*)fetchRequest {
    
    NSFetchRequest *result = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    NSPredicate *mainPredicate = [self predicate];
    
    NSMutableArray *predicates = [NSMutableArray array];
    if ([self searchString]) {
        NSMutableCharacterSet *seperatorSet = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [seperatorSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
        NSArray *words = [[self searchString] componentsSeparatedByCharactersInSet:seperatorSet];
        for (NSString *word in words) {
            if ([word length]>0) {
                [predicates addObject:[self predicateSearchWord:word]];
            }
        }
    }
    if ([predicates count]>0) {
        if (mainPredicate) {
            [predicates insertObject:mainPredicate atIndex:0];
        }
        result.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    } else {
        result.predicate = mainPredicate;
    }
    result.sortDescriptors = [self sortDescriptors];
    return result;
}

- (void)setSearchString:(NSString *)searchString {
    if (_searchString != searchString) {
        _searchString = searchString;
        [self fetchReset];
    }
}




@end
