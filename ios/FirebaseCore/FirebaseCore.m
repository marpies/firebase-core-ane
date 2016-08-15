/**
 * Copyright 2016 Marcel Piestansky (http://marpies.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FirebaseCore.h"
#import "Functions/ConfigureFunction.h"

static BOOL FirebaseCoreLogEnabled = NO;
FREContext FirebaseCoreExtContext = nil;

@implementation FirebaseCore

+ (void) dispatchEvent:(const NSString*) eventName {
    [self dispatchEvent:eventName withMessage:@""];
}

+ (void) dispatchEvent:(const NSString*) eventName withMessage:(NSString*) message {
    NSString* messageText = message ? message : @"";
    FREDispatchStatusEventAsync( FirebaseCoreExtContext, (const uint8_t*) [eventName UTF8String], (const uint8_t*) [messageText UTF8String] );
}

+ (void) log:(const NSString*) message {
    if( FirebaseCoreLogEnabled ) {
        NSLog( @"[iOS-FirebaseCore] %@", message );
    }
}

+ (void) showLogs:(BOOL) showLogs {
    FirebaseCoreLogEnabled = showLogs;
}

@end

/**
 *
 *
 * Context initialization
 *
 *
 **/

FRENamedFunction airFirebaseCoreExtFunctions[] = {
    { (const uint8_t*) "configure",               0, fbc_configure }
};

void FirebaseCoreContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet ) {
    *numFunctionsToSet = sizeof( airFirebaseCoreExtFunctions ) / sizeof( FRENamedFunction );
    
    *functionsToSet = airFirebaseCoreExtFunctions;
    
    FirebaseCoreExtContext = ctx;
}

void FirebaseCoreContextFinalizer( FREContext ctx ) { }

void FirebaseCoreInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &FirebaseCoreContextInitializer;
    *ctxFinalizerToSet = &FirebaseCoreContextFinalizer;
}

void FirebaseCoreFinalizer( void* extData ) { }







