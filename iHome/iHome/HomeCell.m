//
//  HomeCell.m
//  iHome
//
//  Created by Hubert Drąg on 03.12.2013.
//  Copyright (c) 2013 Hubert Drąg. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.switchButton setOn:NO];
    [self.checkbox setOn:NO];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self.checkbox addGestureRecognizer:tap];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Handle gestures

- (void)handleTapGesture:(UITapGestureRecognizer *)tap
{
    [self.checkbox setOn:!self.checkbox.on];
    
}

@end
