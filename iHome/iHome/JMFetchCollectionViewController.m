//
//  JMFetchCollectionViewController.m
//  OrderBook
//
//  Created by Jan Mazurczak on 30.11.2012.
//  Copyright (c) 2012 Jan Mazurczak. All rights reserved.
//

#import "JMFetchCollectionViewController.h"

@interface JMFetchCollectionViewController () {
}

@end

@implementation JMFetchCollectionViewController
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForObject:(NSManagedObject *)object atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"DefaultCellForFetchCollectionView";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
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
        self.resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self fetchRequest] managedObjectContext:self.context sectionNameKeyPath:[self sectionNameKeyPath] cacheName:nil];
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
        [self.collectionView reloadData];
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
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    /*[self.collectionView performBatchUpdates:^{
        switch(type) {
            case NSFetchedResultsChangeInsert:
                [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
                break;
        }
    } completion:^(BOOL finished) {
        
    }];*/
    [self.collectionView reloadData];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UICollectionView *collectionView = self.collectionView;
    if (type == NSFetchedResultsChangeUpdate) {
        //[collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    } else {
      //  [collectionView performBatchUpdates:^{
            switch(type) {
                case NSFetchedResultsChangeInsert:
                    [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
                    break;
                case NSFetchedResultsChangeDelete:
                    [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    break;
                case NSFetchedResultsChangeMove:
                    [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
                    break;
            }
     //   } completion:^(BOOL finished) {
            
      //  }];
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
}

#pragma mark - collectionView source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [[_resultsController sections] count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_resultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionView:collectionView cellForObject:[_resultsController objectAtIndexPath:indexPath] atIndexPath:indexPath];
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
