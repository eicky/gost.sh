一键脚本安装方法：
```
快速使用(不保存gost.sh脚本)
bash <(curl -sL https://sh.334433.xyz/gost.sh)

国内使用
wget https://sh.334433.xyz/gost.sh && chmod +x gost.sh && bash gost.sh
或者
wget https://cdn.jsdelivr.net/gh/eicky/gost.sh/gost.sh && chmod +x gost.sh && bash gost.sh

国外使用
wget https://git.io/gost.sh && chmod +x gost.sh && bash gost.sh
```

说明：目前还是1.0.1版本，仅可以安装最新版本的gost，配置文件在`/etc/gost/config.json`，运行文件在`/usr/bin/gost`，进程守护文件在/`usr/lib/systemd/system/gost.service`

使用说明：gost的配置文件需要自己编写，格式参考gost的[官方文档](https://docs.ginuerzh.xyz/gost/getting-started/)，在安装完成后可以通过`bash gost.sh`来控制gost的启动停止重启状态也可通过`systemctl start/stop/restart/status gost`控制。安装前请确保`wget`已经安装，否则无法安装成功。

端口转发示例：
```
{
    "Debug": true,
    "Retries": 0,
    "ServeNodes": [
           "tcp://:111/1.1.1.1:443",
           "udp://:222/2.2.2.2:443"
    ]
}
```


改自：[https://www.fiisi.com/gost/gost.sh](https://www.fiisi.com/gost/gost.sh)

