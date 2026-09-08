package com.ruoyi.xt.domain.template;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LabelConfidence {
    @JsonProperty("label")
    private String label;

    @JsonProperty("prob")
    private double prob;

    @Override
    public String toString() {
        return "LabelConfidence{" +
            "label='" + label + '\'' +
            ", prob='" + prob + '\'' +
            '}';
    }
}
