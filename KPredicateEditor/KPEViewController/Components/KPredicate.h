//
//  KPredicate.h
//  Zanichelli_DizionariOSX
//
//  Created by Federico Cappelli on 13/01/12.
//  Copyright (c) 2012 Meta s.r.l. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KPredicate : NSPredicate
{
    NSString * theType;
    NSString * theSearchKey;
    NSString * op;
}

@property(nonatomic, retain) NSString * theType;
@property(nonatomic, retain) NSString * theSearchKey;
@property(nonatomic, retain) NSString * op;

-(id)initWithType:(NSString*)type Key:(NSString *)key operator:(NSString *)operator;
-(NSString *)description;

@end
