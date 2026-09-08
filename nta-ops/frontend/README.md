## 前端部署指南

1. 把前端放到 `/root/frontend` 目录下；
2. 在 https://caddyserver.com/download 下载最新版 Caddy，记得 platform 要选择你服务器的平台（一般是 Linux amd64）；
3. 把 caddy 可执行文件放到 ~ 下，执行命令 `chmod 755 ~/caddy`；
4. 在本仓库 nta-ops/frontend 目录下运行 `sudo caddy run` 命令即可。

