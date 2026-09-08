import {
  SettingFilled,
  SafetyOutlined,
  MergeOutlined,
  CloudServerOutlined,
  AlertFilled
} from "@ant-design/icons";
import Probe from "../pages/Probe";
import Traffic from "../pages/Traffic";
import TrafficUpload from "../pages/Traffic/TrafficUpload";
import Threat from "../pages/Threat";

import RiskAsset from "../pages/Asset/RiskAsset";
import AssetManage from "../pages/Asset/AssetManage";
import Overview from "../pages/Overview";
import HistoryAsset from "../pages/Asset/HistoryAsset";
import AssetScan from "../pages/Asset/AssetScan";
import Model from "@/pages/Model";

export default {
  path: "/",
  routes: [
    {
      path: "/operation",
      name: "系统运维",
      icon: <SettingFilled />,
      routes: [
        { path: "/operation/probe", name: "探针管理", component: <Probe /> },
        {
          path: "/operation/traffic",
          name: "离线流量上传",
          component: <TrafficUpload />,
        }
      ],
    },
    {
      path: "/identification",
      name: "DL流量识别",
      icon: <MergeOutlined />,
      routes: [
        {
          path: "/identification/overview",
          name: "流量总览",
          component: <Traffic />,
        },
        {
          path: "/identification/model",
          name: "识别模型管理",
          component: <Model />,
        },
      ]
    },
    {
      path: "/analysis",
      name: "协议分析",
      icon: <SafetyOutlined />,
      routes: [
        { path: "/analysis/tls", name: "TLS流量", component: <Traffic appTag="ssl" /> },
        { path: "/analysis/ipsec", name: "IPSec流量", component: <Traffic appTag="ipsec" /> },
        { path: "/analysis/ssh", name: "SSH流量", component: <Traffic appTag="ssh" /> },
        { path: "/analysis/https", name: "HTTP/S流量", component: <Traffic appTag="http" /> },
        { path: "/analysis/smtp", name: "SMTP流量", component: <Traffic appTag="smtp" /> },
        { path: "/analysis/imap", name: "IMAP流量", component: <Traffic appTag="imap" /> },
        { path: "/analysis/pop3", name: "POP3流量", component: <Traffic appTag="pop3" /> },
        { path: "/analysis/rdp", name: "RDP流量", component: <Traffic appTag="rdp" /> }
      ],
    },
    {
      path: "/threat",
      name: "威胁情报",
      icon: <AlertFilled />,
      routes: [
        { path: "/threat/overview", name: "威胁总览", component: <Overview /> },
        {
          path: "/threat/threaten-assets",
          name: "风险资产",
          component: <RiskAsset />,
        },
        {
          path: "/threat/threat-retrieval",
          name: "威胁检索",
          component: <Threat />,
        },
        // { path: '/threat/threat-retrieval', name: '威胁检索',component: <UserThreat/> },
      ],
    },
    {
      path: "/asset",
      name: "资产管理",
      icon: <CloudServerOutlined />,
      routes: [
        { path: "/asset/search", name: "资产发现", component: <AssetScan /> },
        {
          path: "/asset/history",
          name: "历史记录",
          component: <HistoryAsset />,
        },
        {
          path: "/asset/management",
          name: "资产信息管理",
          component: <AssetManage />,
        },
      ],
    },
  ],
};
