package com.ruoyi.xt.config;
//
///**
// * @Auther: eniac
// * @Date: 4/15/22 22:32
// * @Description:
// */
//
////import org.elasticsearch.client.transport.TransportClient;
////import org.elasticsearch.common.settings.Settings;
////import org.elasticsearch.common.transport.TransportAddress;
//import org.elasticsearch.transport.client.PreBuiltTransportClient;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.stereotype.Component;
//
//import java.net.InetAddress;
//
///**
// * @Configuration用于定义配置类，可替换xml配置文件/yml文件.
// */
////@Configuration
//@Component
//public class ElasticsearchConfig {
//
////    private static final Logger LOGGER = LoggerFactory.getLogger(ElasticsearchConfig.class);
//
////    @Value("${elasticsearch.ip}")
//    private String hostName = "149.28.37.12";
//
//    /**
//     * 端口
//     */
////    @Value("${elasticsearch.port}")
//    private String port = "9200";
//
//    /**
//     * 集群名称
//     */
////    @Value("${elasticsearch.cluster-name}")
//    private String clusterName="docker-cluster";
//
//    /**
//     * 连接池
//     */
////    @Value("${elasticsearch.pool}")
//    private String poolSize = "5";
//
//    /**
//     * Bean name default  函数名字
//     * @return
//     */
//    @Bean(name = "transportClient")
//    public TransportClient transportClient() {
//        System.out.println("Elasticsearch初始化开始。。。。。");
//        TransportClient transportClient = null;
//        try {
//            // 配置信息
//            Settings esSetting = Settings.builder()
//                    .put("cluster.name", clusterName) //集群名字
//                    .put("client.transport.sniff", true)//增加嗅探机制，找到ES集群
//                    .put("thread_pool.search.size", Integer.parseInt(poolSize))//增加线程池个数，暂时设为5
//                    .build();
//            //配置信息Settings自定义
//            transportClient = new PreBuiltTransportClient(esSetting);
//            TransportAddress transportAddress = new TransportAddress(InetAddress.getByName(hostName), Integer.valueOf(port));
//            transportClient.addTransportAddresses(transportAddress);
//        } catch (Exception e) {
//            System.out.println("elasticsearch TransportClient create error!!"+e);
//        }
//        return transportClient;
//    }
//}
//
