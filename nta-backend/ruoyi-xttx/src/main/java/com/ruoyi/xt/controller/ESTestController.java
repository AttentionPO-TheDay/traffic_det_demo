package com.ruoyi.xt.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.xt.domain.Book;
import com.ruoyi.xt.domain.EsEntity;
import com.ruoyi.xt.util.EsUtil;
import org.elasticsearch.action.get.GetRequest;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

/**
 * @Auther: eniac
 * @Date: 4/15/22 23:20
 * @Description:
 */
@RestController
//@EnableAutoConfiguration
@RequestMapping("/es")
public class ESTestController {

    @Autowired
    private EsUtil esUtil;


    /**
     * 获取全部流量数据
     */
    @GetMapping("/testSearchAll")
    public AjaxResult getTrafficAll() {
        return AjaxResult.success(esUtil.search("test-traffic", new SearchSourceBuilder(), JSONObject.class));
    }

    /**
     * 根据关键词搜索某用户下的书
     * TODO：测试接口 测试后产出 commit之前
     *
     * @param content 关键词
     */
    @GetMapping("/search")
    public List<Book> searchByUserIdAndName(int userId, String content) {
        BoolQueryBuilder boolQueryBuilder = new BoolQueryBuilder();
        boolQueryBuilder.must(QueryBuilders.termQuery("userId", userId));
        boolQueryBuilder.must(QueryBuilders.matchQuery("name", content));
        SearchSourceBuilder builder = new SearchSourceBuilder();
        builder.size(10).query(boolQueryBuilder);
        return esUtil.search(EsUtil.INDEX_NAME, builder, Book.class);
    }

    /**
     * 根据条件精确搜索，目前不支持条件范围，例如jsonString中的数据是：
     * {"ip.src":"10.0.0.0"} 这样的类型,会根据条件到ES中进行检索，但对于
     * "tcp.client_port" >=100086 <=-50002 这样的范围的不等查找不支持。
     *
     * @param jsonString json格式的字符串
     */
    @GetMapping("/search_traffic")
    public AjaxResult searchTraffic(@RequestBody String jsonString, @RequestParam(value = "page") Integer pageNum, @RequestParam(value = "size") Integer pageSize) {

        BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
        Map<String, Object> map = JSON.parseObject(jsonString, Map.class);
        for (String obj : map.keySet()) {
            boolQueryBuilder.filter(QueryBuilders.termQuery(obj, map.get(obj)));
        }
        SearchSourceBuilder builder = new SearchSourceBuilder();
        builder.from(pageNum).size(pageSize).query(boolQueryBuilder);
        return AjaxResult.success(esUtil.search("test-traffic", builder, JSONObject.class));
    }

    /**
     * 转发restful query api 向ElasticSearch查询
     */

    @PostMapping("/query_traffic")
    public AjaxResult searchTrafficByQueryApi(@RequestBody String queryJson) {

        String url = "http://64.112.41.70:9200/test-traffic/_search";
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.valueOf("application/json;UTF-8"));
        HttpEntity<String> strEntity = new HttpEntity<String>(queryJson, headers);

        HttpEntity<String> formEntity = new HttpEntity<String>(queryJson);
        String resJosn = restTemplate.postForObject(url, strEntity, String.class);
        //        System.out.println();
        return AjaxResult.success(resJosn);
    }

    /**
     * 使用ES的JavaAPI查询流量类型
     *
     * @param keyword : 查询的流量类型
     * @return 流量类型
     */
    @GetMapping("/query_traffic_by_class")
    public AjaxResult searchTrafficByESJavaApi(@RequestParam(value = "keyword") String keyword, @RequestParam(value = "pageNo") int pageNo, @RequestParam(value = "pageSize") int pageSize) {
        System.out.println("keyword:" + keyword);
        return AjaxResult.success(esUtil.searchTraffic(keyword, pageNo, pageSize));
    }

    /**
     * 测试接口
     * TODO：commit后删除
     *
     * @param uid uid，流量id，从探针给的数据中来
     */
    @GetMapping("/searchTraffic")
    public List<JSONObject> searchByUidAndPort(@RequestParam(value = "uid", required = false) String uid, @RequestParam(value = "src", required = false) Integer srcPort, @RequestParam(value = "dst", required = false) Integer dstPort, @RequestParam(value = "src_ip", required = false) String srcIp, @RequestParam(value = "dst_ip", required = false) String dstIp) {
        BoolQueryBuilder boolQueryBuilder = new BoolQueryBuilder();
        if (uid != null) {
            boolQueryBuilder.must(QueryBuilders.termQuery("uid", uid));
        }
        if (srcPort != null) {
            System.out.println("======srcPort");
        }
        if (dstPort != null) {
            System.out.println("======dstPort");
        }
        if (srcIp != null) {
            boolQueryBuilder.must(QueryBuilders.termQuery("ip.src", srcIp));
        }
        if (dstIp != null) {
            boolQueryBuilder.must(QueryBuilders.termQuery("ip.dst", dstIp));
        }
        SearchSourceBuilder builder = new SearchSourceBuilder();
        builder.size(3).query(boolQueryBuilder);
        return esUtil.search("test-traffic", builder, JSONObject.class);
    }

    /**
     * 根据流量UID获取流量元数据信息
     *
     * @param uid uid，流量id，从探针给的数据中来
     */
    @GetMapping("/getTraffic")
    public AjaxResult getByUid(@RequestParam(value = "uid") String uid) {
        GetRequest getRequest = new GetRequest("test-traffic", "doc", uid);
        Map<String, Object> res = esUtil.getRecord(getRequest);
        return AjaxResult.success(res);
    }

    /**
     * 单个插入，测试接口
     *
     * @param book book
     */
    @PutMapping("/")
    public AjaxResult putOne(@RequestBody Book book) {
        EsEntity<Book> entity = new EsEntity<>(book.getId().toString(), book);
        System.out.println(entity.getData());
        IndexResponse indexResponse = esUtil.insertOrUpdateOne(EsUtil.INDEX_NAME, entity);
        System.out.println(indexResponse);
        return AjaxResult.success(indexResponse);
    }


    @GetMapping("/getIndex")
    public AjaxResult getIndexInfo(@RequestParam(value = "index") String index) {
        Map<String, String> resMap = esUtil.getIndexInfo(index);
        if (resMap != null) {
            return AjaxResult.success(resMap);
        } else {
            return AjaxResult.error("cannot get index info");
        }

    }

}

