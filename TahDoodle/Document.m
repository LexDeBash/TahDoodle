//
//  Document.m
//  TahDoodle
//
//  Created by Alexey Efimov on 04.05.16.
//  Copyright © 2016 Alexey Efimov. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end

@implementation Document

#pragma mark - NSDocument Overrides

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Этот метод вызывается при сохранении документа. Он должен передать вызывающей стороне объект NSData с данными, упакованными для записи на диск
    // Если массив не существует, создаем пустой массив
    if (!self.tasks) {
        self.tasks = [NSMutableArray array];
    }
    // Упаковка массива задач в объект NSData
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:self.tasks
                                                              format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:outError];
    // Возвращение объекта NSData с упакованными данными
    return data;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Этот метод вызывается при загрузке документа. Он должен извлечь данные из полученного объекта NSData
    // Извлечение задач из массива
    self.tasks = [NSPropertyListSerialization propertyListWithData:data
                                                           options:NSPropertyListMutableContainers
                                                            format:NULL
                                                             error:outError];
    // Возвращение признака успеха или неудачи, в зависимости от результата операции
    return (self.tasks != nil);
}

#pragma mark - Actions

- (void)addTask:(id)sender {
    // Если массива задач не существует, то создаем его
    if (!self.tasks) {
        self.tasks = [NSMutableArray array];
    }
    [self.tasks addObject:@"New Item"];
    
    // -reloadData приказывает табличному представлению обновиться и запросить у источнки данных (которым в данном случае является объект Document) новые данные для отображения
    [self.taskTable reloadData];
    
    // -updateChangeCount: сообщает приложению, содержит ли докуенмт несохраненные данные. NSChangeDone помечает документ, как несохраненный
    [self updateChangeCount:NSChangeDone];
}

#pragma mark Data Source Methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    // Так как табличное представление отображает массив задач, то количество записей в нем будет таким же, как и в массиве
    // Возвращаем количество строк массива в табличное представление
    return [self.tasks count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    // Возвращаем элемент из массива задач в соответствии с ячейкой, которая должна отображаться в табличном представлении
    return [self.tasks objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row {
    // Когда пользователь меняет задачи в табличном представлении, обновляем список задач в массиве
    [self.tasks replaceObjectAtIndex:row
                          withObject:object];
    // И помечаем документ, как с несохраненными изменениями
    [self updateChangeCount:NSChangeDone];
}



@end
