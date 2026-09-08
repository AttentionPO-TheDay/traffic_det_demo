package com.ruoyi.xt.util;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ruoyi.xt.domain.EsEntity;
import lombok.extern.log4j.Log4j;
import org.apache.http.HttpHost;
import org.apache.log4j.Logger;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.action.update.UpdateResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestClient;
import org.elasticsearch.client.RestHighLevelClient;
import org.elasticsearch.client.indices.GetIndexRequest;
import org.elasticsearch.client.indices.GetIndexResponse;
import org.elasticsearch.cluster.metadata.MappingMetaData;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.ExistsQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.script.Script;
import org.elasticsearch.script.ScriptType;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.sort.FieldSortBuilder;
import org.elasticsearch.search.sort.SortOrder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.TimeUnit;

/**
 * @Auther: eniac
 * @Date: 4/15/22 19:28
 * @Description: 对ElasticSearch进行插入、查询等操作的工具类
 */


@Component
@Log4j
public class EsUtil {

    public static final String INDEX_NAME = "book-index";

    public static final String[] includes = new String[]{
        "normal", "ip.src", "ip.dst", "udp.src", "udp.dst",
        "tcp.client_port", "tcp.server_port", "handled",
        "ipsec", "ssl", "ssh", "timestamp"};

    public static final String[] excludes = new String[]{"ipsec.*", "ssl.*", "ssh.*"};

    private static Logger logger = Logger.getLogger("EsLog");

    public static String testTrafficString = "{\n" +
        "\t\"uid\": \"CDPVKt4gh2nf1WgmG5\",\n" +
        "\t\"ip\": {\n" +
        "\t\t\"src\": \"172.26.253.114\",\n" +
        "\t\t\"dst\": \"172.26.240.1\",\n" +
        "\t\t\"protocol\": 17,\n" +
        "\t\t\"version\": 4,\n" +
        "\t\t\"length\": 370,\n" +
        "\t\t\"payload\": [{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.220484,\n" +
        "\t\t\t\t\"length\": 59,\n" +
        "\t\t\t\t\"is_orig\": true,\n" +
        "\t\t\t\t\"optional\": 64\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.220489,\n" +
        "\t\t\t\t\"length\": 59,\n" +
        "\t\t\t\t\"is_orig\": true,\n" +
        "\t\t\t\t\"optional\": 64\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.27708,\n" +
        "\t\t\t\t\"length\": 150,\n" +
        "\t\t\t\t\"is_orig\": false,\n" +
        "\t\t\t\t\"optional\": 128\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.303108,\n" +
        "\t\t\t\t\"length\": 102,\n" +
        "\t\t\t\t\"is_orig\": false,\n" +
        "\t\t\t\t\"optional\": 128\n" +
        "\t\t\t}\n" +
        "\t\t]\n" +
        "\t},\n" +
        "\t\"udp\": {\n" +
        "\t\t\"src\": 58076,\n" +
        "\t\t\"dst\": 53,\n" +
        "\t\t\"packet_up\": 2,\n" +
        "\t\t\"packet_dn\": 2,\n" +
        "\t\t\"byte_up\": 62,\n" +
        "\t\t\"byte_dn\": 196,\n" +
        "\t\t\"payload\": [{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.220484,\n" +
        "\t\t\t\t\"length\": 31,\n" +
        "\t\t\t\t\"is_orig\": true\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.220489,\n" +
        "\t\t\t\t\"length\": 31,\n" +
        "\t\t\t\t\"is_orig\": true\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.27708,\n" +
        "\t\t\t\t\"length\": 122,\n" +
        "\t\t\t\t\"is_orig\": false\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"timestamp\": 1624007713.303108,\n" +
        "\t\t\t\t\"length\": 74,\n" +
        "\t\t\t\t\"is_orig\": false\n" +
        "\t\t\t}\n" +
        "\t\t]\n" +
        "\t},\n" +
        "\t\"dns\": {\n" +
        "\t\t\"queries\": [{\n" +
        "\t\t\t\t\"query\": \"www.baidu.com\",\n" +
        "\t\t\t\t\"qtype\": \"A\",\n" +
        "\t\t\t\t\"qclass\": \"C_INTERNET\",\n" +
        "\t\t\t\t\"answers\": [\n" +
        "\t\t\t\t\t\"www.a.shifen.com\",\n" +
        "\t\t\t\t\t\"220.181.38.149\",\n" +
        "\t\t\t\t\t\"220.181.38.150\"\n" +
        "\t\t\t\t]\n" +
        "\t\t\t},\n" +
        "\t\t\t{\n" +
        "\t\t\t\t\"query\": \"www.baidu.com\",\n" +
        "\t\t\t\t\"qtype\": \"AAAA\",\n" +
        "\t\t\t\t\"qclass\": \"C_INTERNET\",\n" +
        "\t\t\t\t\"answers\": [\n" +
        "\t\t\t\t\t\"www.a.shifen.com\"\n" +
        "\t\t\t\t]\n" +
        "\t\t\t}\n" +
        "\t\t]\n" +
        "\t}\n" +
        "} ";

