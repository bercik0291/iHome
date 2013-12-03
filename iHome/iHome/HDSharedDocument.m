//
//  HDSharedDocument.m
//  Loanizer
//
//  Created by Hubert Drąg on 20.09.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "HDSharedDocument.h"

@implementation HDSharedDocument
+ (HDSharedDocument *)defaultDocument {
    static HDSharedDocument *object = nil;
    if (!object) {
        object = [[HDSharedDocument alloc] init];
    }
    return object;
}

- (void)openDocument:(void(^)(void))completion {
    // get documents directory url
    NSURL *docUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    
    // add component to url to get unique file path
    docUrl = [docUrl URLByAppendingPathComponent:@"MyDocument"];
    
    // alloc and init UIManaged Document | Document is not ready yet
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:docUrl];
    
    self.document = document;
    
    BOOL isFileExist = [[NSFileManager defaultManager] fileExistsAtPath:[docUrl path]];
    NSLog(@"is File Exist? : %d", isFileExist);
    // check if file exist at url
    if (isFileExist) {
        //if document exist open document
        [document openWithCompletionHandler:^(BOOL success){
            if (success) {
                
                // save document to property
                self.document = document;
                // document is ready execute completion block
                completion();
            }
            else {
                NSLog(@"couldn't open document at %@", docUrl);
            }
        }];
    }
    else {
        // else create document and save to url
        [document saveToURL:docUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
            if (success) {
                
                // save document to property
                self.document = document;
                // document is ready execute completion block
                completion();
            }
            else {
                NSLog(@"couldn't create document at %@", docUrl);
            }
        }];
    }
    
}

- (void)saveDocument {
    
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if (success) {
                   NSLog(@"saved");
               } else {
                   NSLog(@"unable to save");
               }
           }];
}

@end
