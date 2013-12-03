//
//  NSDictionary+JSON.m
//  MobileSeller
//
//  Created by Hubert Drąg on 24.07.2013.
//  Copyright (c) 2013 AppUnite.com. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

+ (NSDictionary *)dictionaryFromJSON:(NSData *)data {
        
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return error ? nil : dictionary;
}

- (NSData *)JSON {
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    return error ? nil : json;
}

@end
