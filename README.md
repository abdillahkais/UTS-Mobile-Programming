# Urakan

Aplikasi mobile **Top Up Game** dan **Open Mabar** (mencari teman bermain) yang dibangun dengan Flutter dan Dart. Proyek ini dibuat untuk Praktikum Mobile Programming.

---

## 1. Tema dan Tujuan

**Tema.** Antarmuka bergaya *gaming* dalam mode gelap dengan aksen warna neon: cyan sebagai warna utama, ungu sebagai warna kedua, dan hijau sebagai warna ketiga. Tipografi memakai tiga keluarga huruf: Space Grotesk (judul), Plus Jakarta Sans (isi), dan JetBrains Mono (angka dan label).

**Tujuan.** Menyatukan dua kebutuhan pemain game yang biasanya dilayani aplikasi terpisah dalam satu aplikasi:

1. **Top up** mata uang virtual game (diamond, VP, UC) dengan alur yang jelas dan validasi data.
2. **Mabar**: pemain mendaftar lalu langsung diarahkan ke komunitas Discord sesuai game pilihannya.

Game yang tersedia: **Mobile Legends**, **Valorant**, **Free Fire**, dan **PUBG Mobile**.

> **Catatan:** Aplikasi ini masih berupa prototipe. Data nominal, harga, dan tautan Discord adalah data contoh, dan pembayaran hanya simulasi (lihat bagian [Keterbatasan](#7-keterbatasan)).

---

## 2. Daftar Halaman dan Fungsinya

| Halaman | File | Fungsi |
|---|---|---|
| **Beranda** | `lib/screens/home_screen.dart` | Halaman awal. Menampilkan banner promosi, dua kartu fitur (Top Up Game dan Open Mabar), serta grid Game Populer yang bisa diketuk untuk langsung ke formulir top up. |
| **Pemilihan Game** | `lib/screens/topup_selection_screen.dart` | Menampilkan empat game dalam daftar dan menyediakan kolom pencarian yang menyaring game secara langsung. |
| **Formulir Top Up** | `lib/screens/topup_form_screen.dart` | Formulir pesanan: Game ID (dan Zone ID khusus Mobile Legends), nama akun, email, nomor HP, pilihan nominal, dan metode pembayaran. Total tagihan dihitung otomatis. Tombol **Konfirmasi Pembayaran** memvalidasi data, menampilkan ringkasan pesanan, lalu nomor invoice. |
| **Open Mabar** | `lib/screens/open_mabar_screen.dart` | Formulir pendaftaran mabar: nickname dan pilihan game. Tombol **Konfirmasi** membuka tautan Discord milik game yang dipilih. |

**Alur navigasi** (memakai `Navigator.push`):

```
Beranda ─► Pemilihan Game ─► Formulir Top Up ─► Ringkasan ─► Pesanan Dibuat ─► Beranda
   │                              ▲
   ├─ Grid "Game Populer" ────────┘
   └─► Open Mabar ─► Discord (aplikasi atau peramban)
```

---

## 3. Struktur Proyek

```
lib/
├── main.dart                        Titik masuk aplikasi
├── theme/app_theme.dart             Warna, tipografi, dan tema global
├── models/game.dart                 Model data dan data dummy (kelas Catalog)
├── widgets/common.dart              Komponen bersama (kartu, tombol, chip, ikon)
└── screens/
    ├── home_screen.dart
    ├── topup_selection_screen.dart
    ├── topup_form_screen.dart
    └── open_mabar_screen.dart
```

`pubspec.yaml` harus berada di **folder utama proyek** (sejajar dengan `lib/` dan `android/`), bukan di dalam `lib/`.

---

## 4. Teknologi

| Komponen | Keterangan |
|---|---|
| Framework | Flutter (Material Design) |
| Bahasa | Dart (SDK `>=3.3.0 <4.0.0`) |
| `url_launcher` `^6.3.0` | Membuka tautan Discord |
| `google_fonts` `^6.2.1` | Memuat font Space Grotesk, Plus Jakarta Sans, dan JetBrains Mono |
| Platform uji | Android (emulator Pixel 6) |

---

## 5. Langkah Menjalankan Aplikasi

### 5.1 Prasyarat

- Flutter SDK sudah terpasang. Cek dengan `flutter doctor` dan pastikan bagian *Android toolchain* bertanda centang.
- Android Studio dengan plugin **Flutter** dan **Dart**.
- Emulator Android atau HP Android dengan USB debugging aktif.
- Koneksi internet. Font diunduh saat aplikasi pertama kali dijalankan.

### 5.2 Siapkan proyek

**Cara A. Dari proyek Flutter baru (untuk yang menerima file kode secara terpisah)**

1. Buat proyek baru: `flutter create urakan` (atau **New Flutter Project** di Android Studio).
2. Hapus isi `lib/` bawaan, lalu salin folder `lib/` dari proyek ini ke dalamnya.
3. Timpa `pubspec.yaml` di folder utama dengan `pubspec.yaml` dari proyek ini.

**Cara B. Dari folder proyek ini langsung**

Jika `android/` belum ada, buat dengan menjalankan `flutter create .` di folder proyek, lalu lanjut ke langkah berikut.

### 5.3 Pasang dependensi

Jalankan di folder utama proyek:

```bash
flutter pub get
```

Jika paket belum terdaftar, tambahkan dengan:

```bash
flutter pub add url_launcher google_fonts
```

### 5.4 Konfigurasi Android (wajib untuk fitur Discord)

Buka `android/app/src/main/AndroidManifest.xml`, lalu tambahkan dua blok ini di dalam tag `<manifest>`, di atas `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW"/>
    <data android:scheme="https"/>
  </intent>
</queries>
```

Tanpa konfigurasi ini, tombol **Konfirmasi** pada Open Mabar tidak dapat membuka Discord, terutama di Android 11 ke atas.

### 5.5 Ganti tautan Discord

Buka `lib/models/game.dart`. Setiap game punya properti `discordUrl` berisi tautan contoh:

```dart
discordUrl: 'https://discord.gg/REPLACE_MLBB',
```

Ganti keempatnya (`REPLACE_MLBB`, `REPLACE_VALORANT`, `REPLACE_FREEFIRE`, `REPLACE_PUBGM`) dengan tautan undangan komunitas yang sebenarnya.

### 5.6 Jalankan

1. Pilih perangkat di dropdown bagian atas Android Studio.
2. Klik **Run** (ikon segitiga hijau) atau tekan `Shift + F10`.

Atau lewat terminal:

```bash
flutter run
```

Build pertama berjalan lebih lama karena Gradle mengunduh dependensi Android.

---

## 6. Pemecahan Masalah

| Gejala | Penyebab dan solusi |
|---|---|
| `Couldn't resolve the package 'google_fonts'` atau `'url_launcher'` | Paket belum terdaftar di `pubspec.yaml` yang berada di folder utama proyek. Jalankan `flutter pub add url_launcher google_fonts`, lalu Run ulang (bukan *hot reload*). |
| `pubspec.yaml` ada di dalam `lib/` | Letaknya salah. Pindahkan ke folder utama proyek, hapus salinan di dalam `lib/`. |
| `BoxConstraints forces an infinite height` | Terjadi bila `Row` berisi `crossAxisAlignment.stretch` berada di dalam `ListView` tanpa pembungkus. Versi kode ini sudah memakai `IntrinsicHeight` di `home_screen.dart`. |
| Layar emulator hitam padahal log tanpa galat | Coba matikan renderer Impeller: `flutter run --no-enable-impeller`. Cara lain: ubah *Graphics* emulator ke **Hardware** atau **Software**, atau gunakan emulator dengan API yang lebih umum (mis. API 34) atau HP asli. |
| Teks tampil dengan font yang berbeda | Font diunduh dari internet saat pertama dijalankan. Pastikan emulator atau HP terhubung internet. |
| Tombol Konfirmasi di Open Mabar tidak membuka Discord | Periksa konfigurasi `AndroidManifest.xml` (bagian 5.4) dan pastikan `discordUrl` sudah diganti dengan tautan yang valid. |

---

## 7. Keterbatasan

- Pembayaran hanya **simulasi**, belum terhubung ke *payment gateway* maupun server penyedia game.
- Nominal, harga, dan biaya admin adalah **data contoh** pada kelas `Catalog`.
- Validasi hanya memeriksa **format** isian. Keberadaan akun game di server belum diverifikasi.
- Belum ada autentikasi pengguna dan basis data.
- Belum diimplementasikan dari rancangan awal: bilah navigasi bawah, penghitung waktu promosi, status level dan saldo, Live Mabar Feed, pilihan *role* dan tipe *mabar*, serta halaman "Open Mabar Berhasil".
- Pengujian baru dilakukan pada emulator Android.

---

## 8. Identitas

| | |
|---|---|
| Nama | Muhammad Abdillah Kais Al Akmal |
| NIM | 240605110180 |
| Kelas | Mobile Programming Practicum K |
| Dosen Pengampu | Amila Fadhila Rahmaniati, S.Kom., M.Kom. |
| Instansi | Jurusan Teknik Informatika, Fakultas Sains dan Teknologi, UIN Maulana Malik Ibrahim Malang |
