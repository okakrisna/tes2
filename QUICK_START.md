# 🚀 Quick Start - Multi-Template Wedding System

## ⚠️ PENTING: URL Access

Karena kita menggunakan simple static server (`npx serve`), ada beberapa hal yang perlu diperhatikan:

### ✅ **URL yang BEKERJA:**

#### 1. Admin Panel
```
http://localhost:5173/admin/dashboard.html
```
☝️ Ini adalah dashboard utama untuk manage semua wedding projects

#### 2. Preview Wedding (Timeless Template)
```
http://localhost:5173/timeless/
```
☝️ Ini akan load project timeless pertama yang active

#### 3. Preview Wedding dengan Slug Spesifik
```
http://localhost:5173/timeless/?slug=hanson-catherineeeererer
```
☝️ Load project spesifik by slug

#### 4. Wedding Router (dengan query parameter)
```
http://localhost:5173/wedding.html?slug=hanson-catherineeeererer
```
☝️ Akan auto-redirect ke template yang sesuai

---

### ❌ **URL yang TIDAK BEKERJA (404):**

```
http://localhost:5173/admin/           ❌ (akan redirect ke dashboard.html)
http://localhost:5173/wedding/slug     ❌ (butuh server routing)
```

**Mengapa?**
- `npx serve` adalah simple static file server
- Tidak support dynamic routing seperti `/wedding/{slug}`
- Hanya bisa serve file yang benar-benar ada

**Solusi Production:**
- Gunakan server yang support URL rewriting (Nginx, Apache, Vercel, Netlify)
- Atau gunakan hash routing (`#/wedding/slug`)

---

## 📋 **Step-by-Step Usage:**

### 1️⃣ Start Server
```bash
npm run dev
# Server running di http://localhost:5173
```

### 2️⃣ Akses Admin Dashboard
Buka browser:
```
http://localhost:5173/admin/dashboard.html
```

Anda akan lihat:
- 📊 Stats (total projects, active, views, drafts)
- 🔍 Search bar
- 📋 List semua wedding projects
- ➕ Button "Create New Wedding"

### 3️⃣ Create Wedding Project Baru

**Klik "➕ Create New Wedding"**, lalu:

1. **Choose Template**
   - Klik card "Timeless" atau "Elegant"
   - Klik "Next: Basic Info →"

2. **Fill Basic Information**
   ```
   Couple Names: John & Jane
   Groom Name: John Smith
   Bride Name: Jane Doe
   Wedding Date: SATURDAY, 25 DECEMBER 2025
   Status: Draft (untuk testing) atau Active (untuk publish)
   ```
   - Slug akan auto-generate: `john-jane`
   - Klik "Next: Review →"

3. **Review & Create**
   - Check semua data
   - Klik "✨ Create Project"
   - Akan auto-redirect ke edit page

### 4️⃣ Edit Project Content

Di edit page, isi:
- ✍️ Detail info (venue, time, dll)
- 🖼️ Upload images (background, photos, gallery)
- 💌 Thank you message
- Klik "💾 Simpan Semua Perubahan"

### 5️⃣ Preview Wedding

**Cara 1: Dari Dashboard**
- Klik button "👁️ Preview" di project card
- Akan buka tab baru dengan URL: `http://localhost:5173/timeless/?slug=john-jane`

**Cara 2: Direct URL**
```
http://localhost:5173/timeless/?slug=john-jane
```

**Cara 3: Wedding Router**
```
http://localhost:5173/wedding.html?slug=john-jane
```

### 6️⃣ Publish & Share

**Set status ke "Active":**
- Di dashboard, edit project
- Atau saat create, pilih "Active"

**Share URL ke Client:**
```
http://localhost:5173/timeless/?slug=john-jane
```

Atau jika production (dengan proper server):
```
https://yourdomain.com/wedding/john-jane
```

---

## 🎨 **Testing Different Templates**

### Timeless Template:
```
http://localhost:5173/timeless/?slug=hanson-catherineeeererer
```

### Elegant Template (coming soon):
```
http://localhost:5173/elegant/?slug=your-slug
```

---

## 🐛 **Troubleshooting**

### Problem: "404 Not Found" saat akses /admin/
**Solution:**
Gunakan URL lengkap:
```
http://localhost:5173/admin/dashboard.html
```

### Problem: Dashboard tidak load projects
**Solution:**
1. Check browser console (F12)
2. Pastikan ada network request ke Supabase
3. Check error message
4. Pastikan database migration sudah dijalankan

### Problem: Preview button tidak work di edit page
**Solution:**
Untuk sekarang, copy slug dari project, lalu manual buka:
```
http://localhost:5173/timeless/?slug=YOUR-SLUG-HERE
```

### Problem: Create project error
**Solution:**
1. Check semua required fields terisi
2. Check browser console untuk detail error
3. Pastikan slug unique (tidak bentrok)

---

## 📊 **Check Database**

Untuk verify data di database, bisa query langsung via Supabase Dashboard:

```sql
-- List semua projects
SELECT slug, couple_names, template_name, status, views_count
FROM timeless_content
ORDER BY created_at DESC;

-- Count projects
SELECT
  COUNT(*) as total,
  COUNT(CASE WHEN status='active' THEN 1 END) as active,
  COUNT(CASE WHEN status='draft' THEN 1 END) as drafts
FROM timeless_content;
```

---

## 🎯 **Summary - URL Cheat Sheet**

| Purpose | URL | Status |
|---------|-----|--------|
| Admin Dashboard | `/admin/dashboard.html` | ✅ Work |
| Create Project | `/admin/create.html` | ✅ Work |
| Edit Project | `/admin/edit.html?id={uuid}` | ⚠️ Need fix |
| Preview Wedding | `/timeless/?slug={slug}` | ✅ Work |
| Wedding Router | `/wedding.html?slug={slug}` | ✅ Work |
| Root Admin | `/admin/` | ✅ Redirect to dashboard |
| Dynamic Route | `/wedding/{slug}` | ❌ Need server config |

---

## 🚀 **Production Deployment**

Untuk production dengan proper routing:

### Option 1: Vercel
```json
// vercel.json
{
  "rewrites": [
    { "source": "/wedding/:slug", "destination": "/wedding.html?slug=:slug" },
    { "source": "/admin", "destination": "/admin/dashboard.html" }
  ]
}
```

### Option 2: Netlify
```toml
# netlify.toml
[[redirects]]
  from = "/wedding/:slug"
  to = "/wedding.html?slug=:slug"
  status = 200

[[redirects]]
  from = "/admin"
  to = "/admin/dashboard.html"
  status = 200
```

### Option 3: Nginx
```nginx
location /wedding/ {
    rewrite ^/wedding/(.*)$ /wedding.html?slug=$1 last;
}

location = /admin {
    rewrite ^ /admin/dashboard.html last;
}
```

---

## ✅ **Quick Test Checklist**

- [ ] Server running di port 5173
- [ ] Dashboard load di `/admin/dashboard.html`
- [ ] Bisa create new project
- [ ] Project muncul di dashboard list
- [ ] Bisa search & filter projects
- [ ] Preview wedding work di `/timeless/?slug=...`
- [ ] Images upload & display correctly
- [ ] Data tersimpan di database
- [ ] Stats cards update correctly

---

**Happy Wedding Planning! 💍**

Need help? Check `MULTI_TEMPLATE_GUIDE.md` untuk detailed guide.
