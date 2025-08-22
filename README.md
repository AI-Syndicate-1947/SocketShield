# 🔒 SocketShield
**Because your Docker socket deserves PKI.**

SocketShield is a **TLS-enabled proxy for the Docker socket**, inspired by [docker-socket-proxy](https://github.com/Tecnativa/docker-socket-proxy), with an emphasis on **modern security practices**.  
It ensures that all communications between your services and the Docker API are **encrypted** and **restricted**, so you can safely let applications talk to Docker — while keeping the host under control.

---

## ✨ Features
- 🛡️ **TLS-enabled socket** – All traffic is encrypted with self-signed or custom certificates.  
- 🔐 **Fine-grained access** – Control access to the Docker API with environment variables (`CONTAINERS=1`, etc.).  
- 🧭 **Client compatibility** – Works with most Docker clients and tooling without changes.  
- 🚫 **No traffic escapes** – Communication is restricted from service → socket only; no malicious inception possible.  
- ⚖️ **Alternative & companion** – Complements `docker-socket-proxy` by adding TLS termination, giving users the freedom to choose what fits their setup best.  

---

## 🛠️ Tech Stack
- **Docker Compose** – Deployment & orchestration  
- **Nginx** – TLS termination  
- **Shell Script** – Certificate generation (`cert-generator.sh`)  
- **Docker-Socket-Proxy** – Upstream inspiration  

---

## 🌟 Why SocketShield?
### This project was born by accident (while setting up a homelab 😅) — but it solves a real problem:
- Mounting the Docker socket into containers is risky.
- Plain TCP sockets expose your Docker API unencrypted.
- SocketShield ensures encryption + access control, making Docker safer for homelabs and production alike.

#### SocketShield is not a replacement, but an alternative and a companion to projects like docker-socket-proxy.
_You can choose whichever fits your environment best — or use them together for layered security._

## 📂 Project Structure

.
├── cert-generator.sh     # Self-signed certificate generator
├── nginx.conf            # Nginx TLS proxy configuration
├── docker-compose.yml    # Example deployment file
└── certs/                # Generated certificates


## 🚀 Getting Started

### 1. Generate Certificates
```bash
./cert-generator.sh
```
### This will create certificates under `./certs`.

### 2. Run the Compose File
```bash
docker compose -f local-compose.yaml up -d
```

### 3. Configure the environment variables
```bash
export DOCKER_HOST=tcp://localhost:2376
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=~/docker-socket-proxy/certs
```

### 4. Talk to _our good old-friend_ Docker, as usual
```bash
docker ps -> Should work 
docker images -> 403 Unauthorized
```

