package com.ruoyi.xt.util;

import com.ruoyi.xt.domain.ThreatMetricDTO;
import org.apache.poi.xwpf.usermodel.*;

import java.io.*;

public class DocxReportGenerator {

    public static File generateReport(ThreatMetricDTO dto, File chartImage) throws IOException {
        XWPFDocument doc = new XWPFDocument();

        // 报告标题
        XWPFParagraph title = doc.createParagraph();
        title.setAlignment(ParagraphAlignment.CENTER);
        XWPFRun runTitle = title.createRun();
        runTitle.setBold(true);
        runTitle.setFontSize(20);
        runTitle.setText(dto.getReportTitle());

        // 时间范围
        XWPFParagraph timePara = doc.createParagraph();
        XWPFRun runTime = timePara.createRun();
        runTime.setText("时间范围：" + dto.getTimeRange());

        // 添加图表图片
        try (FileInputStream fis = new FileInputStream(chartImage)) {
            XWPFParagraph chartPara = doc.createParagraph();
            XWPFRun chartRun = chartPara.createRun();
            chartRun.addBreak();
            chartRun.addPicture(fis,
                XWPFDocument.PICTURE_TYPE_PNG,
                chartImage.getName(),
                500 * 9525, 350 * 9525); // 宽高换算为EMU
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 添加指标数据表格
        XWPFTable table = doc.createTable(dto.getIndicators().size() + 1, 2);
        table.getRow(0).getCell(0).setText("指标");
        table.getRow(0).getCell(1).setText("数值");

        for (int i = 0; i < dto.getIndicators().size(); i++) {
            table.getRow(i + 1).getCell(0).setText(dto.getIndicators().get(i));
            table.getRow(i + 1).getCell(1).setText(dto.getValues().get(i).toString());
        }

        // 写入文件
        File file = File.createTempFile("threat_report_", ".docx");
        try (FileOutputStream out = new FileOutputStream(file)) {
            doc.write(out);
        }
        doc.close();
        return file;
    }
}
