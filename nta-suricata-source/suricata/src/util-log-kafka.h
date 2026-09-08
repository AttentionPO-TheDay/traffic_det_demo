/**
 * \file
 *
 * \author OhYee <oyohyee@oyohyee.com>
 */


#ifndef __UTIL_LOG_KAFKA_H__
#define __UTIL_LOG_KAFKA_H__

#ifdef HAVE_LIBRDKAFKA
#include <librdkafka/rdkafka.h>

#include "conf.h"            /* ConfNode   */

 // Kafka 存储结构
typedef struct {
    const char* brokers;    // 地址
    const char* topic_name; // 主题名
    int partitions;         // 分区 ID
}KafkaSetup;

// Kafka 上下文
typedef struct {
    rd_kafka_t* rk;
    rd_kafka_topic_t* rkt;
    long partition;     // 分区
}SCLogKafkaContext;

// 初始化 Kafka
// void SCLogKafkaInit(void);
// 根据配置文件连接 Kafka
int SCConfLogOpenKafka(ConfNode*, void*);
// 将内容写出到 Kafka
int LogFileWriteKafka(void*, const char*, size_t);

#endif

#endif