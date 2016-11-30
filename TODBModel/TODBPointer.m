//
//  TODBPointer.m
//  TODBModel
//
//  Created by Tony on 16/11/30.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODBPointer.h"
#import "TODBModel+Cache.h"

@implementation TODBPointer

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if (self == nil) return nil;

    
    _className = [aDecoder decodeObjectForKey:@"className"];
    _pkValue = [aDecoder decodeObjectForKey:@"pkValue"];
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_className forKey:@"className"];
    [aCoder encodeObject:_pkValue forKey:@"pkValue"];

}

- (instancetype)initWithModel:(TODBModel *)model{
    if (!model) {
        return nil;
    }
    
    self = [self init];
    if (self == nil) return nil;

    
    
    self.className = NSStringFromClass([model class]);
    self.pkValue = [model valueForKey:[[model class] db_pk]];
    
    return self;
}

- (TODBModel *)model{
    TODBModel *result;
    
    if (self.className && self.className.length > 0) {
        Class class = NSClassFromString(self.className);
        
        result = [class modelByKey:self.pkValue allowNull:YES];
    }
    return result;
}

@end
