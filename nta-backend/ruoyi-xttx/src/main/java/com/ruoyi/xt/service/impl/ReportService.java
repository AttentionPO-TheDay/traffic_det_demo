package com.ruoyi.xt.service.impl;


import com.ruoyi.xt.domain.ThreatMetricDTO;
import com.ruoyi.xt.util.ChartGenerator;
import com.ruoyi.xt.util.DocxReportGenerator;
import org.springframework.stereotype.Service;

import java.io.File;

@Service
public class ReportService {
    public File generateThreatReport(ThreatMetricDTO dto) throws Exception {
        File chartImage = ChartGenerator.generateThreatChart(dto.getIndicators(), dto.getValues());
        return DocxReportGenerator.generateReport(dto, chartImage);
    }
}
