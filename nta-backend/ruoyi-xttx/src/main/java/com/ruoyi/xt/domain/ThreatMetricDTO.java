package com.ruoyi.xt.domain;

import lombok.Data;
import java.util.List;

@Data
public class ThreatMetricDTO {
    private String reportTitle;
    private String timeRange;
    private List<String> indicators;
    private List<Integer> values;
}
