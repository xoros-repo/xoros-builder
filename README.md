# Xoros Builder

## Quick launch

### 1. Obtain code

```shell
git clone https://github.com/xoros-repo/xoros-builder.git
```

### 2. Run image using docker-compose

#### 2.1 Modify your .env file

To get your Github runner token, go to repository Settings -> Actions -> Runners -> New self-hosted runner.

> ![img.png](docs/img/img.png)

Example `.env` file:

```dotenv
GITHUB_REPO=xoros-repo/meta-xoros
GITHUB_RUNNER_TOKEN=AABBCCDDEEFFGGHHIIJJKKLLMMNNO
```

#### 2.2. Launch docker-compose

```shell
docker-compose --env-file .env up -d --remove-orphans
```
