---
layout: post
title: "Socket"
description: "学习 Socket 笔记"
date: 2016-10-11
tags: [Socket]
comments: true
share: true
---

[C 语言中文网 Socket 教程](http://c.biancheng.net/cpp/html/3029.html)

# 关键词

* IP 地址 (IP Address)
	* IPv4(10进制): xxx.xxx.xxx.xxx
	* IPv6(16进制): xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx
* 端口 (Port)
	* Web: 80
	* FTP: 21
	* SMTP: 25
* 协议 (Protocol)
	* TCP
	* UDP
* 传输方式
	* SOCK_STREAM - TCP 准确传输
	* SOCK_DGRAM - UDP 高效但有一定几率丢失
* 特殊 IP 地址
	* 127.0.0.1 表示本机地址

# Socket 交互流程

* 创建准备阶段
	* 服务器或客户端: 使用 gethostbyname() 来通过域名获取 IP 地址和端口
	* 服务器: 创建 Socket 
	* 服务器: 使用 bind() 将套接字与特定的 IP 地址和端口绑定
	* 客户端: 创建 Socket
* 连接阶段(UDP 不需要建立连接)
	* 服务器: 使用 listen() 进入监听状态
	* 服务器: 使用 accpet() 接收客服端的请求，返回客户端 Socket。(如无请求，会阻塞程序进行等待)
	* 客户端: 使用 connect() 建立连接，并获得服务器 Socket。
* 数据交互阶段 
	* 服务器或客户端: 使用 wirte() 对对方 Socket 进行数据写入。
	* 服务器或客户端: 使用 read() 对对方 Socket 进行数据读取。
	* UDP 情况下使用 sendto() 发送数据。
	* UDP 情况下使用 recvfrom() 接收数据。
* 关闭阶段
	* 服务器或客户端: 使用 close() 关闭套接字
	* 服务器或客户端: 使用 shutdow() 关闭连接(但不会关闭套接字)

# Socket 常用函数

## socket 创建

```
int socket(int af, int type, int protocol)
```
* 返回 Socket 描述符
* af: 地址类型
	* AF_INET: ipv4 地址
	* AF_INET6: ipv6 地址
* type: 传输方式
	* SOCK_STREAM: 面向连接 (TCP)
	* SOCK_DERAM: 无连接 (UDP)
* protocol: 协议
	* IPPROTO_TCP
	* IPPTOTO_UDP

```
// 示例
int tcp_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
int udp_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
int tcp_socket = socket(AF_INET, SOCK_STREAM, 0);
int udp_socket = socket(AF_INET, SOCK_DGRAM, 0);
```

## bind() 绑定地址

```
int bind(int sock, struct sockaddr *addr, socklen_t addrlen);
```
* 返回值: 0 正常 / -1 错误
* sock: Socket 文件描述符
* addr: sockaddr 结构体变量指针(一般用 sockaddr_in / sockaddr_in6 强转)
* addrlent: arrd 结构体大小(一般用 sizeof() 计算得出)

```
// 示例
//将创建的套接字与IP地址 127.0.0.1、端口 1234 绑定：
//创建套接字
int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

//创建sockaddr_in结构体变量
struct sockaddr_in serv_addr;
memset(&serv_addr, 0, sizeof(serv_addr));            //每个字节都用0填充
serv_addr.sin_family = AF_INET;                      //使用IPv4地址
serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //具体的IP地址
serv_addr.sin_port = htons(1234);                    //端口

//将套接字和IP、端口绑定 使用 sockaddr_in 强转成 sockaddr
bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
```

## connect() 客户端建立连接

```
int connect(int sock, struct sockaddr *serv_addr, socklen_t addrlen);
```

* 返回值: 正常返回 0
* sock: Socket
* serv_addr: 
* addrlen: 

## listen() 服务器端进入监听状态

```
int listen(int sock, int backlog);
```

* 返回值: 正常返回 0 / 否则 -1
* sock: 
* backlog: 最大请求队列长度
	* 如果请求的时候队列满了，客户端会收到 ECONNREFUSED。
	* 监听状态下并不对客户端做出响应，也不会堵塞线程

## accept() 服务器在监听状态下获取客户端请求

```
int accept(int sock, struct sockaddr *addr, socklen_t *addrlen);
```

* 返回值: 新的套接字，表示客户端的套接字
* sock: 服务器端的 Socket
* addr: 新建的用来接收地址信息的结构体指针
* addrlen: 接收地址信息的结构体大小

> accpet 会阻塞当前线程直到有新的请求到来。

## write() 写数据到缓冲区

```
ssize_t write(int fd, const void *buf, size_t nbytes);
```

* 返回值: 成功则返回字节数，否则返回 -1
* fd: Socket
* buf: 写入数据的缓冲区地址指针
* nbytes: 写入数据的字节数

> 数据只是写入到缓冲区，但是什么时候发送不由程序员控制。

## read() 从缓冲区中读取数据

```
ssize_t read(int fd, void *buf, size_t nbytes);
```

* 返回值: 成功则返回字节数，文件尾则返回 0，失败返回 -1
* fd: Socket
* buf: 用来接收数据的缓冲区地址指针
* nbytes: 要读取数据的字节数

> 只是读取缓冲区数据

## shutdown() 关闭连接

```
int shutdown(int sock, int howto);
```

* 返回值: 成功 0 / 失败 -1
* sock: Socket
* howto: 断开方式
	* SHUT_RD: 断开输入流。无法接收数据了。
	* SHUT_WR: 断开输出流。无法发送数据了。
	* SHUT_RDWR: 同事断开 I/O 流。相当于调用了 RD 和 WR

## close() 关闭套接字

```
int close(int fd);
```

* 返回值: 成功 0 / 失败 -1
* fd: Socket

# Socket 其他

## TCP

简单的在服务器端建立 Socket 并开始监听，然后在客户端进行连接并接收数据。

* 服务器端

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(){
    //创建套接字
    int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    //将套接字和IP、端口绑定
    struct sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
    serv_addr.sin_family = AF_INET;  //使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //具体的IP地址
    serv_addr.sin_port = htons(1234);  //端口
    bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    //进入监听状态，等待用户发起请求
    listen(serv_sock, 20);
    
    //接收客户端请求
    struct sockaddr_in clnt_addr;
    socklen_t clnt_addr_size = sizeof(clnt_addr);
    int clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_addr, &clnt_addr_size);
    
    //向客户端发送数据
    char str[] = "Hello World!";
    write(clnt_sock, str, sizeof(str));
    
    //关闭套接字
    close(clnt_sock);
    close(serv_sock);
    return 0;
}
```

* 客户端

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
int main(){
    //创建套接字
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    //向服务器（特定的IP和端口）发起请求
    struct sockaddr_in serv_addr;
    
    memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
    serv_addr.sin_family = AF_INET;  //使用IPv4地址
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //具体的IP地址
    serv_addr.sin_port = htons(1234);  //端口
    connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    
    //读取服务器传回的数据
    char buffer[40];
    read(sock, buffer, sizeof(buffer)-1);
    
    printf("Message form server: %s\n", buffer);
    
    //关闭套接字
    close(sock);
    return 0;
}
```

