package com.ruoyi.xt.controller;

import com.ruoyi.xt.domain.ThreatMetricDTO;
import com.ruoyi.xt.service.impl.ReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import java.io.File;

@RestController
@RequestMapping("/threat/report")
@RequiredArgsConstructor
public class ReportController {
    @Autowired
    private final ReportService reportService;

    @PostMapping("/")
    public ResponseEntity<FileSystemResource> generateReport(@RequestBody ThreatMetricDTO dto) throws Exception {
        File report = reportService.generateThreatReport(dto);
        FileSystemResource resource = new FileSystemResource(report);
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=threat_report.docx");
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        return new ResponseEntity<>(resource, headers, HttpStatus.OK);
    }
}
