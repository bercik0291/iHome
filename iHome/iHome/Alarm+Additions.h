//
//  Alarm+Additions.h
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "Alarm.h"

@interface Alarm (Additions)
+ (Alarm *)createNewAlarmWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context;
@end