    public static RestHighLevelClient client = null;


    @Value("${es.host}")
    public String host = "127.0.0.1";
    @Value("${es.port}")
    public String port;
    @Value("${es.scheme}")
    public String scheme;

    /**
     * Description: 初始化es连接
     *
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    @PostConstruct
    public void initClient() {
        try {
            if (client != null) {
                client.close();
            }
            String[] ports = port.split(",");
            HttpHost[] httpHosts = new HttpHost[ports.length];
            for (int i = 0; i < ports.length; i++) {
                httpHosts[i] = new HttpHost(host, Integer.parseInt(ports[i]), scheme);
            }
            client = new RestHighLevelClient(RestClient.builder(httpHosts));
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(0);
        }
    }

    /**
     * Description: 插入/更新一条记录
     *
     * @param index  index
     * @param entity 对象
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public IndexResponse insertOrUpdateOne(String index, EsEntity entity) {
        IndexRequest request = new IndexRequest(index, "doc", entity.getId());
        request.id(entity.getId());
        request.source(JSON.toJSONString(entity.getData()), XContentType.JSON);
        try {
            IndexResponse indexResponse = client.index(request, RequestOptions.DEFAULT);
            return indexResponse;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    /**
     * Description: 搜索
     *
     * @param index   index
     * @param builder 查询参数
     * @param c       结果类对象
     * @return java.util.ArrayList
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public <T> List<T> search(String index, SearchSourceBuilder builder, Class<T> c) {
        SearchRequest request = new SearchRequest(index);
        request.types("doc");
        request.source(builder);
        try {
            SearchResponse response = client.search(request, RequestOptions.DEFAULT);
            SearchHit[] hits = response.getHits().getHits();
            List<T> res = new ArrayList<>(hits.length);
            for (SearchHit hit : hits) {
                res.add(JSON.parseObject(hit.getSourceAsString(), c));
            }
            return res;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    //    public void deleteIndex(String index) {
    //        try {
    //            client.indices().delete(new DeleteIndexRequest(index), RequestOptions.DEFAULT);
    //        } catch (Exception e) {
    //            throw new RuntimeException(e);
    //        }
    //    }


    /**
     * Description: 根据ID获取单条记录
     *
     * @param getRequest get请求，在Controller层已经包装完成
     * @return void
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public Map<String, Object> getRecord(GetRequest getRequest) {

        Map<String, Object> res = null;
        try {
            GetResponse result = client.get(getRequest, RequestOptions.DEFAULT);
            System.out.println(result);
            res = result.getSource();
        } catch (Throwable e) {
            e.printStackTrace();
        }

        return res;
    }

    /**
     * Description: 更新数据，以插入Json中的方式更新，不对原本的Json中的数据有影响
     * From {"name1":"value1"}
     * To {"name1":"value1","name2":"value2"}
     *
     * @param indexName
     * @param uid
     * @param updateMap
     * @return void
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public void updateThreate(String indexName, String uid, Map<String, Object> updateMap) {
        UpdateRequest updateRequest = new UpdateRequest(indexName, "doc", uid).doc(updateMap);
        GetRequest getRequest = new GetRequest(indexName, "doc", uid);
        try {
            boolean exist = client.exists(getRequest, RequestOptions.DEFAULT);
            if (exist) {
                UpdateResponse updateResponse = client.update(updateRequest, RequestOptions.DEFAULT);
                System.out.println(updateResponse);
            } else {
                System.out.println("当前处理的消息不存在!!");
            }

        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public void appendToArray(String indexName, String uid, String arrayName, Object item) {
        ObjectMapper mapper = new ObjectMapper();
        @SuppressWarnings("unchecked")
        Map<String, Object> mappedItem = mapper.convertValue(item, Map.class);

        Map<String, Object> params = new HashMap<>();
        params.put("new_item", mappedItem);

        UpdateRequest request = new UpdateRequest(indexName, "_doc", uid);
        String scriptSource = "if (ctx._source." + arrayName + " == null) { "
            + "  ctx._source." + arrayName + " = new ArrayList(); "
            + "} "
            + "ctx._source." + arrayName + " .add(params.new_item);";

        Script script = new Script(ScriptType.INLINE, "painless", scriptSource, params);
        request.script(script);

        try {
            client.update(request, RequestOptions.DEFAULT);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * @param keyword  要查询的关键字
     * @param pageNo   从那个下标开始
     * @param pageSize 一页几个
     * @return
     * @author J-D-X
     */
    public String searchTraffic(String keyword, int pageNo, int pageSize) {
        if (pageNo < 0) {
            pageNo = 0;
        }
        // 构造请求
        SearchRequest searchRequest = new SearchRequest("test-traffic");
        // 构造builder
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        // 构造分页信息
        searchSourceBuilder.from(pageNo);
        searchSourceBuilder.size(pageSize);
        // 构造查询信息
        BoolQueryBuilder boolQueryBuilder;
        if (!"null".equals(keyword)) {
            ExistsQueryBuilder existsQueryBuilder = new ExistsQueryBuilder(keyword);
            boolQueryBuilder = new BoolQueryBuilder().filter(existsQueryBuilder);
        } else {
            boolQueryBuilder = new BoolQueryBuilder().must(QueryBuilders.matchAllQuery());
        }

        searchSourceBuilder.sort(new FieldSortBuilder("timestamp").order(SortOrder.DESC));
        searchSourceBuilder.fetchSource(includes, excludes);

        searchSourceBuilder.timeout(new TimeValue(60, TimeUnit.SECONDS));
        searchSourceBuilder.query(boolQueryBuilder);
        searchRequest.source(searchSourceBuilder);
        SearchResponse searchResponse = null;
        logger.debug("Es构造的请求：" + searchRequest);
        try {
            searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
        } catch (IOException e) {
            logger.error(e.toString());
        }
        logger.debug("Es返回的请求：" + searchResponse.toString());
        return searchResponse.toString();
    }

