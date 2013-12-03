//
//  Alarm.h
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Option;

@interface Alarm : NSManagedObject

@property (nonatomic, retain) NSDate * clock;
@property (nonatomic, retain) NSNumber * isOn;
@property (nonatomic, retain) NSSet *options;
@end

@interface Alarm (CoreDataGeneratedAccessors)

- (void)addOptionsObject:(Option *)value;
- (void)removeOptionsObject:(Option *)value;
- (void)addOptions:(NSSet *)values;
- (void)removeOptions:(NSSet *)values;

@end
