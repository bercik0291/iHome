//
//  Option.h
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Alarm;

@interface Option : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * codeOn;
@property (nonatomic, retain) NSString * codeOff;
@property (nonatomic, retain) Alarm *alarm;

@end
