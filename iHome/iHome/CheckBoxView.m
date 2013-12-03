//
//  HImageView.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "CheckBoxView.h"

@implementation CheckBoxView

- (void)setOn:(BOOL)on
{
    _on = on;
    
    if (on) [self setImage:[UIImage imageNamed:@"checkbox_selected_bg"]];
    else [self setImage:[UIImage imageNamed:@"checkbox_bg"]];
}

@end
