//
//  JMFetchCollectionViewController.h
//  OrderBook
//
//  Created by Jan Mazurczak on 30.11.2012.
//  Copyright (c) 2012 Jan Mazurczak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface JMFetchCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *resultsController;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSString *searchString;

@property (copy, nonatomic) NSString *entityName;
@property (copy, nonatomic) NSPredicate *predicate;
@property (copy, nonatomic) NSArray *sortDescriptors;
@property (copy, nonatomic) NSString *sectionNameKeyPath;
- (NSPredicate *)predicateSearchWord:(NSString *)word;

- (NSFetchRequest*)fetchRequest;

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForObject:(NSManagedObject *)object atIndexPath:(NSIndexPath *)indexPath;
- (void)performFetch;
- (void)fetchReset;
@end
