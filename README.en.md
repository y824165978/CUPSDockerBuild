zh_CN [简体中文](README.md)

# Using Github Action workflow，build CUPS docker image from source code

Built cups docker image：[cups-2.4.12-amd64.tar.gz
](https://github.com/y824165978/DockerAction/releases/tag/CUPS-DOCKER-IMAGE-AMD64)

#### Running
1. Load CUPS image
    ```sh
    docker load -i cups-2.4.12-amd64.tar.gz
    ```

2. Run a container with the CUPS image
copy`docker-compose.yaml` (You can modify the configuration as needed)
    ```sh
    docker-compose up -d
    ```

3. To start an interactive terminal in the container
    ```sh
    docker exec -it cups /bin/bash
    ```

4. Default Administrator
    ```
    username：`admin`
    password：`admin`
    ```
