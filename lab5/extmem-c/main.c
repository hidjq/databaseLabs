//
//  main.c
//  extmem
//
//  Created by Jachee Deng on 2023/1/4.
//
#include <stdlib.h>
#include <stdio.h>
#include "extmem.h"
#include <string.h>

int task1(){
    printf("******************task1******************\n");
    Buffer buf;
    unsigned char *blk;
    if(!initBuffer(520, 64, &buf)){
        perror("Buffer Initialization Failed!\n");
        return -1;
    }
    unsigned char* blk_result = getNewBlockInBuffer(&buf);
    int index = 0;
    char str[5];
    int x = -1;
    int y = -1;
    int blk_num = 0;
    for(int i=17;i<49;i++){
        if((blk = readBlockFromDisk(i, &buf)) == NULL){
            perror("Reading Block Failed!\n");
            return -1;
        }
        for(int m=0;m<7;m++){
            for(int j=0;j<4;j++){
                str[j] = *(blk+m*8+j);
            }
            x = atoi(str);
            if(x==128){
                for(int k=0;k<4;k++){
                    str[k] = *(blk+m*8+4+k);
                }
                y = atoi(str);
                if(index >= 7){
                    index = 0;
                    writeBlockToDisk(blk_result, 400+blk_num, &buf);
                    printf("result written into block %d.\n",400+blk_num);
                    blk_result = getNewBlockInBuffer(&buf);
                    blk_num++;
                }
                *(blk_result+index*8) = '0'+x/100;
                *(blk_result+index*8+1) = '0'+(x/10)%10;
                *(blk_result+index*8+2) = '0'+x%10;
                *(blk_result+index*8+4) = '0'+y/100;
                *(blk_result+index*8+5) = '0'+(y/10)%10;
                *(blk_result+index*8+6) = '0'+y%10;
                index++;
                printf("(%d, %d) \n",x,y);
            }
        }
        freeBlockInBuffer(blk, &buf);
    }
    
    writeBlockToDisk(blk_result, 400+blk_num, &buf);
    printf("result written into block %d.\n",400+blk_num);
    
    printf("\n");
    printf("IO's is %lu\n", buf.numIO);
    return 0;
}

int findMin(int i,int j,int k){
    if(i<=j){
        if(i<=k){
            return 0;
        } else {
            return 2;
        }
    } else {
        if(j<=k){
            return 1;
        } else {
            return 2;
        }
    }
    return -1;
}

