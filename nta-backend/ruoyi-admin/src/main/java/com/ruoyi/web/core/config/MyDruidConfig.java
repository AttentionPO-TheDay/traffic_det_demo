package com.ruoyi.web.core.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource(value = {"classpath:application-druid.yml"})
public class MyDruidConfig {
    @Value("${spring.datasource.druid.master.url}")
    public String url;

    @Value("${spring.datasource.druid.master.username}")
    public String username;

    @Value("${spring.datasource.druid.master.password}")
    public String password;

}
