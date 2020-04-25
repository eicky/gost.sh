一键脚本安装方法：
```
国内使用
wget https://cdn.jsdelivr.net/gh/eicky/gost.sh/gost.sh && chmod +x gost.sh && bash gost.sh
国外使用
wget https://git.io/gost.sh && chmod +x gost.sh && bash gost.sh
```

说明：目前还是1.0.0版本，仅可以安装最新版本的gost，配置文件在/etc/gost/config.json，运行文件在/usr/bin/gost，进程守护文件在/usr/lib/systemd/system/gost.service

使用说明：gost的配置文件需要自己编写，格式参考gost的官方文档，在安装完成后可以通过systemctl start/stop/restart/status gost，来控制gost的启动停止重启状态。要确保wget已经安装，不然无法进行。


改自：[https://www.fiisi.com/gost/gost.sh](https://www.fiisi.com/gost/gost.sh)

