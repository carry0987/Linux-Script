## Docker Command

### Clean up docker
If you're looking for ways to clean up your `Docker` environment, below are some commands that can help.

1. Stop all running containers
`$(docker container ls -a -q)` will return all container IDs (including those that have been stopped)
    ```bash
    docker stop $(docker container ls -a -q)
    ```

2. Remove unused resources
    ```bash
    docker system prune
    ```
This will remove unused networks, and all stopped containers, all volumes not used by at least one container, and all images without at least one container associated to them. When you run this command, `Docker` will ask for your confirmation whether or not to delete those resources. If you want not to be asked and you know it is safe to delete, you can add -f for force deletion.

3. Remove all Docker images
`$(docker images -a -q)` will return all image IDs.
    Please be careful as this may remove images that you are using or planning to use. If you're unsure, it's better not to use this command.
    ```bash
    docker rmi $(docker images -a -q)
    ```
Please note the `docker system prune` command requires `Docker` 17.06.1-ce or newer. Refer to this log to make sure that your system is up to date! Also, be careful while using these commands as they might delete resources that you might need now or in the future.