int findMinInFive(int i,int j,int k,int m,int n){
    switch (findMin(i, j, k)) {
        case 0:
            switch (findMin(i, m, n)) {
                case 0:
                    return 0;
                    break;
                case 1:
                    return 3;
                case 2:
                    return 4;
                default:
                    break;
            }
            break;
        case 1:
            switch (findMin(j, m, n)) {
                case 0:
                    return 1;
                    break;
                case 1:
                    return 3;
                case 2:
                    return 4;
                default:
                    break;
            }
            break;
        case 2:
            switch (findMin(k, m, n)) {
                case 0:
                    return 2;
                    break;
                case 1:
                    return 3;
                case 2:
                    return 4;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return 0;
}

int turn(Buffer *buf,int i,int isFirstAttr){
    char str[5];
    int blk_index = i/7;
    int inner_index = i - blk_index * 7;
    for(int m = 0;m<4;m++){
        str[m] = *(buf->data+1*(1+blk_index)+blk_index*buf->blkSize+inner_index*8+m+(isFirstAttr == 1 ? 0:4));
    }
    int key = atoi(str);

    return key;
}
int turnInBLOCK(unsigned char* blk,int i, int isFirstAttr){
    char str[5];
    for(int m=0;m<4;m++){
        str[m] = *(blk+i*8+m+(isFirstAttr == 1 ? 0:4));
    }
    return atoi(str);
}
unsigned char* addr(Buffer *buf,int i){
    int blk_index = i/7;
    int inner_index = i - blk_index * 7;

    return buf->data+1*(1+blk_index)+blk_index*buf->blkSize+inner_index*8;
}

void QuickSort(Buffer* buf,int low,int high){
    if(low<high){//不加这个条件会死循环
        int i=low;
        int j=high;

        int key = turn(buf, low, 1);//=arr[low];
        int keyY = turn(buf, low, 0);// y[low];
        while(i<j){
            while(i<j && turn(buf, j, 1)>=key)//arr[j]>=key)
                j--;
            if(i<j){
                //arr[i++]=arr[j];//先赋值在自增
                //y[i-1] = y[j];
                memcpy(addr(buf,i), addr(buf,j), 8);
                i++;
            }
            while(i<j&&turn(buf,i,1) < key)//arr[i]<key)
                i++;
            if(i<j){
                //arr[j--]=arr[i];//先赋值在自增
                //y[j+1] = y[i];
                memcpy(addr(buf, j), addr(buf, i), 8);
                j--;
            }
        }
//        arr[i]=key;
//        y[i] = keyY;
//        memcpy(addr(buf, i), addr(buf, low), 8);
        unsigned char *arr_i = addr(buf, i);
        for(int m=0;m<4;m++){
            if(m==0){
                *(arr_i+m) = key/100+'0';
            } else if (m==1){
                *(arr_i+m) = (key/10)%10+'0';
            } else if(m==2){
                *(arr_i+m) = key%10+'0';
            }
        }
        for(int m=0;m<4;m++){
            if(m==0){
                *(arr_i+m+4) = keyY/100+'0';
            } else if (m==1){
                *(arr_i+m+4) = (keyY/10)%10+'0';
            } else if(m==2){
                *(arr_i+m+4) = keyY%10+'0';
            }
        }
        QuickSort(buf,low,i-1);//给左边排序
        QuickSort(buf,i+1,high);//给右边排序
       }
}

int task2(){
    printf("******************task2******************\n");
    Buffer buf;
    unsigned char *blk;
    if(!initBuffer(520, 64, &buf)){
        perror("Buffer Initializatioin Failed!\n");
        return -1;
    }

    //MARK: - R(120, 418)(120, 827)(120, 499)
    //MARK: - 第一阶段(120, 736)(120, 418)(120, 775)(120, 571)(120, 581)(120, 852)(120, 781)(120, 827)(120, 554)
    for(int i=1;i<17;i++){
        if((blk = readBlockFromDisk(i, &buf)) == NULL){
            perror("Reading Block Failed!\n");
            return -1;
        }

        if(buf.numFreeBlk == 1 || i==16){
            //进行内排序
            QuickSort(&buf, 0, i==16 ? 13:48);
            for(int k = 0;k< (i==16 ? 2:7);k++){
                blk = getNewBlockInBuffer(&buf);
                memcpy(blk, blk-(buf.blkSize+1)*((i==16 ? 2:7)-k), buf.blkSize);
                if (writeBlockToDisk(blk, k+7*(i/8)+50, &buf) != 0)
                {
                    perror("Writing Block Failed!\n");
                    return -1;
                }
            }
            blk = getNewBlockInBuffer(&buf);
            for(int k = 0;k< (i==16 ? 2:7);k++){
                freeBlockInBuffer(blk-(buf.blkSize+1)*((i==16 ? 2:7)-k), &buf);
            }
            freeBlockInBuffer(blk, &buf);
        }
    }

    //MARK: - 第二阶段

    for(int i = 0;i < 16;i+=7){
        for(int j=0;j<2;j++){
            blk = readBlockFromDisk(50+i+j, &buf);
        }
    }

    int index = 0;
    int index1 = 14;
    int index2 = 28;
    int blk_num = 0;
    int blk_num1 = 7;
    int blk_num2 = 14;
    int blk_num_result = 1;

    while(blk_num_result<17){
        blk = getNewBlockInBuffer(&buf);
        int index_result = 0;
        while(index_result < 7){
            int temp = turn(&buf, index, 1);
            int temp1 = turn(&buf, index1, 1);
            int temp2 = turn(&buf, index2, 1);
            if(blk_num > 6 || (blk_num == 6&&index>6)){
                temp = 1000;
            }
            if(blk_num1 > 13 || (blk_num == 13&&index>20)){
                temp1 = 1000;
            }
            if(blk_num2>15){
                temp2 = 1000;
            }

            switch (findMin(temp, temp1, temp2)) {
                case 0:
                    memcpy(blk+index_result*8, addr(&buf, index), 8);
                    index++;
                    if(index >= 14){
                        if(blk_num < 6){
                            blk_num+=2;
                        }
                        for(int j=0;j<2;j++){
                            if((blk_num+j) <=6){
                                freeBlockInBuffer(blk-(buf.blkSize+1)*(6-j), &buf);
                                readBlockFromDisk(50+blk_num+j, &buf);
                            }
                        }
                        index=0;
                    }
                    index_result++;
                    break;
                case 1:
                    memcpy(blk+index_result*8, addr(&buf, index1), 8);
                    index1++;
                    if(index1 >= 28){
                        if(blk_num1 < 13){
                            blk_num1+=2;
                        }
                        for(int j=0;j<2;j++){

                            if((blk_num1 + j) <= 13){
                                freeBlockInBuffer(blk-(buf.blkSize+1)*(4-j), &buf);
                                readBlockFromDisk(50+blk_num1+j, &buf);
                            }
                        }
                        index1=14;
                    }
                    index_result++;
                    break;
                case 2:
                    memcpy(blk+index_result*8, addr(&buf, index2), 8);
                    index2++;
                    if(index2 >= 42){
                        if(blk_num2 < 15){
                            blk_num2+=2;
                        }
                        for(int j=0;j<2;j++){

                            if((blk_num2+j) <= 15){
                                freeBlockInBuffer(blk-(buf.blkSize+1)*(2-j), &buf);
                                readBlockFromDisk(50+blk_num2+j, &buf);
                            }
                        }
                        index2=28;
                    }
                    index_result++;
                    break;
                default:
                    break;
            }
        }
        printf("result written into block %d.\n",300+blk_num_result);
        writeBlockToDisk(blk, 300+blk_num_result, &buf);
        blk_num_result++;
    }

    blk = getNewBlockInBuffer(&buf);
    for(int i = 0;i<7;i++){
        freeBlockInBuffer(blk-(buf.blkSize+1)*(6-i), &buf);
    }

    //MARK: - S
    //MARK: - 第一阶段

    for(int i=17;i<49;i++){
        if((blk = readBlockFromDisk(i, &buf)) == NULL){
            perror("Reading Block Failed!\n");
            return -1;
        }

        if(buf.numFreeBlk == 1 || i==48){
            //进行内排序

            QuickSort(&buf, 0, i==48 ? 27:48);
            for(int k = 0;k< (i==48 ? 4:7);k++){
                blk = getNewBlockInBuffer(&buf);
                memcpy(blk, blk-(buf.blkSize+1)*((i==48 ? 4:7)-k), buf.blkSize);
                if (writeBlockToDisk(blk, k+7*(i/8)+100-14, &buf) != 0)
                {
                    perror("Writing Block Failed!\n");
                    return -1;
                }
                //freeBlockInBuffer(blk-(buf.blkSize+1)*((i==16 ? 2:7)-k), &buf);
            }
            blk = getNewBlockInBuffer(&buf);
            for(int k = 0;k< (i==48 ? 4:7);k++){
                freeBlockInBuffer(blk-(buf.blkSize+1)*((i==48 ? 4:7)-k), &buf);
            }
            freeBlockInBuffer(blk, &buf);
        }
    }

    //MARK: - 第二阶段

    for(int i = 16;i < 47;i+=7){
        blk = readBlockFromDisk(100-16+i, &buf);
    }

    index = 0;
    index1 = 7;
    index2 = 14;
    int index3 = 21;
    int index4 = 28;
    blk_num = 0; /*0-6*/
    blk_num1 = 7;/*7-13*/
    blk_num2 = 14;/*14-20*/
    int blk_num3 = 21;/*21-27*/
    int blk_num4 = 28;/*28-31*/
    blk_num_result = 1;

    while(blk_num_result<33){
        blk = getNewBlockInBuffer(&buf);
        int index_result = 0;
        while(index_result < 7){
            int temp = turn(&buf, index, 1);
            int temp1 = turn(&buf, index1, 1);
            int temp2 = turn(&buf, index2, 1);
            int temp3 = turn(&buf, index3, 1);
            int temp4 = turn(&buf, index4, 1);
            if(blk_num > 6){
                temp = 1000;
            }
            if(blk_num1 > 13){
                temp1 = 1000;
            }
            if(blk_num2>20){
                temp2 = 1000;
            }
            if(blk_num3>27){
                temp3 = 1000;
            }
            if(blk_num4>31){
                temp4 = 1000;
            }

            switch (findMinInFive(temp, temp1, temp2, temp3, temp4)) {
                case 0:
                    memcpy(blk+index_result*8, addr(&buf, index), 8);
                    index++;
                    if(index >= 7){
                        if(blk_num <= 6){
                            blk_num+=1;
                        }
                        if((blk_num) <=6){
                            freeBlockInBuffer(blk-(buf.blkSize+1)*(5), &buf);
                            readBlockFromDisk(100+blk_num, &buf);
                        }
                        index=0;
                    }
                    index_result++;
                    break;
                case 1:
                    memcpy(blk+index_result*8, addr(&buf, index1), 8);
                    index1++;
                    if(index1 >= 14){
                        if(blk_num1 <= 13){
                            blk_num1+=1;
                        }
                        if((blk_num1) <= 13){
                            freeBlockInBuffer(blk-(buf.blkSize+1)*(4), &buf);
                            readBlockFromDisk(100+blk_num1, &buf);
                        }
                        index1=7;
                    }
                    index_result++;
                    break;
                case 2:
                    memcpy(blk+index_result*8, addr(&buf, index2), 8);
                    index2++;
                    if(index2 >= 21){
                        if(blk_num2 <= 20){
                            blk_num2+=1;
                        }
                        if((blk_num2) <= 20){
                            freeBlockInBuffer(blk-(buf.blkSize+1)*(3), &buf);
                            readBlockFromDisk(100+blk_num2, &buf);
                        }
                        index2=14;
                    }
                    index_result++;
                    break;
                case 3:
                    memcpy(blk+index_result*8, addr(&buf, index3), 8);
                    index3++;
                    if(index3 >= 28){
                        if(blk_num3 <= 27){
                            blk_num3+=1;
                        }
                        if((blk_num3) <= 27){
                            freeBlockInBuffer(blk-(buf.blkSize+1)*(2), &buf);
                            readBlockFromDisk(100+blk_num3, &buf);
                        }
                        index3=21;
                    }
                    index_result++;
                    break;
                case 4:
                    memcpy(blk+index_result*8, addr(&buf, index4), 8);
                    index4++;
                    if(index4 >= 35){
                        if(blk_num4 <= 31){
                            blk_num4+=1;
                        }
                        if((blk_num4) <= 31){
                            freeBlockInBuffer(blk-(buf.blkSize+1)*(1), &buf);
                            readBlockFromDisk(100+blk_num4, &buf);
                        }
                        index4=28;
                    }
                    index_result++;
                    break;
                default:
                    break;
            }
        }
        printf("result written into block %d.\n",300+blk_num_result+16);
        writeBlockToDisk(blk, 300+blk_num_result+16, &buf);
        blk_num_result++;
    }
    printf("\n");
    printf("IO's is %lu\n", buf.numIO); /* Check the number of IO's */
    return 0;
}

int task3(){
    printf("******************task3******************\n");
    Buffer buf;
    unsigned char *blk;
    if(!initBuffer(520, 64, &buf)){
        perror("Buffer Initializatioin Failed!\n");
        return -1;
    }
    int temp = 0;
    int flag = 0;
    unsigned char* blk_result = getNewBlockInBuffer(&buf);
    int index = 0;
    int i = 17;
    int blk_num = 0;
    while(flag == 0){
        blk = readBlockFromDisk(i+300, &buf);
        for(int j = 0;j<7;j++){
            temp = turnInBLOCK(blk, j, 1);
            if(temp == 128){
                if(index > 7){
                    index = 0;
                    printf("result written into block %d.\n",500+blk_num);
                    writeBlockToDisk(blk_result, 500+blk_num, &buf);
                    blk_result = getNewBlockInBuffer(&buf);
                    blk_num++;
                }
                printf("(%d, %d)\n",temp, turnInBLOCK(blk, j, 0));
                *(blk_result+index*8) = '0'+temp/100;
                *(blk_result+index*8+1) = '0'+(temp/10)%10;
                *(blk_result+index*8+2) = '0'+temp%10;
                *(blk_result+index*8+4) = '0'+turnInBLOCK(blk, j, 0)/100;
                *(blk_result+index*8+5) = '0'+(turnInBLOCK(blk, j, 0)/10)%10;
                *(blk_result+index*8+6) = '0'+turnInBLOCK(blk, j, 0)%10;
                index++;
                flag = 1;
            }
        }
        freeBlockInBuffer(blk, &buf);
        i++;
    }
    
    blk = readBlockFromDisk(i+300, &buf);
    for(int j = 0;j<7;j++){
        temp = turnInBLOCK(blk, j, 1);
        if(temp == 128){
            if(index >= 7){
                index = 0;
                printf("result written into block %d.\n",500+blk_num);
                writeBlockToDisk(blk_result, 500+blk_num, &buf);
                blk_result = getNewBlockInBuffer(&buf);
                blk_num++;
            }
            printf("(%d, %d)\n",temp, turnInBLOCK(blk, j, 0));
            *(blk_result+index*8) = '0'+temp/100;
            *(blk_result+index*8+1) = '0'+(temp/10)%10;
            *(blk_result+index*8+2) = '0'+temp%10;
            *(blk_result+index*8+4) = '0'+turnInBLOCK(blk, j, 0)/100;
            *(blk_result+index*8+5) = '0'+(turnInBLOCK(blk, j, 0)/10)%10;
            *(blk_result+index*8+6) = '0'+turnInBLOCK(blk, j, 0)%10;
            index++;
            flag = 1;
        }
    }
    writeBlockToDisk(blk_result, 500+blk_num, &buf);
    printf("result written into block %d.\n",500+blk_num);
    
    printf("\n");
    printf("IO's is %lu\n", buf.numIO); /* Check the number of IO's */
    return 0;
}


void writeTuple2Blk(unsigned char* blk_result, int x, int y){
    *(blk_result) = '0'+x/100;
    *(blk_result+1) = '0'+(x/10)%10;
    *(blk_result+2) = '0'+x%10;
    *(blk_result+4) = '0'+y/100;
    *(blk_result+5) = '0'+(y/10)%10;
    *(blk_result+6) = '0'+y%10;
}


int task4(){
    printf("******************task4******************\n");
    Buffer buf;
    unsigned char *blk_R;
    unsigned char *blk_S;
    unsigned char *blk_result;
    unsigned char *temp_pointe;

    if(!initBuffer(520, 64, &buf)){
        perror("Buffer Initializatioin Failed!\n");
        return -1;
    }
    int times = 0;

    int blk_num_R = 1;
    int blk_num_S = 17;
    int blk_num_result = 601;
    int temp_blk_num_R = 1;

    int index_R = 0;
    int index_S = 0;
    int temp = 0;
    int index_result = 0;

    blk_R = readBlockFromDisk(300+blk_num_R, &buf);
    blk_S = readBlockFromDisk(300+blk_num_S, &buf);
    blk_result = getNewBlockInBuffer(&buf);
    int temp_R = -1;
    int temp_S = -1;
    while(blk_num_R < 17 && blk_num_S < 49){
        temp_R = turnInBLOCK(blk_R, index_R, 1);
        temp_S = turnInBLOCK(blk_S, index_S, 1);
        if(temp_R == temp_S){
            if(index_result >= 7){
                index_result = 0;
                writeBlockToDisk(blk_result, blk_num_result, &buf);
                printf("result written into block %d.\n", blk_num_result);
                blk_result = getNewBlockInBuffer(&buf);
                blk_num_result++;
            }
            writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(blk_S, index_S, 1), turnInBLOCK(blk_S, index_S, 0));
            //printf("(%d, %d)\n",turnInBLOCK(blk_S, index_S, 1),turnInBLOCK(blk_S, index_S, 0));
            index_result++;
            if(index_result >= 7){
                index_result = 0;
                writeBlockToDisk(blk_result, blk_num_result, &buf);
                printf("result written into block %d.\n", blk_num_result);
                blk_result = getNewBlockInBuffer(&buf);
                blk_num_result++;
            }
            writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(blk_R, index_R, 1), turnInBLOCK(blk_R, index_R, 0));
            //printf("(%d, %d)\n",turnInBLOCK(blk_R, index_R, 1),turnInBLOCK(blk_R, index_R, 0));
            times++;
            index_result++;
            temp = index_R;
            temp_pointe = readBlockFromDisk(blk_num_R+300, &buf);
            temp++;
            if(temp >= 7){
                freeBlockInBuffer(temp_pointe, &buf);
                temp_blk_num_R = blk_num_R;
                temp_blk_num_R++;
                if(temp_blk_num_R < 17){
                    temp_pointe = readBlockFromDisk(temp_blk_num_R+300, &buf);
                }
                temp = 0;
            }
            while(turnInBLOCK(temp_pointe, temp, 1) == temp_S){
                if(index_result >= 7){
                    index_result = 0;
                    writeBlockToDisk(blk_result, blk_num_result, &buf);
                    printf("result written into block %d.\n", blk_num_result);
                    blk_result = getNewBlockInBuffer(&buf);
                    blk_num_result++;
                }
                writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(blk_S, index_S, 1), turnInBLOCK(blk_S, index_S, 0));
                //printf("(%d, %d)\n",turnInBLOCK(blk_S, index_S, 1),turnInBLOCK(blk_S, index_S, 0));
                index_result++;
                if(index_result >= 7){
                    index_result = 0;
                    writeBlockToDisk(blk_result, blk_num_result, &buf);
                    printf("result written into block %d.\n", blk_num_result);
                    blk_result = getNewBlockInBuffer(&buf);
                    blk_num_result++;
                }
                writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(temp_pointe, temp, 1), turnInBLOCK(temp_pointe, temp, 0));
                //printf("(%d, %d)\n",turnInBLOCK(temp_pointe, temp, 1),turnInBLOCK(temp_pointe, temp, 0));
                times++;
                index_result++;
                temp++;
                if(temp >= 7){
                    freeBlockInBuffer(temp_pointe, &buf);
                    temp_blk_num_R = blk_num_R;
                    temp_blk_num_R++;
                    if(temp_blk_num_R < 17){
                        temp_pointe = readBlockFromDisk(temp_blk_num_R+300, &buf);
                    }
                    temp = 0;
                }
            }
            freeBlockInBuffer(temp_pointe, &buf);
            index_S++;
            if(index_S >= 7){
                freeBlockInBuffer(blk_S, &buf);
                blk_num_S++;
                if(blk_num_S < 49){
                    blk_S = readBlockFromDisk(blk_num_S+300, &buf);
                }
                index_S = 0;
            }
        }
        if(temp_R<temp_S){
            index_R++;
            if(index_R >= 7){
                freeBlockInBuffer(blk_R, &buf);
                blk_num_R++;
                if(blk_num_R < 17){
                    blk_R = readBlockFromDisk(blk_num_R+300, &buf);
                }
                index_R = 0;
            }
        }
        if(temp_R>temp_S){
            index_S++;
            if(index_S >= 7){
                freeBlockInBuffer(blk_S, &buf);
                blk_num_S++;
                if(blk_num_S < 49){
                    blk_S = readBlockFromDisk(blk_num_S+300, &buf);
                }
                index_S = 0;
            }
        }
    }
    writeBlockToDisk(blk_result, blk_num_result, &buf);
    printf("result written into block %d.\n", blk_num_result);
    printf("connect times:%d\n",times);
    printf("\n");
    printf("IO's is %lu\n", buf.numIO); /* Check the number of IO's */
    return 0;
}

