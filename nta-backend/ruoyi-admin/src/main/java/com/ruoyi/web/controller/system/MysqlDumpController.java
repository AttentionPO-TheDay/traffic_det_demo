package com.ruoyi.web.controller.system;

import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.web.core.config.MyDruidConfig;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@RestController
@RequestMapping("/xt/mysql")
@Api("数据库备份接口")
public class MysqlDumpController {
    @Autowired
    MyDruidConfig myDruidConfig;

    class MatchResult {
        String host, port, database;

        public MatchResult(String host, String port, String database) {
            this.host = host;
            this.port = port;
            this.database = database;
        }
    }

    private static Pattern pattern = Pattern.compile("jdbc:mysql://(?<host>[^:/]+):(?<port>\\d+)/(?<database>[^?]+)");

    @PostMapping("/dump")
    public AjaxResult mysqlDump() {
        MatchResult mr = parseUrl(myDruidConfig.url);
        try {
            Path currentPath = Paths.get(System.getProperty("user.home"));
            Long time = System.currentTimeMillis();
            String filename = "mysql-dump" + String.valueOf(time) + ".sql";
            Process process = Runtime.getRuntime().exec(new String[]{
                "docker", "run", "--rm", "-d",
                "-v", "/root/dump:/dump",
                "mysql:5.7.36",
                "/usr/bin/mysqldump",
                "-h" + mr.host,
                "-P" + mr.port,
                "-u" + myDruidConfig.username,
                "-p" + myDruidConfig.password,
                "--result-file", "/dump/" + filename,
                mr.database,
            });
            process.waitFor();

            int exitValue = process.exitValue();
            if (exitValue != 0) {
                return AjaxResult.error("mysqldump 失败", exitValue);
            }
        } catch (Exception e) {
            return AjaxResult.error(e.toString());
        }

        return AjaxResult.success();
    }

    private MatchResult parseUrl(String url) {
        Matcher m = pattern.matcher(url);
        if (!m.find()) {
            throw new RuntimeException("傻逼，你 JDBC URL 咋写的，这都找不到");
        }

        return new MatchResult(m.group("host"), m.group("port"), m.group("database"));
    }

}
