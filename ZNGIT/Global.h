//
//  Global.h
//  ZNGIT
//
//  Created by LionStar on 3/3/16.
//  Copyright © 2016 Reflect Apps. All rights reserved.
//

#ifndef Global_h
#define Global_h

#ifdef DEBUG
# define DLog(...) NSLog(__VA_ARGS__)
#else
# define DLog(...) /* */
#endif



#define UIColorFromRGB(rgbValue)   ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define ZNGIT_MAIN_COLOR UIColorFromRGB(0x00BCB6)

#define RENTAL_SERVICE_FEE 3.00

#define METERS_PER_MILE 1609.344

#define notNullValue(obj) [obj isKindOfClass:[NSNull class]]?nil:obj
#define notNullEmptyString(obj) [obj isKindOfClass:[NSNull class]]?@"":obj

// define notification name

#define ZN_NOTIFICATION_CURRENT_PLACEMARK_UPDATED @"kZnNotificationCurrentPlacemarkUpdated"
#define ZN_NOTIFICATION_SELECTED_CITY_UPDATED @"kZnNotificationSelectedCityUpdated"
#define ZN_NOTIFICATION_CATEGORIES_UPDATED @"kZnNotificationCategoriesUpdated"
#define ZN_NOTIFICATION_PRIMARY_CREDIT_CARD_CHANGED @"kZnNotificationPrimaryCreditCardChanged"
#define ZN_NOTIFICATION_NEED_LOGIN @"kZnNotificationNeedLogin"
#define ZN_NOTIFICATION_BOOKINGS_UPDATED @"kZnNotificationBookingsUpdated"

#define ZN_NOTIFICATION_SIGN_IN_SUCCEEDED @"kNotificationSignInSucceeded"
#define ZN_NOTIFICATION_SIGN_IN_CANCELED @"kNotificationSignInCanceled"

#define ZN_NOTIFICATION_CURRENT_USER_CHANGED @"kNotificationCurrentUserChanged"

#endif /* Global_h */
