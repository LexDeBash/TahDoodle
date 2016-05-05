//
//  Document.h
//  TahDoodle
//
//  Created by Alexey Efimov on 04.05.16.
//  Copyright © 2016 Alexey Efimov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument <NSTableViewDataSource>

@property (nonatomic) NSMutableArray *tasks;
@property (nonatomic) IBOutlet NSTableView *taskTable;

- (IBAction)addTask:(id)sender;


@end

