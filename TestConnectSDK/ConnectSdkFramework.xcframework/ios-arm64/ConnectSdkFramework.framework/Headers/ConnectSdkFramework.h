#import <Foundation/Foundation.h>

//! Project version number for ConnectSdkFramework.
FOUNDATION_EXPORT double ConnectSdkFrameworkVersionNumber;

//! Project version string for ConnectSdkFramework.
FOUNDATION_EXPORT const unsigned char ConnectSdkFrameworkVersionString[];

@protocol NativeCommunicationDelegate <NSObject>
- (NSString * _Nullable)requestDataSync;
- (void)handleEventFromReactNative:(NSString * _Nonnull)data;
@end

@interface NativeCommunicationService : NSObject
@property (class, nonatomic, readonly, strong) NativeCommunicationService * _Nonnull shared;
@property (nonatomic, weak, nullable) id<NativeCommunicationDelegate> delegate;
- (NSString * _Nullable)requestDataSync;
- (void)handleEventFromReactNative:(NSString * _Nonnull)data;
- (void)sendEventToReactNative:(NSDictionary<NSString *, id> * _Nonnull)eventData;
- (void)sendEventWithType:(NSString * _Nonnull)type payload:(NSDictionary<NSString *, id> * _Nullable)payload;
@end
