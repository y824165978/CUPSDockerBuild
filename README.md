en [English](README.en.md)

# 使用Github Action工作流，从源码开始构建CUPS镜像

已构建镜像地址：[cups-2.4.12-amd64.tar.gz
](https://github.com/y824165978/DockerAction/releases/tag/CUPS-DOCKER-IMAGE-AMD64)

#### 使用方法
1. 载入镜像
    ```sh
    docker load -i cups-2.4.12-amd64.tar.gz
    ```

2. 运行镜像
复制`docker-compose.yaml`，根据需要修改配置
    ```sh
    docker-compose up -d
    ```

3. 在容器中启动交互式终端
    ```sh
    docker exec -it cups /bin/bash
    ```

4. 默认管理员
    ```
    用户名：`admin`
    密码：`admin`
    ```
