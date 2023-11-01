## Docker Command

### Build docker image
To build your Dockerfile into an Image and upload it to DockerHub, you can follow the steps below:

1. **Create a Docker Image**:
    In the directory where your Dockerfile is located, execute the following command to create a Docker image:

    ```bash
    docker build -t dockerhub_username/image_name:your_tag .
    ```

    - `dockerhub_username`: Your username on DockerHub.
    - `image_name`: The name you want to give to your image.
    - `your_tag`: Tag version, e.g., `latest` or `v1.0` etc.

    Example:

    ```bash
    docker build -t myusername/myphpimage:latest .
    ```

2. **Log into DockerHub**:
    If you're not yet logged into Docker CLI, execute the following command:

    ```bash
    docker login
    ```

    Then enter your DockerHub account and password.

3. **Upload Docker Image to DockerHub**:
    Use the following command to push your Docker image to DockerHub:

    ```bash
    docker push dockerhub_username/image_name:your_tag
    ```

    If you use the previous example, the command will look like this:

    ```bash
    docker push myusername/myphpimage:latest
    ```

4. **Check DockerHub**:
    After the upload is complete, you can log into the DockerHub web interface and navigate to your repository to check if the newly uploaded image exists.

Please note:
- Make sure your Docker daemon is already running locally.
- Before uploading, please test your Docker image to ensure it works properly.

### Add `latest` tag to a docker image
When you create a Docker image without specifying a tag, Docker automatically labels it as `latest`. However, if you specify another tag, Docker will not automatically add the `latest` tag.

If you want to add both a specific tag and the `latest` tag to the same image, you need to perform two tagging and two push operations. Here are the detailed steps:

1. **Create the image**:
    ```bash
    docker build -t dockerhub_username/image_name:specific_tag .
    ```

    For example:

    ```bash
    docker build -t myusername/myphpimage:v1.0 .
    ```

2. **Tag the image as `latest`**:
    ```bash
    docker tag dockerhub_username/image_name:specific_tag dockerhub_username/image_name:latest
    ```

    Using the previous example:

    ```bash
    docker tag myusername/myphpimage:v1.0 myusername/myphpimage:latest
    ```

3. **Push the image with a specific tag to DockerHub**:
    ```bash
    docker push dockerhub_username/image_name:specific_tag
    ```

    For example:

    ```bash
    docker push myusername/myphpimage:v1.0
    ```

4. **Push the image with the `latest` tag to DockerHub**:
    ```bash
    docker push dockerhub_username/image_name:latest
    ```

    For example:
    ```bash
    docker push myusername/myphpimage:latest
    ```

After completing these steps, your image will have two tags: `specific_tag` and `latest`.

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
