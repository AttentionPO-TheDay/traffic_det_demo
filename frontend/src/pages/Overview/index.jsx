import { useState, useEffect } from "react";
// import ReactDOM from 'react-dom';
import { ProCard } from "@ant-design/pro-components";
import { Line, Liquid, Pie, Column, Heatmap } from "@ant-design/plots";
import { Button, Card, Col, Divider, message, Row, Statistic } from "antd";
import { generateThreatReport } from "@/services/Threat/report";
import { getTrend } from "@/services/Threat/overview";


const DemoHeatmap = () => {
  const generateMockData = () => {
    const data = [];
    const daysInWeek = 7;
    const weeksInYear = 52;

    // 生成52周×7天的数据
    for (let week = 0; week < weeksInYear; week++) {
      for (let day = 0; day < daysInWeek; day++) {
        let commits;
        const rand = Math.random();

        if (rand < 0.7) {
          commits = Math.floor(Math.random() * 3); // 70%的概率0-2次
        } else if (rand < 0.9) {
          commits = Math.floor(Math.random() * 5) + 3; // 20%的概率3-7次
        } else {
          commits = Math.floor(Math.random() * 4) + 8; // 10%的概率8-11次
        }

        if (day === 0 || day === 6) {
          commits = Math.max(0, commits - 2);
        }

        data.push({
          week,
          day,
          commits,
          date: new Date(2023, 0, week * 7 + day + 1)
        });
      }
    }

    return data;
  };

  const data = generateMockData();
  console.log(data);

  const config = {
    height: 220,
    data,
    xField: 'week',
    yField: 'day',
    colorField: 'commits',
    style: { inset: 0.5 },
    mark: "cell",
    scale: {
      color: {
        type: 'threshold',
        domain: [2, 7, 10],
        range: ['#ebedf0', '#c6e48b', '#7bc96f', '#239a3b'],
      },
    },
    axis: {
      x: {
        title: "周"
      },
      y: {
        title: "星期",
        labelFormatter: (day) => {
            const days = ['', 'Mon', '', 'Wed', '', 'Fri', ''];
            return days[day] || '';
          },
      }
    },
    tooltip: {
      title: null,
      items: [
        { field: 'commits', name: "威胁数量" }
      ]
    },
  };

  return <Heatmap {...config} />;
};

const DemoPie = ({ threats }) => {
  const total = Object.entries(threats ? threats : [])
    .map(([threatName, counts]) => ({
      type: threatName,
      value: counts.reduce((sum, count) => sum + count, 0)
    }));

  const config = {
    height: 300,
    data: total,
    angleField: 'value',
    colorField: 'type',
    label: {
      text: 'value',
      style: {
        fontWeight: 'bold',
      },
    },
    legend: {
      position: 'right'
    },
    interaction: {
      elementHighlight: true,
    },
    state: {
      inactive: { opacity: 0.5 },
    }
  };
  return <Pie {...config} />;
};

const DemoLine = ({ threats, times }) => {
  const data = Object.entries(threats ? threats : []).flatMap(([threatName, counts]) => {
    return counts.map((c, idx) => ({
      date: times[idx],
      type: threatName,
      value: c
    }));
  });

  console.log(data);

  const config = {
    data,
    xField: 'date',
    yField: 'value',
    colorField: 'type',
    point: {
      shapeField: 'square',
      sizeField: 4,
    },
    interaction: {
      tooltip: {
        marker: true,
      },
    },
    height: 300,
    style: {
      lineWidth: 2,
    },
  };
  return <Line {...config} />;
};

const DemoLiquid = () => {
  const config = {
    height: 220,
    // margin: 0,
    percent: 0.3,
    style: {
      outlineBorder: 4,
      outlineDistance: 8,
      waveLength: 128,
    },
  };
  return <Liquid {...config} />;
};


const DemoDynBarChart = () => {
  //主机IP号
  const MockData = [
    { threat_ip: "217.77.3.118", threat_count: 10 },
    { threat_ip: "5.35.104.31", threat_count: 90 },
    { threat_ip: "1217.77.3.119", threat_count: 40 },
  ];

  const config = {
    data: MockData,
    xField: "threat_ip",
    yField: "threat_count",
    label: {
      position: "inside",
      style: {
        fill: "#FFFFFF",
        fontSize: 14,
        fontWeight: "bold",
      },
    },
    color: "#1890ff",
    height: 300,
    xAxis: {
      title: { text: "受威胁 IP 地址" },
      label: { autoHide: false, autoRotate: true },
    },
    yAxis: {
      title: { text: "受威胁总次数" },
      label: { formatter: (v) => `${v} 次` },
    },
  };

  return <Column {...config} />;
};


const Overview = () => {
  const [trend, setTrend] = useState({});

  const loadTrending = async () => {
    try {
      const resp = (await getTrend()).data;
      setTrend(resp.data);
    } catch (err) {
      message.error('获取威胁总览信息失败');
      console.error(err);
    }
  }

  useEffect(() => {
    loadTrending();
  }, []);

  return (
    <>
      <Divider orientation="left">核心指标</Divider>
      <ProCard.Group direction="row">
        <ProCard>
          <Statistic title="威胁等级" value={30} suffix="/ 100" />
        </ProCard>
        <ProCard.Divider type="vertical" />
        <ProCard>
          <Statistic title="威胁数目" value={12} />
        </ProCard>
        <ProCard.Divider type="vertical" />
        <ProCard>
          <Statistic title="受威胁主机" value={3} />
        </ProCard>
        <ProCard.Divider type="vertical" />
        <ProCard>
          <Statistic title="异常数目" value={112} />
        </ProCard>
      </ProCard.Group>

      <Divider orientation="left">威胁等级</Divider>
      <div style={{ marginTop: '20px' }} />
      <Row gutter={16}>
        <Col span={8}>
          <Card variant="outlined">
            <DemoLiquid />
          </Card>
        </Col>
        <Col span={8}>
          <Card title="威胁状态监控" variant="outlined">
            <p>您的系统正在受到威胁，您可以按照系统提供的建议进行处理。</p>
            <Button type="primary" onClick={generateThreatReport}>导出报表</Button>
          </Card>
        </Col>
      </Row>


      <div style={{ marginTop: '40px' }} />
      <Divider orientation="left">告警状态</Divider>
      <Row>
        <Col span={8}>
          <DemoPie threats={trend?.alertTrendTop} />
        </Col>
        <Col span={16}>
          <DemoLine threats={trend?.alertTrendTop} times={trend?.time} />
        </Col>
      </Row>


      <Divider orientation="left">受威胁主机统计</Divider>
      <div style={{ marginTop: '40px' }} />
      <Row justify={"center"}>
        <Col span={20}>
          <DemoDynBarChart />
        </Col>
      </Row>

      <Divider orientation="left">威胁时间分布</Divider>
      <div style={{ marginTop: '40px' }} />
      <Row justify={"center"}>
        <Col span={20}>
          <DemoHeatmap />
        </Col>
      </Row>
    </>
  )
}

export default Overview
