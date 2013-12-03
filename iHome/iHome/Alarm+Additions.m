//
//  Alarm+Additions.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "Alarm+Additions.h"
#import "Option+Additions.h"

@implementation Alarm (Additions)

+ (Alarm *)createNewAlarmWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    Alarm *newAlarm = nil;
    
    NSFetchRequest *request = [self alarmFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"clock == %@", [dict objectForKey:@"clock"]];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    if ([array count] > 1) {
        
        // handle error
        
    } else if ([array count] == 0) {
        
        newAlarm = [NSEntityDescription insertNewObjectForEntityForName:@"Alarm" inManagedObjectContext:context];
        newAlarm.clock = [dict objectForKey:@"clock"];
        newAlarm.isOn = [dict objectForKey:@"is_on"];
        
        NSArray *options = [dict objectForKey:@"options"];
        for (Option *option in options) {
            [newAlarm addOptionsObject:option];
        }
        
    } else {
        
        newAlarm = [array lastObject];
        
    }
    
    return newAlarm;
}

+ (Alarm *)getAlarmWithFireDate:(NSDate *)fireDate withContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self alarmFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"clock == %@", fireDate];
    
    return [[context executeFetchRequest:request error:nil] lastObject];
}

#pragma mark - Fetch Request

+ (NSFetchRequest *)alarmFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Alarm"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"clock" ascending:YES]];
    
    return request;
}

@end
