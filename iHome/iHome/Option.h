//
//  Option.h
//  iHome
//
//  Created by Hubert Drąg on 09.01.2014.
//  Copyright (c) 2014 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm;

@interface Option : NSManagedObject

@property (nonatomic, retain) NSNumber * codeOff;
@property (nonatomic, retain) NSNumber * codeOn;
@property (nonatomic, retain) NSNumber * isOn;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *alarm;
@end

@interface Option (CoreDataGeneratedAccessors)

- (void)addAlarmObject:(Alarm *)value;
- (void)removeAlarmObject:(Alarm *)value;
- (void)addAlarm:(NSSet *)values;
- (void)removeAlarm:(NSSet *)values;

@end
