//
// Created by zhangai on 16/3/31.
//


#include <stdio.h>
#include <stdlib.h>
#include "aes.h"
#include "fuckme.h"
#include "string.h"

//CRYPT CONFIG


////AES_IV
//static unsigned char AES_IV[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
//                                   0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f};
////AES_KEY
//static unsigned char AES_KEY[32] = {0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71,
//                                    0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81, 0x1f,
//                                    0x35, 0x2c,
//                                    0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09,
//                                    0x14, 0xdf,
//                                    0xf4};


//for question content
uint8_t *AES_IV_Q;
uint8_t *AES_KEY_Q;

//for answer
uint8_t *AES_IV_A;
uint8_t *AES_KEY_A;

//for comments
uint8_t *AES_IV_C;
uint8_t *AES_KEY_C;

int has_key_initialized = 0;


void initKeys(const uint8_t *packagename, const uint8_t *sign, const uint8_t *key) {

    if (!has_key_initialized) {
        AES_IV_Q = packagename;
        AES_KEY_Q = key;

        AES_IV_A = packagename;
        AES_KEY_A = sign;

        AES_IV_C = key;
        AES_KEY_C = sign;

        has_key_initialized = 1;
    }


}


unsigned int getSrcLen(int len, int mode) {
    unsigned int rest_len = len % AES_BLOCK_SIZE;
    unsigned int padding_len = (
            (ENCRYPT == mode) ? (AES_BLOCK_SIZE - rest_len) : 0);
    return len + padding_len;
}

unsigned int fuck(uint8_t *data, uint8_t *buff, unsigned int len, long time, int mode, int type) {
    uint8_t *iv, *key;
    if (type % 3 == 0) {
        iv = AES_IV_Q;
        key = AES_KEY_Q;
    } else if (type % 3 == 1) {
        iv = AES_IV_A;
        key = AES_KEY_A;
    } else {
        iv = AES_IV_C;
        key = AES_KEY_C;
    }


    //check input data
    if (len <= 0 || len >= MAX_LEN) {
        return 0;
    }

    if (!data) {
        return 0;
    }

    //计算填充长度，当为加密方式且长度不为16的整数倍时，则填充，与3DES填充类似(DESede/CBC/PKCS5Padding)
    unsigned int rest_len = len % AES_BLOCK_SIZE;
    unsigned int padding_len = (
            (ENCRYPT == mode) ? (AES_BLOCK_SIZE - rest_len) : 0);
    unsigned int src_len = len + padding_len;

    //设置输入
    unsigned char *input = (unsigned char *) malloc(src_len);
    memset(input, 0, src_len);
    memcpy(input, data, len);
    if (padding_len > 0) {
        memset(input + len, (unsigned char) padding_len, padding_len);
    }
    //设置输出Buffer
    if (!buff) {
        free(input);
        return 0;
    }
    memset(buff, src_len, 0);

    //set key & iv
    unsigned int key_schedule[AES_BLOCK_SIZE * 4] = {0}; //>=53(这里取64)
    aes_key_setup(key, key_schedule, AES_KEY_SIZE);

    //执行加解密计算(CBC mode)
    if (mode == ENCRYPT) {
        aes_encrypt_cbc(input, src_len, buff, key_schedule, AES_KEY_SIZE,
                        iv);
    } else {
        aes_decrypt_cbc(input, src_len, buff, key_schedule, AES_KEY_SIZE,
                        iv);
    }

    //解密时计算填充长度
    if (ENCRYPT != mode) {
        unsigned char *ptr = buff;
        ptr += (src_len - 1);
        padding_len = (unsigned int) *ptr;
        if (padding_len > 0 && padding_len <= AES_BLOCK_SIZE) {
            src_len -= padding_len;
        }
        ptr = NULL;
    }
    free(input);

    return src_len;
}