int task5(){
    printf("******************task5******************\n");
    Buffer buf;
    unsigned char *blk_R;
    unsigned char *blk_S;
    unsigned char *blk_result;
    unsigned char *temp_pointe;

    if(!initBuffer(520, 64, &buf)){
        perror("Buffer Initializatioin Failed!\n");
        return -1;
    }
    int times = 0;

    int blk_num_R = 1;
    int blk_num_S = 17;
    int blk_num_result = 801;
    int temp_blk_num_R = 1;

    int index_R = 0;
    int index_S = 0;
    int temp = 0;
    int index_result = 0;

    blk_R = readBlockFromDisk(300+blk_num_R, &buf);
    blk_S = readBlockFromDisk(300+blk_num_S, &buf);
    blk_result = getNewBlockInBuffer(&buf);
    int temp_R1 = -1;
    int temp_S1 = -1;
    int temp_R2 = -1;
    int temp_S2 = -1;
    while(blk_num_R < 17 && blk_num_S < 49){
        temp_R1 = turnInBLOCK(blk_R, index_R, 1);
        temp_S1 = turnInBLOCK(blk_S, index_S, 1);
        temp_R2 = turnInBLOCK(blk_R, index_R, 0);
        temp_S2 = turnInBLOCK(blk_S, index_S, 0);
        if(temp_R1 == temp_S1){
            if(index_result >= 7){
                index_result = 0;
                writeBlockToDisk(blk_result, blk_num_result, &buf);
                printf("result written into block %d.\n", blk_num_result);
                blk_result = getNewBlockInBuffer(&buf);
                blk_num_result++;
            }
            if(temp_R2 == temp_S2){
                writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(blk_S, index_S, 1), turnInBLOCK(blk_S, index_S, 0));
                printf("(%d, %d)\n",turnInBLOCK(blk_S, index_S, 1),turnInBLOCK(blk_S, index_S, 0));
                times++;
                index_result++;
            }
            temp = index_R;
            temp_pointe = readBlockFromDisk(blk_num_R+300, &buf);
            temp++;
            if(temp >= 7){
                freeBlockInBuffer(temp_pointe, &buf);
                temp_blk_num_R = blk_num_R;
                temp_blk_num_R++;
                if(temp_blk_num_R < 17){
                    temp_pointe = readBlockFromDisk(temp_blk_num_R+300, &buf);
                }
                temp = 0;
            }
            while(turnInBLOCK(temp_pointe, temp, 1) == temp_S1){
                if(index_result >= 7){
                    index_result = 0;
                    writeBlockToDisk(blk_result, blk_num_result, &buf);
                    printf("result written into block %d.\n", blk_num_result);
                    blk_result = getNewBlockInBuffer(&buf);
                    blk_num_result++;
                }
                if(turnInBLOCK(temp_pointe, temp, 0) == temp_S2){
                    writeTuple2Blk(blk_result+8*index_result, turnInBLOCK(blk_S, index_S, 1), turnInBLOCK(blk_S, index_S, 0));
                    printf("(%d, %d)\n",turnInBLOCK(blk_S, index_S, 1),turnInBLOCK(blk_S, index_S, 0));
                    times++;
                    index_result++;
                }
                temp++;
                if(temp >= 7){
                    freeBlockInBuffer(temp_pointe, &buf);
                    temp_blk_num_R = blk_num_R;
                    temp_blk_num_R++;
                    if(temp_blk_num_R < 17){
                        temp_pointe = readBlockFromDisk(temp_blk_num_R+300, &buf);
                    }
                    temp = 0;
                }
            }
            freeBlockInBuffer(temp_pointe, &buf);
            index_S++;
            if(index_S >= 7){
                freeBlockInBuffer(blk_S, &buf);
                blk_num_S++;
                if(blk_num_S < 49){
                    blk_S = readBlockFromDisk(blk_num_S+300, &buf);
                }
                index_S = 0;
            }
        }
        if(temp_R1<temp_S1){
            index_R++;
            if(index_R >= 7){
                freeBlockInBuffer(blk_R, &buf);
                blk_num_R++;
                if(blk_num_R < 17){
                    blk_R = readBlockFromDisk(blk_num_R+300, &buf);
                }
                index_R = 0;
            }
        }
        if(temp_R1>temp_S1){
            index_S++;
            if(index_S >= 7){
                freeBlockInBuffer(blk_S, &buf);
                blk_num_S++;
                if(blk_num_S < 49){
                    blk_S = readBlockFromDisk(blk_num_S+300, &buf);
                }
                index_S = 0;
            }
        }
    }
    writeBlockToDisk(blk_result, blk_num_result, &buf);
    printf("result written into block %d.\n", blk_num_result);
    printf("connect times:%d\n",times);
    printf("\n");
    printf("IO's is %lu\n", buf.numIO); /* Check the number of IO's */
    return 0;
}


int main(){
    task1();
    task2();
    task3();
    task4();
    task5();
    return 0;
}
