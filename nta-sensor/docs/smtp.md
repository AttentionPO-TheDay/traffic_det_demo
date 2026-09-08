# SMTP 协议

SMTP（Simple Mail Transfer Protocol）即简单邮件传输协议，尽管邮件服务器可以用SMTP发送、接收邮件，但是邮件客户端只能用SMTP发送邮件，接收邮件一般用[IMAP](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol) 或者 [POP3](https://en.wikipedia.org/wiki/Post_Office_Protocol) 。邮件客户端使用TCP的25号端口与服务器通信。

### 模型

![20180527095947433](C:\Users\tcjy\Desktop\20180527095947433.png)

SMTP被设计基于以下交流模型：当用户需要发邮件时候，邮件发送者(sender-SMTP)建立一个与邮件接收者(receiver-SMTP)通信的通道，发送者发送SMTP命令给接收者，接收者收到后对命令做回复。

通信通道被建立后，发送者发送 *MAIL* 命令来指定发送者的邮件，如果接受者接收这个邮件，就回复 *OK* ，接着发送者发送 *RCPT*命令来指定接收者的邮箱，如果被接收同样回复*OK*，如果不接受则拒绝（不会终止整个通话）。接收者邮箱确定后，发送者用*DATA*命令指示要发送数据，并用一个 .  结束发送。如果数据被接收，会收到*OK* ，然后用*QUIT*结束会话。

### 步骤

这里有三个步骤对于mail事务，第一步用 MAIL 命令给出发送者的身份，第二步用一个或者多个RCPT命令给出接收者信息，接着用DATA命令给出邮件数据。

下面的例子演示一下这些命令的使用（S: send发送，R：reply 回复）:

S: MAIL FROM:<Smith@Alpha.ARPA>
R: 250 OK
S: RCPT TO:<Jones@Beta.ARPA>
R: 250 OK
S: RCPT TO:<Green@Beta.ARPA>
R: 550 No such user here
S: RCPT TO:<Brown@Beta.ARPA>
R: 250 OK
S: DATA
R: 354 Start mail input; end with <CRLF>.<CRLF>
S: Blah blah blah...
S: ...etc. etc. etc.
S: <CRLF>.<CRLF>
R: 250 OK`

Jones and Brown可以收到邮件，Green邮箱无效不能收到邮件。




## 参考资料

[^rfc]: [SMTP协议详解](https://www.rfc-editor.org/rfc/rfc4253.html)