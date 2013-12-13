//
//  Option.h
//  iHome
//
//  Created by Hubert Drąg on 12.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm;

@interface Option : NSManagedObject

@property (nonatomic, retain) NSNumber * codeOff;
@property (nonatomic, retain) NSNumber * codeOn;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isOn;
@property (nonatomic, retain) Alarm *alarm;

@end
