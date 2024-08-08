# 🐳 Docker WordPress Template

## 📋 Overview
This project provides a complete WordPress environment using Docker containers, including a backup routine and SSL/TLS certificate support. It's designed to be simple to set up and manage.

## 🧱 Components
- 🌐 WordPress container (using Bitnami image)
- 🗄️ Database container (using MariaDB)
- 💾 Backup container (for managing WordPress and database backups)
- 🔒 SSL/TLS support containers:
  - nginx-web
  - nginx-gen
  - nginx-letsencrypt

SSL/TLS support is based on [docker-letsencrypt](https://github.com/evertramos/docker-letsencrypt).

## 🛠️ Prerequisites
- 🐧 Linux Ubuntu (tested on 18.04.2 LTS)
- 🐳 Docker (tested with version 18.09.6)
- 🐙 Docker Compose (tested with version 1.21.2)

Note: Also works on macOS, and potentially on Windows (untested).

## 🚀 Quick Start
1. Clone the repository:
   ```
   git clone https://github.com/cleitonsouza01/docker-wordpress
   ```

2. Set up the environment:
   ```
   cd docker-wordpress
   cp .env-sample .env
   vim .env  # Customize as needed
   ```

3. Set up and start containers:
   ```
   ./manager.sh setupcontainers
   ./manager.sh setupdir
   ./manager.sh startverbose
   ```

4. After initial setup, use daemon mode:
   ```
   ./manager.sh start
   ```

5. Access your WordPress site:
   ```
   http://your-server-ip:port-specified-in-.env
   ```

## 🔒 SSL/TLS Certificate Setup
1. Configure docker-letsencrypt:
   ```
   cd docker-letsencrypt
   cp .env.sample .env
   cd ..
   ```

2. Update your DNS records with your server IP.

3. Restart the infrastructure:
   ```
   ./manager.sh stop
   ./manager.sh startnginx
   ./manager.sh start
   ```

## 💾 Backup and Restore
- ⏰ Daily backups run at 3:00 AM.
- 🔄 Manual backup:
  ```
  docker exec yourproject_bkp backup
  ```
- 🔙 Restore from backup:
  ```
  docker exec yourproject_bkp restore YYYYMMDD
  ```

## ⚠️ Troubleshooting
### macOS Issue
If encountering DB container errors on macOS, try:
```
rm -rf data
mkdir -p data/wordpress_data/
mkdir -p data/mariadb_data/
```

## 📁 Project Structure
- `manager.sh`: Main management script
- `docker-compose.yaml`: Docker Compose configuration
- `.env`: Environment variables
- `data/`: WordPress and MariaDB data
- `backups/`: Backup files

## 🙏 Acknowledgements
- [Let's Encrypt](https://letsencrypt.org/) for free SSL/TLS certificates

## 📊 Version Information
- WordPress: 6.6.1-debian-12-r5
- MariaDB: 11.4.2-debian-12-r2

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## ✍️ Author
Cleiton Souza - cleitonsouza01@gmail.com

