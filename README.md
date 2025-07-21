# Proxmox Terraform

---

# 🛠️ Proxmox-Terraform

**Proxmox-Terraform** adalah proyek otomatisasi infrastruktur menggunakan **Terraform** untuk membuat dan mengelola virtual machine (VM) di **Proxmox VE**, serta dukungan integrasi dengan **Ansible** untuk provisioning dan konfigurasi lebih lanjut.

---

## 📦 Fitur

* ✅ Provisioning VM tunggal dan multi-VM di Proxmox menggunakan Terraform
* 🔐 Peningkatan keamanan VM default
* 🤖 Dukungan integrasi Ansible untuk konfigurasi otomatis pasca-deploy
* 📄 Dokumentasi lengkap untuk memulai dengan cepat

---

## 📁 Struktur Direktori

```
.
├── doc-vm/           # Dokumentasi setup dan panduan keamanan VM
├── multi-vm/         # Konfigurasi Terraform untuk multiple VMs + Ansible
├── .gitignore        # File dan direktori yang diabaikan Git
└── README.md         # Dokumentasi proyek ini
```

---

## 🚀 Prasyarat

Sebelum menjalankan proyek ini, pastikan Anda sudah menginstal:

* [Proxmox VE](https://www.proxmox.com/en/)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
* Akses user ke Proxmox dengan API token/credential

---

## ⚙️ Setup dan Penggunaan

### 1. Clone repository ini:

```bash
git clone https://github.com/username/Proxmox-Terraform.git
cd Proxmox-Terraform
```

### 2. Konfigurasi akses ke Proxmox

Di dalam file `terraform.tfvars` atau `variables.tf`, sesuaikan nilai berikut:

```hcl
proxmox_url      = "https://your-proxmox-ip:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "yourpassword"
target_node      = "pve"
```

> ⚠️ Gunakan credential yang aman atau gunakan environment variables dan file `.gitignore` untuk menyembunyikannya.

---

### 3. Inisialisasi dan jalankan Terraform

```bash
terraform init
terraform plan
terraform apply
```

---

### 4. Gunakan Ansible untuk provisioning (opsional)

Masuk ke direktori `multi-vm` (jika ingin menggunakan Ansible setelah provisioning):

```bash
cd multi-vm
ansible-playbook -i inventory.ini playbook.yml
```

---

## 📝 Dokumentasi

Lihat folder `doc-vm/` untuk:

* 📘 Dokumentasi setup awal
* 🔐 Panduan pengamanan VM default
* 🧪 Best practices untuk provisioning dan testing

---

## 💡 Contoh Kasus Penggunaan

* Infrastruktur lab virtual berbasis Proxmox
* Deployment otomatis untuk VM Dev/Test
* Kombinasi provisioning (Terraform) dan konfigurasi (Ansible)

---

## 📌 TODO / Roadmap

* [x] Dukungan multi-VM
* [x] Integrasi Ansible
* [ ] Dynamic inventory untuk Ansible
* [ ] Tambah opsi backup VM via Proxmox API
* [ ] Monitoring dan alert otomatis

---

## 📄 Lisensi

Lisensi: MIT License
Lihat file [LICENSE](LICENSE) untuk detail lebih lanjut.

---

## 🤝 Kontribusi

Pull request sangat diterima. Untuk perubahan besar, mohon buat issue terlebih dahulu untuk didiskusikan.

---

## 📬 Kontak

Dikembangkan oleh: **Saputra Tanuwijaya**
Untuk pertanyaan atau kolaborasi, silakan hubungi melalui email atau buka issue.