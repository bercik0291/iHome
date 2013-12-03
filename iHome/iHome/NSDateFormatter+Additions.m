//
//  NSDateFormatter+Additions.m
//  MobileSeller
//
//  Created by Hubert Drąg on 01.08.2013.
//  Copyright (c) 2013 AppUnite.com. All rights reserved.
//

#import "NSDateFormatter+Additions.h"

@implementation NSDateFormatter (Additions)
+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"'HH':'mm"];
    }
    return dateFormatter;
}

@end
