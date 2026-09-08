package com.ruoyi.xt.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.ruoyi.xt.domain.template.LabelConfidence;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

/**
 * @Auther: sinrotic
 * @Date: 4/15/25 15:54
 * @Description:
 */
@Getter
@Setter
public class AnalyseResult {
    @JsonProperty("uid")
    private String uid;

    @JsonProperty("model_name")
    private String modelName;

    @JsonProperty("model_id")
    private String modelId;

    @JsonProperty("classification_result")
    private List<LabelConfidence> classificationResult;

    @Override
    public String toString() {
        return "AnalyseResult{" +
            "uid='" + uid + '\'' +
            ", modelName='" + modelName + '\'' +
            ", modelId='" + modelId + '\'' +
            ", classificationResult=" + classificationResult +
            '}';
    }
}