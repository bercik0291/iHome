//
//  Option+Additions.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "Option+Additions.h"

@implementation Option (Additions)

+ (Option *)createNewOptionWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    Option *newOption = nil;
    
    NSFetchRequest *request = [self optionFetchRequest];
    request.predicate = [NSPredicate predicateWithFormat:@"title == %@", [dict objectForKey:@"title"]];
    
    NSArray *array = [context executeFetchRequest:request error:nil];
    
    if ([array count] > 1) {
        // hanlde error
    } else if ([array count] == 0) {
        
        newOption = [NSEntityDescription insertNewObjectForEntityForName:@"Option" inManagedObjectContext:context];
        newOption.title = [dict objectForKey:@"title"];
        newOption.codeOn = [dict objectForKey:@"code_on"];
        newOption.codeOff = [dict objectForKey:@"code_off"];
        
    } else {
        
        newOption = [array lastObject];
        
    }
    
    return newOption;
}

+ (void)loadOptionsFromArray:(NSArray *)options toContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *params in options) {
        [self createNewOptionWithDictionary:params withContext:context];
    }
}

#pragma mark - Fetch Request

+ (NSFetchRequest *)optionFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Option"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    
    return request;
}

@end
