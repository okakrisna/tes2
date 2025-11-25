# 🎊 Multi-Template Wedding Management System - User Guide

Sistem admin panel sekarang sudah di-upgrade menjadi **Multi-Template Wedding Management System**! Anda bisa mengelola banyak wedding projects dengan berbagai template dari satu dashboard.

---

## 🎯 **Apa yang Baru?**

### Sebelumnya:
- ❌ Hanya bisa manage 1 wedding (Timeless)
- ❌ Harus edit HTML manual untuk ganti template
- ❌ Tidak ada dashboard untuk list projects

### Sekarang:
- ✅ Manage **unlimited wedding projects**
- ✅ **2 templates** tersedia (Timeless & Elegant) - mudah tambah lebih banyak
- ✅ **Dashboard profesional** dengan filter, search, dan analytics
- ✅ **Setiap wedding punya URL unik** (`/wedding/couple-name`)
- ✅ **Status management** (Draft, Active, Archived)
- ✅ **View counter** per project
- ✅ **Template switching** - ganti template kapan saja

---

## 🚀 **Quick Start Guide**

### 1. Akses Admin Dashboard
Buka browser dan ke:
```
http://localhost:5173/admin/
```

Anda akan melihat **Dashboard** yang menampilkan:
- 📊 Stats cards (Total projects, Active, Views, Drafts)
- 🔍 Search bar untuk cari projects
- 🎨 Filter by template & status
- 📋 Grid view semua wedding projects

### 2. Create Wedding Project Baru

**Langkah-langkah:**

1. **Klik tombol "➕ Create New Wedding"**

2. **Step 1: Choose Template**
   - Pilih template yang diinginkan (Timeless atau Elegant)
   - Klik template card untuk select
   - Klik "Next: Basic Info →"

3. **Step 2: Basic Information**
   - **Couple Names**: Nama pasangan (e.g., "Hanson & Catherine")
   - **Groom Full Name**: Nama lengkap pria
   - **Bride Full Name**: Nama lengkap wanita
   - **Wedding Date**: Tanggal pernikahan (format bebas)
   - **Initial Status**:
     - **Draft** = tidak public, hanya untuk testing
     - **Active** = public, bisa diakses orang lain
   - **Custom URL Slug**: (optional) otomatis di-generate dari couple names

   Klik "Next: Review →"

4. **Step 3: Review & Create**
   - Review semua data yang diinput
   - Lihat preview URL wedding
   - Klik "✨ Create Project"

   Sistem akan otomatis redirect ke **Edit Page** untuk melengkapi detail.

### 3. Edit Wedding Project

Di halaman edit, Anda bisa mengisi:

#### Basic Info Section:
- Nama pasangan
- Nama lengkap pria & wanita
- Judul wedding
- Tanggal pernikahan

#### Venue Section:
- Nama tempat (venue)
- Alamat lengkap
- Link Google Maps
- Waktu akad nikah
- Waktu resepsi

#### Images Section:
- **Background Image**: Hero section background
- **Groom Photo**: Foto pria
- **Bride Photo**: Foto wanita
- **Hero Background**: Main background image
- **Livestreaming Image**: Thumbnail untuk live stream
- **Gallery Images**: Multiple photos (pilih banyak sekaligus)

#### Thank You Message:
- Pesan terima kasih di akhir undangan

**Upload Gambar:**
- Klik "Choose File" untuk upload dari komputer
- Preview akan muncul otomatis
- Image akan tersimpan di `/wp-content/uploads/custom/`

**Simpan Changes:**
- Klik tombol "💾 Simpan Semua Perubahan"
- Tunggu hingga muncul notifikasi sukses

### 4. Preview & Publish

**Preview:**
- Klik tombol "👁️ Preview" di project card (dashboard)
- Atau klik link "👁️ Preview" di edit page
- Wedding page akan terbuka di tab baru

**Publish:**
- Set status project ke **"Active"** agar public
- Share URL ke couple: `/wedding/{slug}`
- Contoh: `http://localhost:5173/wedding/hanson-catherine`

---

## 📱 **URL Structure**

### Admin URLs:
```
/admin/                        → Dashboard (list all projects)
/admin/dashboard.html          → Same as above
/admin/create.html             → Create new project wizard
/admin/edit.html?id={uuid}     → Edit specific project
```

### Public Wedding URLs:
```
/wedding/{slug}                → Dynamic router (auto-redirect ke template)
/timeless/?slug={slug}         → Direct access to Timeless template
/elegant/?slug={slug}          → Direct access to Elegant template (coming soon)
```

Contoh:
- `/wedding/hanson-catherine`
- `/timeless/?slug=hanson-catherine`

---

## 🎨 **Template Details**

### 1. **Timeless Template** ✅
- **Style**: Classic & elegant with smooth animations
- **Features**:
  - Video/image hero section
  - Countdown timer
  - Gallery with lightbox
  - Google Maps integration
  - Livestreaming section
  - RSVP form
- **Best for**: Traditional weddings, formal events
- **Status**: ✅ Fully functional

### 2. **Elegant Template** ⚙️
- **Style**: Minimalist & sophisticated
- **Features**: Similar to Timeless but different layout
- **Best for**: Modern couples, simple design lovers
- **Status**: ⚙️ Dalam progress (template sudah ada, perlu integration)

### 3. **Classic Template** 🔜
- **Coming soon!**
- Will support vintage/classic design elements

---

## 📊 **Dashboard Features**

### Stats Cards:
- **Total Projects**: Jumlah semua wedding projects
- **Active Projects**: Projects yang status active (public)
- **Total Views**: Gabungan views dari semua projects
- **Draft Projects**: Projects yang masih draft

