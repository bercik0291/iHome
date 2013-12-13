//
//  Option+Additions.h
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "Option.h"

@interface Option (Additions)
+ (Option *)createNewOptionWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context;
+ (void)loadOptionsFromArray:(NSArray *)options toContext:(NSManagedObjectContext *)context;
@end