## UDP

创建一个 UDP 连接的 Socket，服务器不断的接收客户端的消息，然后返回回去。

* 服务器

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>

#define BUF_SIZE 100

int main(){
    // 创建套接字
    int serv_sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    
    // 绑定套接字
    sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = PF_INET;
    serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); // 自动获取 ip 地址
    serv_addr.sin_port = htons(1234);
    bind(serv_sock, (sockaddr *)&serv_addr, sizeof(sockaddr));
    
    // 接收客户端请求
    sockaddr clin_addr;
    socklen_t clin_size = sizeof(sockaddr);
    char buffer[BUF_SIZE];
    
    while (1) {
        int str_len = recvfrom(serv_sock, buffer, BUF_SIZE, 0, &clin_addr, &clin_size);
        printf("Message form clinet: %s\n", buffer);
        sendto(serv_sock, buffer, str_len, 0, &clin_addr, clin_size);
    }
    
    close(serv_sock);
    return 0;
}
```

```
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>

#define BUF_SIZE 100

int main() {
    
    // 创建套接字
    int clin_sock = socket(PF_INET, SOCK_DGRAM, 0);
    
    // 服务器地址
    sockaddr_in serv_addr;
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = PF_INET;
    serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_port = htons(1234);
    
    //不断获取用户输入并发送给服务器，然后接受服务器数据
    sockaddr fromAddr;
    socklen_t addrLen = sizeof(fromAddr);
    while(1){
        char buffer[BUF_SIZE] = {0};
        printf("Input a string: ");
        gets(buffer);
        sendto(clin_sock, buffer, strlen(buffer), 0, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
        int strLen = recvfrom(clin_sock, buffer, BUF_SIZE, 0, &fromAddr, &addrLen);
        buffer[strLen] = 0;
        printf("Message form server: %s\n", buffer);
    }
    
    close(clin_sock);
    return 0;
}
```

## 缓冲区

* I/O 缓冲区在每个 TCP Socket 中单独存在
* I/O 缓冲区在创建 Socket 时自动生成。
* 关闭 Socket 也会继续输出缓冲区中遗留的数据
* 关闭 Socket 会丢失输入缓冲区中的数据。
* 默认缓冲区大小是 8K，可以通过 getsockopt() 函数获取

```
// 示例
unsigned optVal;
int optLen = sizeof(int);
getsockopt(servSock, SOL_SOCKET, SO_SNDBUF, (char*)&optVal, &optLen);
printf("Buffer length: %d\n", optVal);
```

## TCP Socket 堵塞模式

* write()
	* 检查缓冲区，如果缓冲区的可用空间长度小于要发送的数据，那么 write() 会被阻塞，直到缓冲区中的数据被发送到目标机器，腾出足够的空间，才继续写入数据。
	* 如果 TCP 协议正在向网络发送数据，那么输出缓冲区会被锁定，不允许写入，直到数据发送完毕缓冲区解锁，才被唤醒。
	* 如果要写入的数据大于缓冲区的最大长度，那么将分批写入。
	* 直到所有数据被写入缓冲区 write() 才能返回。
* read()
	* 检查缓冲区，如果缓冲区中有数据，那么就读取，否则函数会被阻塞，直到网络上有数据到来。
	* 如果要读取的数据长度小于缓冲区中的数据长度，那么就不能一次性将缓冲区中的所有数据读出，剩余数据将不断积压，直到再次读取。
	* 直到读取到数据后 read() 函数才会返回，否则就一直被阻塞。

# Socket 常用数据结构

#include <sys/socket.h>

## sockaddr - 通用 Ip 地址结构体

```
struct sockaddr {
	__uint8_t	sa_len;		
	sa_family_t	sa_family;	
	char		sa_data[14];	
};
```

* sa_len: 结构体总长度
* sa_family: 地址族
	* AF_INET: ipv4 地址
	* AF_INET6: ipv6 地址
* char: IP 地址和端口号

## sockaddr_in - Ipv4 地址结构

```
struct sockaddr_in {
	__uint8_t	sin_len;
	sa_family_t	sin_family;
	in_port_t	sin_port;
	struct	in_addr sin_addr;
	char		sin_zero[8];
};
```

* sin_len: 结构体长度
* sin_family: 地址族(一般是 AF_INET)
* sin_port: 16位端口号，需要用 htons() 进行转换
* sin_addr: in_addr 类型的结构体，包含一个 32 位的 ip 地址，定义在 <netinet/in.h> 中
	* 一般使用 inet_addr() 函数将字符串类型的 ip 地址转换成为可使用的地址
* sin_zero[8]: 多余的 8 个字节，一般用 memset() 填充为 0

## sockaddr_in6 - Ipv6 地址结构

```
struct sockaddr_in6 {
	__uint8_t	sin6_len;	
	sa_family_t	sin6_family;
	in_port_t	sin6_port;	
	__uint32_t	sin6_flowinfo;	
	struct in6_addr	sin6_addr;	
	__uint32_t	sin6_scope_id;	
};
```

* sin6_len: 结构体长度
* sin6_family: 地址族(一般是 AF_INET6)
* sin6_port: 16 位端口号，需要用 htons() 进行转换
* sin6_flowinfo: Ipv6 流信息
* sin6_addr: Ipv6 地址
* sin6_scope_id: 接口范围 id 

## in_addr - Ipv4 地址

```
struct in_addr {
	in_addr_t s_addr;
};
```

## in6_addr - Ipv6 地址

```
struct in6_addr {
	union {
		__uint8_t   __u6_addr8[16];
		__uint16_t  __u6_addr16[8];
		__uint32_t  __u6_addr32[4];
	} __u6_addr;			/* 128-bit IP6 address */
};
``
## hostent - 通过域名获取的 ip 地址结构

```
#include <netdb.h>
struct hostent {
	char	*h_name;	
	char	**h_aliases;	
	int	h_addrtype;
	int	h_length;	
	char	**h_addr_list;	
};`
```

* h_name：官方域名
* h_aliases：别名, 可以通过多个域名访问同一主机
* h_addrtype：地址族, IPv4 对应 AF_INET, IPv6 对应 AF_INET6
* h_length：保存IP地址长度. IPv4 的长度为4个字节，IPv6 的长度为16个字节
* h_addr_list：以整数形式保存域名对应的IP地址, 可能会分配多个IP地址

### 实例

```
// 代码
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>
int main(){
    struct hostent *host = gethostbyname("www.baidu.com");
    //别名
    for(int i=0; host->h_aliases[i]; i++){
        printf("Aliases %d: %s\n", i+1, host->h_aliases[i]);
    }
    //地址类型
    printf("Address type: %s\n", (host->h_addrtype==AF_INET) ? "AF_INET": "AF_INET6");
    //IP地址
    for(int i=0; host->h_addr_list[i]; i++){
        printf("IP addr %d: %s\n", i+1, inet_ntoa( *(struct in_addr*)host->h_addr_list[i] ) );
    }
    system("pause");
    return 0;
}

// 输出
Aliases 1: www.baidu.com
Address type: AF_INET
IP addr 1: 14.215.177.38
IP addr 2: 14.215.177.37
sh: pause: command not found
Program ended with exit code: 0
```
