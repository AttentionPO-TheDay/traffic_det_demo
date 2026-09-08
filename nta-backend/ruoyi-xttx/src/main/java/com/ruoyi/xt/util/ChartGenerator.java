package com.ruoyi.xt.util;

import org.knowm.xchart.*;
import java.io.*;
import java.util.List;

public class ChartGenerator {

    public static File generateThreatChart(List<String> indicators, List<Integer> values) throws IOException {
        CategoryChart chart = new CategoryChartBuilder()
            .width(640).height(480)
            .title("Threat Indicators Over Time")
            .xAxisTitle("Indicators")
            .yAxisTitle("Count")
            .build();

        chart.addSeries("Threats", indicators, values);

        File imageFile = File.createTempFile("threat_chart", ".png");
        BitmapEncoder.saveBitmap(chart, imageFile.getAbsolutePath(), BitmapEncoder.BitmapFormat.PNG);
        return imageFile;
    }
}
