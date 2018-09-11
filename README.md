# strongSwan Configuration #

## Overview ##

1，这是一个基于strongswan的支持国密算法sm1，sm2， sm3，sm4 的开源ipsec vpn
2，添加了gmalg插件，用于支持软算法 sm2， sm3， sm4
3，修改了pki工具，添加了支持sm2的各种证书生成读取
4，pki工具也添加了crypto命令，用于测试国密算法
5，strongswan支持使用TUN设备的应用层IPSec功能和基于内核xfrm的IPSec功能，由于内核xfrm需
   要内核加密支持另外写了一个soft_alg的内核加密驱动，使其内核支持sm3和sm4，便于测试，
   后面测试案例采用，TUN设备的应用层IPSec，但内核xfrm也是完全支持的，仅需修改配置，加载
   驱动即可

添加目录：build.sh  编译脚本
          testing/tests/gmalg 这个是测试脚本
          src/libstrongswan/plugins/gmalg 这是strongswan的加密算法插件框架
	        src/libstrongswan/plugins/gmalg/gmalg 这是sm2，sm3，sm4的软算法实现

  为了方便，将软算法的源代码放在了gmalg插件里，但也可以改用动态库形式，只需在configuie 命令后
面添加 --with-gmalg_interior=no参数即可，但要提供libgmalg.so 动态库及gmalg.h 头文件

   libgmalg.so可以有src/libstrongswan/plugins/gmalg/gmalg目录的源码生成，只需要在这个目录make就可
以， 生成文件在src/libstrongswan/plugins/gmalg/gmalg目录的.obj目录里面。如需替换软算法，修改
gmalg.c文件即可

编译软件：
    1，在strongswan目录运行autogen.sh命令。生成configuie命令
    2，在主机的根系统上创建 /ipsec 目录，添加权限 chmod 777 /ipsec
    3，在strongswan目录运行autogen.sh命令。配置，编译及安装strongswan
    4，将/ipsec目录打包拷贝到server和client上，必须解压到根目录，比如pki命令， /ipsec/bin/pki
    5，尽量不要用软件默认路径安装，便于删除和更新

测试脚本在testing/tests/gmalg目录，测试步骤如下：
   1，进入testing/tests/gmalg/ipsec_cert目录，运行sm2.sh命令，生成所需的所有证书，包括客户端和主机端
       运行local.sh 加载文件到所需目录，这里注意，只生成一次，客户端和主机端加载的ca证书相同，不然验证不过
   2，在服务端：运行src/libstrongswan/plugins/gmalg 目录下的init_server.sh脚本，初始化环境
   3，在客户端：运行src/libstrongswan/plugins/gmalg 目录下的init_client.sh脚本，初始化环境
   4，两端同时运行运行src/libstrongswan/plugins/gmalg 目录下的run.sh脚本，启动软件

ipsec规则设置：修改testing/tests/gmalg/swanctl目录里的ip地址，即可实际配置

使用内核xfrm 的配置：
  编译soft_alg驱动模块并加载
  服务端和客户端运行testing/tests/gmalg/libipsec/run_libipsec.sh脚本，修改配置即可
