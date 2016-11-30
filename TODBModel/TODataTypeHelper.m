//
//  TODataTypeHelper.m
//  TODBModel
//
//  Created by Tony on 16/11/28.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODataTypeHelper.h"
#import "TODBModel.h"
#import "TODBPointer.h"

@implementation TODataTypeHelper

//将objc类型转化为Sqllite对应的类型
+ (NSString *)objcTypeToSqlType:(const char *)objcType{
    NSString *result = nil;
    
    NSString *type = [NSString stringWithUTF8String:objcType];
    NSString *regex = @"^@\"[a-zA-Z_0-9]*\"$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:type]) {
        if ([type isEqualToString:@"@\"NSString\""]) {
            result = DB_TYPE_TEXT;
        }else if([type isEqualToString:@"@\"NSDate\""]){
            result = DB_TYPE_INTEGER;
        }else{
            result = DB_TYPE_BLOB;
        }
    }else{
        char t = objcType[0];
        if (t == '^') {
            t = objcType[1];
        }
        
        switch (t) {
            case 'i':
            case 'I':
                result = DB_TYPE_INTEGER;
                break;
            case 'q':
            case 'Q':
            case 'd':
            case 'D':
                result = DB_TYPE_INTEGER;
                break;
            case 'f':
            case 'F':
                result = DB_TYPE_REAL;
                break;
            default:
                break;
        }
    }
    
    return result;
}


+ (NSString *)objcObjectToSqlObject:(id)objcObject withType:(NSString *)type arguments:(NSMutableArray *)arguments{
    
    NSString *result = nil;
    
    if ([type isEqualToString:DB_TYPE_BLOB]) {
        if ([objcObject isKindOfClass:[TODBModel class]]) {
            objcObject = [[TODBPointer alloc] initWithModel:objcObject];
        }
        
        if (!objcObject || [objcObject isEqual:[NSNull null]]) {
            result = DB_NULL;
        }else{
            result = @"?";
            if (arguments) {
                NSData *dataOnObject = [NSKeyedArchiver archivedDataWithRootObject:objcObject];
                [arguments addObject:dataOnObject];
            }
        }
    }else{
        if (!objcObject || [objcObject isEqual:[NSNull null]]) {
            result = DB_NULL;
        }else{
            if ([type isEqualToString:DB_TYPE_TEXT]) {
                result = [NSString stringWithFormat:@"\"%@\"",objcObject];

            }else if([objcObject isKindOfClass:[NSDate class]]){
                result = [NSString stringWithFormat:@"%f",[(NSDate *)objcObject timeIntervalSince1970]];
            }else{
                result = [NSString stringWithFormat:@"%@",objcObject];
            }
        }
    }
    
    
    return result;
}

+ (id)readObjcObjectFrom:(FMResultSet *)resultSet name:(NSString *)name type:(NSString *)objcType{
    
    id result;
    NSString *regex = @"^@\"[a-zA-Z_0-9]*\"$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:objcType]) {
        if ([objcType isEqualToString:@"@\"NSString\""]) {
            result = [resultSet stringForColumn:name];
        }else if ([objcType isEqualToString:@"@\"NSDate\""]) {
            NSTimeInterval timeInterval = [resultSet doubleForColumn:name];
            result = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        }else if([objcType isEqualToString:@"@\"NSData\""]){
            result = [result dataForColumn:name];
        }else{
            NSString *className = [objcType substringWithRange:NSMakeRange(2, objcType.length - 3)];
            NSData *data = [resultSet dataForColumn:name];
            Class class = NSClassFromString(className);
            
            if ([class isSubclassOfClass:[TODBModel class]]) {
                TODBPointer *pointer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (pointer) {
                    result = pointer;
                }
            }else{
                @try {
                    result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                }
                @catch (NSException *exception) {
                    NSLog(@"属性解析失败.\n%@",exception);
                }
            }
            
            
        }
    }else{
        result = @([resultSet doubleForColumn:name]);
    }
    return result;
}

@end
