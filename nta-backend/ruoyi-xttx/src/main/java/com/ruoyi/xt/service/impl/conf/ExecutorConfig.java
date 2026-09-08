package com.ruoyi.xt.service.impl.conf;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;
import java.util.concurrent.ThreadPoolExecutor;

/**
 * @Auther: eniac
 * @Date: 11/28/21 02:28
 * @Description:
 */
@Configuration
@EnableAsync
public class ExecutorConfig {
    /**
     * Set the ThreadPoolExecutor's core pool size.
     */
    @Value("${executor.corepoolsize:2}")
    private int corePoolSize;
    /**
     * Set the ThreadPoolExecutor's maximum pool size.
     */
    @Value("${executor.maxpoolsize:4}")
    private int maxPoolSize;
    /**
     * Set the capacity for the ThreadPoolExecutor's BlockingQueue.
     */
    @Value("${executor.queueCapacity:500}")
    private int queueCapacity;

    @Bean("aexecutor")
    public Executor insertExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(corePoolSize);
        executor.setMaxPoolSize(maxPoolSize);
        executor.setQueueCapacity(queueCapacity);
        executor.setThreadNamePrefix("executor-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.initialize();
        return executor;
    }
}
