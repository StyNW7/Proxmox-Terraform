# 🛠️ Proxmox-Terraform

**Proxmox-Terraform** is an infrastructure automation project that uses **Terraform** to create and manage virtual machines (VMs) on **Proxmox VE**, with optional integration of **Ansible** for post-deployment provisioning and configuration.

---

## 📦 Features

* ✅ Provision single and multiple VMs on Proxmox using Terraform
* 🔐 Enhanced default VM security configurations
* 🤖 Optional Ansible integration for automated post-deployment setup
* 📄 Comprehensive documentation to help you get started quickly

---

## 📁 Directory Structure

```
.
├── doc-vm/           # VM setup documentation and security guides
├── multi-vm/         # Terraform configs for multiple VMs + Ansible integration
├── .gitignore        # Git ignored files and directories
└── README.md         # Project documentation
```

---

## 🚀 Prerequisites

Before running this project, make sure you have installed:

* [Proxmox VE](https://www.proxmox.com/en/)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
* A Proxmox user account with API token or credentials

---

## ⚙️ Setup and Usage

### 1. Clone the repository

```bash
git clone https://github.com/username/Proxmox-Terraform.git
cd Proxmox-Terraform
```

---

### 2. Configure Proxmox access

Edit the `terraform.tfvars` or `variables.tf` file and update the following values:

```hcl
proxmox_url      = "https://your-proxmox-ip:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "yourpassword"
target_node      = "pve"
```

> ⚠️ Use secure credentials. It is recommended to use environment variables and `.gitignore` to protect sensitive data.

---

### 3. Initialize and run Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

### 4. Use Ansible for provisioning (optional)

If you want to run Ansible after provisioning:

```bash
cd multi-vm
ansible-playbook -i inventory.ini playbook.yml
```

---

## 📝 Documentation

See the `doc-vm/` directory for:

* 📘 Initial setup documentation
* 🔐 Default VM hardening guide
* 🧪 Best practices for provisioning and testing

---

## 💡 Use Cases

* Virtual lab infrastructure on Proxmox
* Automated VM deployment for development and testing
* Combined provisioning (Terraform) and configuration (Ansible) workflows

---

## 📌 TODO / Roadmap

* [x] Multi-VM support
* [x] Ansible integration
* [ ] Dynamic inventory for Ansible
* [ ] VM backup options via Proxmox API
* [ ] Automated monitoring and alerting

---

## 📄 License

Licensed under the MIT License.
See the [LICENSE](LICENSE) file for more details.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to improve.

---

## 📬 Contact

Developed by: **NW, NV, AT, NP, VW, KF**
For questions or collaboration, feel free to reach out via email or open an issue.