### Search & Filter:
- **Search**: Cari by couple names
- **Filter by Template**: Timeless, Elegant, All
- **Filter by Status**: Active, Draft, Archived, All
- **Sort by**:
  - Newest First
  - Oldest First
  - Most Views
  - Name A-Z

### Project Cards:
Setiap project card menampilkan:
- Template badge (corner kiri atas)
- Status badge (corner kanan atas)
- Couple names
- Wedding date
- View count
- Action buttons:
  - ✏️ Edit
  - 👁️ Preview
  - 🗑️ Delete (dengan konfirmasi)

---

## 🔄 **Workflow Recommended**

### Untuk Wedding Vendor/Agency:

1. **Client onboarding:**
   - Create new project di dashboard
   - Pilih template yang diminta client
   - Set status "Draft"

2. **Content creation:**
   - Edit project, isi semua data client
   - Upload photos dari client
   - Preview untuk QA

3. **Client review:**
   - Share preview URL ke client
   - Minta feedback & approval

4. **Launch:**
   - Setelah approved, ubah status ke "Active"
   - Share public URL ke client
   - Client bisa share ke guests

5. **Post-event:**
   - Archive project setelah wedding selesai
   - Keep data untuk portfolio

---

## 🛠️ **Advanced Features**

### Custom Slug:
- Slug otomatis generated dari couple names
- Format: lowercase, alphanumeric + hyphens
- Contoh: "John & Jane" → "john-jane"
- Bisa custom saat create atau edit

### Status Management:
- **Draft**: Private, hanya admin bisa akses via edit page
- **Active**: Public, bisa diakses siapa saja via wedding URL
- **Archived**: Hidden dari public, tapi data tetap tersimpan

### View Counter:
- Otomatis increment saat ada yang buka wedding URL
- Tampil di dashboard untuk analytics
- Reset manual via database jika perlu

### Password Protection: (Coming Soon)
- Fitur untuk protect wedding dengan password
- Useful untuk private/intimate weddings

---

## ❓ **FAQ**

### Q: Bagaimana cara switch template untuk project yang sudah ada?
A: Saat ini belum ada UI untuk switch template. Coming in next update! Untuk sekarang, harus create new project dengan template baru dan copy data manually.

### Q: Apakah data lama (Hanson & Catherine) masih aman?
A: Ya! Data existing otomatis di-migrate dengan:
- Slug: `hanson-catherineeeererer`
- Template: `timeless`
- Status: `active`

Bisa diakses via:
- `/wedding/hanson-catherineeeererer`
- `/timeless/` (backward compatibility)

### Q: Limit berapa banyak projects?
A: Unlimited! Database Supabase bisa handle ribuan projects.

### Q: Bagaimana cara backup data?
A: Export via Supabase Dashboard → SQL Editor:
```sql
SELECT * FROM timeless_content;
```
Copy hasil query ke file JSON atau CSV.

### Q: Bisa tambah template sendiri?
A: Ya! Tutorial coming soon. Intinya:
1. Duplicate folder `timeless/` dengan nama template baru
2. Update HTML & CSS sesuai design
3. Pastikan JavaScript load data dari API dengan slug parameter
4. Add template option di `create.html`

### Q: Image upload limit?
A: Bergantung server. Default max 10MB per image. Bisa diubah di server config.

---

## 🐛 **Troubleshooting**

### Problem: Dashboard tidak load projects
**Solution:**
- Check browser console (F12) untuk error
- Pastikan Supabase credentials correct di dashboard.html
- Pastikan database migration sudah dijalankan

### Problem: Create project gagal
**Solution:**
- Check semua required fields sudah diisi
- Pastikan slug unique (tidak bentrok dengan project lain)
- Check browser console untuk detail error

### Problem: Preview menampilkan data lama
**Solution:**
- Clear browser cache (Ctrl+Shift+Del)
- Hard refresh (Ctrl+F5)
- Check apakah changes sudah di-save

### Problem: Upload image error
**Solution:**
- Check file size tidak lebih dari 10MB
- Pastikan format image valid (jpg, jpeg, png)
- Check browser console untuk detail error

---

## 🔮 **Roadmap**

Features yang akan datang:

- [ ] **Template Switcher** di edit page
- [ ] **Bulk Operations** (archive/delete multiple projects)
- [ ] **Elegant Template Integration** (full support)
- [ ] **Classic Template** (new design)
- [ ] **Password Protection** per project
- [ ] **Custom Domain** support
- [ ] **Email Notification** saat ada RSVP
- [ ] **Analytics Dashboard** (detailed views, sources, etc.)
- [ ] **Export to PDF** feature
- [ ] **Theme Customization** (colors, fonts) per project
- [ ] **Multi-language Support**
- [ ] **Mobile App** (React Native)

---

## 💡 **Tips & Best Practices**

1. **Naming Convention:**
   - Use clear couple names: "John & Jane", not "JJ"
   - Slug akan lebih SEO-friendly

2. **Image Optimization:**
   - Compress images before upload (use tinypng.com)
   - Recommended size: < 500KB per image
   - Hero images: 1920x1080px
   - Gallery: 1200x800px

3. **Testing:**
   - Always preview before setting to Active
   - Test di multiple devices (mobile, tablet, desktop)
   - Check semua links & maps working

4. **Data Entry:**
   - Use consistent date format
   - Double-check venue address & maps link
   - Proofread all text content

5. **Organization:**
   - Use Draft status while working
   - Archive old projects to keep dashboard clean
   - Use search & filters untuk find projects quickly

---

## 📞 **Support**

Kalau ada pertanyaan atau butuh bantuan:
1. Check dokumentasi ini dulu
2. Check `README.md` untuk setup info
3. Check `SUPABASE_SETUP.md` untuk database issues

---

**Happy Wedding Planning! 💍🎊**