    /**
     * Description: 获取索引信息
     *
     * @param index
     * @return Map<String, String> key:属性名称，例如 tcp.src  tcp.dst ；value：属性类别，例如 text boolean 等
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public Map<String, String> getIndexInfo(String index) {
        // 查询索引 - 请求对象
        GetIndexRequest request = new GetIndexRequest(index);
        Map<String, String> nameTypeMap = new HashMap<>();
        // 发送请求，获取响应
        try {
            GetIndexResponse response = client.indices().get(request, RequestOptions.DEFAULT);
            System.out.println("获取索引信息的响应：" + response);
            System.out.println(response.getMappings());
            Map<String, MappingMetaData> mappings = response.getMappings();
            for (Map.Entry<String, MappingMetaData> indexValue : mappings.entrySet()) {
                Map<String, Object> mapping = indexValue.getValue().sourceAsMap();

                String jsonString = new JSONObject(mapping).toString();
                System.out.println("json：" + jsonString);

                Iterator<Map.Entry<String, Object>> entries = mapping.entrySet().iterator();
                entries.forEachRemaining(stringObjectEntry -> {
                    if (!stringObjectEntry.getKey().equals("properties")) return;

                    Set<String> indexList = new HashSet<>();
                    String prefix = "";

                    @SuppressWarnings("unchecked")
                    Map<String, Object> value = (Map<String, Object>) stringObjectEntry.getValue();
                    getIndexStringList(prefix, value, indexList, nameTypeMap);
                });

                return nameTypeMap;
            }
        } catch (Throwable e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * Description: 递归工具方法，用于对ES返回的indexInfo递归解析
     *
     * @param prefix      前缀，例如对于src的前缀是tcp，完整的应为 tcp.src 这样的格式的内容
     * @param value       Map类型，用于进行解析，包含解析到该层的数据和其下层的数据
     * @param resList     ArrayList 暂时没用。TODO：测试完毕后删除
     * @param nameTypeMap Map<String,String> key:属性名称，例如 tcp.src  tcp.dst ；value：属性类别，例如 text boolean 等
     * @return Map<String, String> key:属性名称，例如 tcp.src  tcp.dst ；value：属性类别，例如 text boolean 等
     * @author zhangzhao
     * @Date: 4/15/22 19:28
     */
    public Map<String, String> getIndexStringList(String prefix, Map<String, Object> value, Set<String> resList, Map<String, String> nameTypeMap) {
        for (Map.Entry<String, Object> objectEntry : value.entrySet()) {
            String key = objectEntry.getKey();
            Map<String, Object> value1 = (Map<String, Object>) objectEntry.getValue();

            if (value1.get("properties") != null) {
                // 还可以继续解析
                if (prefix.isEmpty()) {
                    String tempPreFix = prefix;
                    if (!key.equals("properties")) {
                        tempPreFix = key;
                    }
                    nameTypeMap = getIndexStringList(tempPreFix, (Map<String, Object>) value1.get("properties"), resList, nameTypeMap);
                } else {
                    String tempPreFix = prefix;
                    if (!key.equals("properties")) {
                        tempPreFix = prefix + "." + key;
                    }

                    nameTypeMap = getIndexStringList(tempPreFix, (Map<String, Object>) value1.get("properties"), resList, nameTypeMap);
                }
            } else {
                // 不能继续解析了
                if (prefix.isEmpty()) {
                    resList.add(key);
                    nameTypeMap.put(key, (String) value1.get("type"));
                } else {
                    resList.add(prefix + "." + key);
                    nameTypeMap.put(prefix + "." + key, (String) value1.get("type"));
                }
            }

        }
        return nameTypeMap;
    }


}
