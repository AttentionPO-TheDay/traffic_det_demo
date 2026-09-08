import request from '@/utils/request';

export async function generateThreatReport() {
  const data = {
    reportTitle: "网络威胁检测报告",
    timeRange: "2025-05-01 至 2025-05-30",
    indicators: ["DDoS 攻击", "恶意扫描", "端口暴力尝试", "异常登录"],
    values: [35, 22, 15, 9]
  };

  try {
    const response = await request({
      method: "post",
      url: 'threat/report/',
      data,
      responseType: 'blob'
  });

    // 创建下载链接
    const blob = new Blob([response.data], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
    const url = window.URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.setAttribute('download', 'threat_report.docx'); // 下载文件名
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    window.URL.revokeObjectURL(url);
  } catch (error) {
    console.error("报表生成失败：", error);
  }
};
