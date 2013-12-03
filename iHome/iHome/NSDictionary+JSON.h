//
//  NSDictionary+JSON.h
//  MobileSeller
//
//  Created by Hubert Drąg on 24.07.2013.
//  Copyright (c) 2013 AppUnite.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
+ (NSDictionary *)dictionaryFromJSON:(NSData *)data;
- (NSData*)JSON;
@end
