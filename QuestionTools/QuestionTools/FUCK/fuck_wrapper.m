//
//  fuck_wrapper.m
//  Secret
//
//  Created by PageZhang on 16/4/6.
//  Copyright © 2016年 PageZhang. All rights reserved.
//

#include "fuckme.h"
#include "hexstring.h"
#import "fuck_wrapper.h"

int initialized = 0;
void fuckKeys() {
    if (!initialized) {
        NSString *pm = @"cn.eclicks.drivingtest";
        NSString *sign = @"30820263308201cca003020102020450";
        NSString *key = @"abc012zyx43poq5ghj8g9we76uskrtzd";
        initKeys((const uint8_t *)pm.UTF8String, (const uint8_t *)sign.UTF8String, (const uint8_t *)key.UTF8String);
    }
}


NSString *get_me_some_coffee(NSString *material, fuckWrapper wrapper, int mode) {
    fuckKeys();
    // operate
    if (material.length==0) {
        return nil;
    }
    char *buffer = (char *)material.UTF8String;
    size_t len = strlen(buffer);
    uint8_t *cBuffer;
    if (mode == DECRYPT) {
        len /= 2;
        cBuffer = hexStringToBytes(buffer);
    } else {
        cBuffer = (uint8_t *)buffer;
    }
    unsigned int src_len = getSrcLen((int)len, mode);
    uint8_t *cOutBuf = (unsigned char *)malloc(src_len);
    src_len = fuck(cBuffer, cOutBuf, (unsigned int)len, 0, mode, wrapper);
    if (mode == ENCRYPT) {
        return [NSString stringWithUTF8String:bytesToHexString(cOutBuf, src_len*2)];
    } else {
        return [[NSString alloc] initWithBytes:cOutBuf length:src_len encoding:NSUTF8StringEncoding];
    }
}

NSString *buy_coffee(NSString *material, fuckWrapper wrapper) {
    return get_me_some_coffee(material, wrapper, DECRYPT);
}
NSString *sell_coffee(NSString *material, fuckWrapper wrapper) {
    return get_me_some_coffee(material, wrapper, ENCRYPT);
}