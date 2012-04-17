//
//  KPredicate.m
//  Zanichelli_DizionariOSX
//
//  Created by Federico Cappelli on 13/01/12.
//  Copyright (c) 2012 Meta s.r.l. All rights reserved.
//

#import "KPredicate.h"

@implementation KPredicate

@synthesize theType, theSearchKey, op;

-(id)initWithType:(NSString*)type Key:(NSString *)key operator:(NSString *)operator
{
    self = [super init];
    if (self) 
    {
        self.theType = type;
        self.theSearchKey = key;
        self.op= operator;
        if(self.op == NULL)
            self.op = [[NSString alloc] initWithString:@"=="];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ in %@",self.theSearchKey,self.theType];
}

@end
