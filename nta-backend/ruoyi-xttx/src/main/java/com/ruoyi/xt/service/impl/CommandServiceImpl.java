package com.ruoyi.xt.service.impl;

import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.xt.service.CommandService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.*;

/**
 * @Auther: eniac
 * @Date: 11/17/21 22:17
 * @Description:
 */
@Service
public class CommandServiceImpl implements CommandService, InitializingBean {
    @Value("${cmd.threadname:cmd-executor}")
    public String threadName = "cmd-executor";

    @Value("${cmd.taskQueueMaxStorage:20}")
    private Integer taskQueueMaxStorage = 20;

    @Value("${cmd.corePoolSize:4}")
    private Integer corePoolSize = 4;

    @Value("${cmd.maximumPoolSize:8}")
    private Integer maximumPoolSize = 8;

    @Value("${cmd.keepAliveSeconds:15}")
    private Integer keepAliveSeconds = 15;


    private ThreadPoolExecutor executor;
    private static final String BASH = "sh";
    private static final String BASH_PARAM = "-c";

    // use thread pool to read streams
    @Override
    public void afterPropertiesSet() {
        executor = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, keepAliveSeconds, TimeUnit.SECONDS,
            new ArrayBlockingQueue<Runnable>(taskQueueMaxStorage),
            r -> new Thread(r, threadName + r.hashCode()),
            new ThreadPoolExecutor.AbortPolicy());
    }

    @Override
    public Map<String, String> executeCmd(String cmd) {

        afterPropertiesSet();
        boolean isSuccess = true;
        Process p = null;
        String resStr;
        Map<String, String> res = new HashMap<>();
        try {
            // need to pass command as bash's param,
            // so that we can compatible with commands: "echo a >> b.txt" or "bash a && bash b"
            List<String> cmds = new ArrayList<>();
            // 将 sh -c 指令写入进程
            cmds.add(BASH);
            cmds.add(BASH_PARAM);
            // 将 zeek pcap指令写入进程
            cmds.add(cmd);
            // 利用刚刚创建的指令创建一个进程pb
            ProcessBuilder pb = new ProcessBuilder(cmds);
            // 启动进程
            p = pb.start();

            Future<String> errorFuture = executor.submit(new ReadTask(p.getErrorStream()));
            Future<String> resFuture = executor.submit(new ReadTask(p.getInputStream()));
            int exitValue = p.waitFor();
            if (exitValue > 0) {
                throw new RuntimeException(errorFuture.get());
            }
            resStr = resFuture.get();
            res.put("command_result", "success");

        } catch (Exception e) {
            res.put("command_result", "false");
            resStr = e.getMessage();
            res.put("error_msg", resStr);
            System.out.println(res);
            throw new RuntimeException(e);
        } finally {
            if (p != null) {
                p.destroy();
            }
            //            return res;
        }
        // remove System.lineSeparator() (actually it's '\n') in the end of res if exists
        if (StringUtils.isNotBlank(resStr) && resStr.endsWith(System.lineSeparator())) {
            resStr = resStr.substring(0, resStr.lastIndexOf(System.lineSeparator()));
        }
        res.put("msg", resStr);
        return res;
    }

    class ReadTask implements Callable<String> {
        InputStream is;

        ReadTask(InputStream is) {
            this.is = is;
        }

        @Override
        public String call() throws Exception {
            BufferedReader br = new BufferedReader(new InputStreamReader(is));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
            return sb.toString();
        }
    }
}
