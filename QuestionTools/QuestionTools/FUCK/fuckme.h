//
// Created by zhangai on 16/3/31.
//
#include <stdio.h>
#ifndef FUCK_FUCKME_H
#define FUCK_FUCKME_H


#define MAX_LEN (2*1024*1024)
#define ENCRYPT 0
#define DECRYPT 1
#define AES_KEY_SIZE 256
#define READ_LEN 10

void initKeys(const uint8_t *packagename, const uint8_t *signature, const uint8_t *key);

unsigned int getSrcLen(int len, int mode);

unsigned int fuck(uint8_t *data, uint8_t *buff, unsigned int len, long time, int mode, int type);


#endif //FUCK_FUCKME_H
