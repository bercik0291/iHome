//
//  HDSharedDocument.h
//  Loanizer
//
//  Created by Hubert Drąg on 20.09.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDSharedDocument : NSObject
@property (nonatomic,strong) UIManagedDocument *document;

+ (HDSharedDocument *)defaultDocument;
- (void)openDocument:(void(^)(void))completion;
- (void)saveDocument;
@end
