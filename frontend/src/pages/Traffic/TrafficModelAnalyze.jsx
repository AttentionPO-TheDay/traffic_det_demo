import { useState, useEffect } from "react";
import { Divider, Table, Col, Row } from "antd";
import { getTraffMetaData } from "../../services/Traffic/queryTraffic";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  Legend,
  ResponsiveContainer,
  CartesianGrid,
} from "recharts";

function softmax(logits) {
    if (!Array.isArray(logits)) {
    console.error("softmax函数输入的不是数组，而是：", logits);
    return [];
  }
  const maxLogit = Math.max(...logits); // 防止溢出
  const exps = logits.map(x => Math.exp(x - maxLogit));
  const sumExps = exps.reduce((a, b) => a + b, 0);
  return exps.map(exp => exp / sumExps);
}

// 异步获取分析数据
const showTrafficAnalyzeResult = async ({ dataFilter, setAnalyseResults }) => {
  try {
    const response = (await getTraffMetaData(dataFilter)).data;
    const analyseResult = response.data.analyse_results;
    const processedResults = analyseResult.map(model => {
      const logits = model.classification_result.map(item => item.prob);
      const probs = softmax(logits);
      const updatedClassificationResult = model.classification_result.map((item, index) => ({
        ...item,
        probability: parseFloat(probs[index].toFixed(4)) // 添加归一化后的概率字段
      }));

      return {
        ...model,
        classification_result: updatedClassificationResult
      };
    });


    setAnalyseResults(processedResults ? processedResults : []);
  } catch (error) {
    console.error("获取模型分析数据失败:", error);
  }
};

const TrafficModelAnalyze = ({ dataFilter }) => {
  const [analyseResults, setAnalyseResults] = useState([]);

  useEffect(() => {
    setAnalyseResults([]);
    showTrafficAnalyzeResult({ dataFilter, setAnalyseResults });
  }, [dataFilter]);

  // 处理图表数据：计算每个模型的最大置信度
  const chartData = analyseResults.map((model) => {
    const confidences = model.classification_result?.map((item) => item.probability) || [];
    const maxConfidence = confidences.length > 0 ? Math.max(...confidences) : 0;

    return {
      modelName: model.model_name,
      modelId: model.model_id,
      avgConfidence: parseFloat((maxConfidence * 100).toFixed(2)), // 转换为百分比
      resultCount: model.classification_result?.length || 0,
    };
  });

console.log(chartData);

  const mainColumns = [
    {
      title: "模型名称",
      dataIndex: "model_name",
      key: "model_name",
    },
    {
      title: "模型 ID",
      dataIndex: "model_id",
      key: "model_id",
    },
  ];
  const subColumns = [
    {
      title: "识别结果",
      dataIndex: "label",
      key: "label",
    },
    {
      title: "置信度",
      dataIndex: "probability",
      key: "probability",
      render: (value) => `${(value * 100).toFixed(2)}%`,
    },
  ];

  return (
    <div>
      <Divider orientation="left">流量模型结果可视化</Divider>
      <ResponsiveContainer width="80%" height={400}>
        <BarChart data={chartData} margin={{ top: 20, right: 30, left: 30, bottom: 5 }}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="modelName" />
          <YAxis unit="%" />
          <Tooltip
            formatter={(value, name) => {
              if (name === "avgConfidence") return [`${value}%`, "平均置信度"];
              if (name === "resultCount") return [value, "分类结果数"];
              return [value, name];
            }}
          />
          <Legend />
          <Bar dataKey="avgConfidence" fill="rgb(226, 112, 118)" name="平均置信度" barSize={80} />
          <Bar dataKey="resultCount" fill="rgb(86, 103, 188)" name="分类类别数" barSize={40}/>
        </BarChart>
      </ResponsiveContainer>

      <div style={{ marginTop: "30px" }} />
      <Divider orientation="left">流量模型分析结果</Divider>
      <Row justify="start">
        <Col span={24}>
          <Table
            columns={mainColumns}
            dataSource={analyseResults}
            rowKey="model_id"
            expandable={{
              expandedRowRender: (record) => (
                <Table
                  columns={subColumns}
                  dataSource={record.classification_result}
                  pagination={false}
                  rowKey={(_, index) => `${record.model_id}_${index}`}
                />
              ),
              rowExpandable: (record) =>
                record.classification_result &&
                record.classification_result.length > 0,
            }}
            pagination={false}
          />
        </Col>
      </Row>
    </div>
  );
};

export default TrafficModelAnalyze;
