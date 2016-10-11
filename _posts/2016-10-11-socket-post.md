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

# 创建 Socket

1. 头文件 <sys/socket.h>
2. int socket(int af, int type, int protocol)
	2.1 Address Family: IP 地址类型 AF_INET (ipv4) / AF_INET6 (ipv6)
	2.2 Type: 传输方式 SOCK_STREAM / SOCK_DERAM
	2.3 Protocol: IPPROTO_TCP / IPPTOTO_UDP
	2.4 示例
		2.4.1 `int tcp_socket = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);`
		2.4.2 `int udp_socket = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);  `
		2.4.3 `int tcp_socket = socket(AF_INET, SOCK_STREAM, 0);`
		2.4.4 `int udp_socket = socket(AF_INET, SOCK_DGRAM, 0);`
3. 服务器端用 bind() 将套接字与特定的 IP 地址和端口绑定起来。
	3.1 原型 `int bind(int sock, struct sockaddr *addr, socklen_t addrlen);`
	3.2 sock: socket 文件描述符
	3.3 addr: sockaddr 结构体变量指针
	3.4 addrlen: addr 变量大小 (用 sizeof 计算得出)
	3.5 示例

```
//将创建的套接字与IP地址 127.0.0.1、端口 1234 绑定：
//创建套接字
int serv_sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

//创建sockaddr_in结构体变量
struct sockaddr_in serv_addr;
memset(&serv_addr, 0, sizeof(serv_addr));  //每个字节都用0填充
serv_addr.sin_family = AF_INET;  //使用IPv4地址
serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");  //具体的IP地址
serv_addr.sin_port = htons(1234);  //端口

//将套接字和IP、端口绑定 使用 sockaddr_in 强转成 sockaddr
bind(serv_sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
```

4. 客户端用 connect() 建立连接
	4.1 `int connect(int sock, struct sockaddr *serv_addr, socklen_t addrlen);`
5. 服务器端用 listen() 进入被动监听状态
	5.1 `int listen(int sock, int backlog);`
	5.2 backlog: 最大请求队列长度
	5.3 如果队列满了，客户端会收到 ECONNREFUSED 错误，Windows 则是 WSAECONNREFUSED
	5.4 listen 只会让套接字处在监听状态，没有接收请求。
6. 服务器端在监听状态下用 accept() 响应客户端请求
	6.1 `int accept(int sock, struct sockaddr *addr, socklen_t *addrlen);`
	6.2 accept 会返回一个新的套接字，后面再与这个客户端通信时，要使用这个新的套接字。
	6.3 accept 会阻塞程序，直到有新的请求到来。
7. 写入数据
	7.1 `ssize_t write(int fd, const void *buf, size_t nbytes);`
	7.2 fd: 写入文件的描述符(socket)
	7.3 buf: 写入数据的缓冲区地址
	7.4 nbytes: 数据字节数
	7.5 成功返回字节数，失败返回 -1
8. 读取数据
	8.1 `ssize_t read(int fd, void *buf, size_t nbytes);`
	8.2 fd: 写入文件的描述符(socket)
	8.3 buf: 接收数据的缓冲区地址
	8.4 nbytes: 读取的数据字节数
	8.5 成功则返回读取到的字节数，遇到文件结尾返回 0，失败返回 -1.
9. 关闭套接字
	9.1 `int close(int fd);`
	9.2 `int shutdown(int sock, int howto);`
		9.2.1 howto: 断开方式
			9.2.1.1 SHUT_RD: 断开输入流。无法接收数据了。
			9.2.1.2 SHUT_WR: 断开输出流。无法发送数据了。
			9.2.1.3 SHUT_RDWR: 同事断开 I/O 流。相当于调用了 RD 和 WR
	9.3 close 关闭套接字
	9.4 shutdown 只关闭连接，不关闭套接字
10. 通过域名获取 IP 地址
	10.1 `struct hostent *gethostbyname(const char *hostname);`
11. UDP
	11.1 `ssize_t sendto(int sock, void *buf, size_t nbytes, int flags, struct sockaddr *to, socklen_t addrlen);`
		11.1.1 sock: UDP 的套接字
		11.1.2 buf: 待传输的地址
		11.1.3 nbytes: 待创术的数据长度
		11.1.4 flags: 可选，传 0
		11.1.5 to: 目标地址信息的 sockaddr
		11.1.6 addrlen: to 地址值结构变量的长度
	11.2 `ssize_t recvfrom(int sock, void *buf, size_t nbytes, int flags, struct sockadr *from, socklen_t *addrlen);`
		11.2.1 sock: 接收的 UDP 数据套接字
		11.2.2 buf：保存接收数据的缓冲区地址；
		11.2.3 nbytes：可接收的最大字节数（不能超过buf缓冲区的大小）；
		11.2.4 flags：可选项参数，若没有可传递0；
		11.2.5 from：存有发送端地址信息的sockaddr结构体变量的地址；
		11.2.6 addrlen：保存参数 from 的结构体变量长度的变量地址值。

# 结构体

## sockaddr_in

```
struct sockaddr_in{
    sa_family_t     sin_family;   //地址族（Address Family），也就是地址类型
    uint16_t        sin_port;     //16位的端口号
    struct in_addr  sin_addr;     //32位IP地址
    char            sin_zero[8];  //不使用，一般用0填充
};
```

* sin_family: 和 socket() 的第一个参数的含义相同，取值也要保持一致。
* sin_prot: 为端口号。uint16_t 的长度为两个字节，理论上端口号的取值范围为 0~65536，但 0~1023 的端口一般由系统分配给特定的服务程序，例如 Web 服务的端口号为 80，FTP 服务的端口号为 21，所以我们的程序要尽量在 1024~65536 之间分配端口号。端口号需要用 htons() 函数转换。
* sin_addr: 是 struct in_addr 结构体类型的变量，下面会详细讲解。
* sin_zero[8]: 是多余的8个字节，没有用，一般使用 memset() 函数填充为 0。上面的代码中，先用 memset() 将结构体的全部字节填充为 0，再给前3个成员赋值，剩下的 sin_zero 自然就是 0 了。

## in_addr

```
#import <netinet/in.h>

struct in_addr{
    in_addr_t  s_addr;  //32位的IP地址 unsigned long
};

// 将字符串 IP 地址进行转换
unsigned long ip = inet_addr("127.0.0.1");
printf("%ld\n", ip);
```

## sockaddr_in6 保存 ipv6

```
struct sockaddr_in6 { 
    sa_family_t sin6_family;  //(2)地址类型，取值为AF_INET6
    in_port_t sin6_port;  //(2)16位端口号
    uint32_t sin6_flowinfo;  //(4)IPv6流信息
    struct in6_addr sin6_addr;  //(4)具体的IPv6地址
    uint32_t sin6_scope_id;  //(4)接口范围ID
};
```

## hostent 域名

```
struct hostent{
    char *h_name;  //官方域名
    char **h_aliases;  //别名
    int  h_addrtype;  //地址族类 AF_INET / AF_INET6
    int  h_length;  // IP 地址长度 ipv4 为 4 个字节，ipv6 为 16 个。
    char **h_addr_list;  // 以整数形式保存域名对于的 IP 地址，可能会有多个。
}
```
