# PulseSync

**Aplikasi Monitoring Telemetri Optik Real-Time dan Pelaporan Anomali Offline**

PulseSync adalah aplikasi mobile berbasis Flutter yang dikembangkan untuk menyimulasikan pemantauan sinyal optik dan pelaporan anomali pada ODP (*Optical Distribution Point*).

Aplikasi ini menyediakan pembaruan data telemetri secara real-time, pencatatan laporan anomali, serta mekanisme antrean offline yang dilengkapi dengan sinkronisasi otomatis dan sistem percobaan ulang (*retry*).

## Fitur Utama

### 1. Monitoring Telemetri Optik Real-Time
- Simulasi pembacaan nilai sinyal optik setiap 800 milidetik.
- Rentang nilai sinyal dari -10.0 hingga -35.0 dBm.
- Klasifikasi status sinyal secara otomatis:
  - **NORMAL:** -10.0 hingga -22.0 dBm.
  - **WARNING:** -22.1 hingga -27.0 dBm.
  - **CRITICAL:** Di bawah -27.0 dBm.
- Pengelolaan siklus hidup Stream untuk mencegah kebocoran sumber daya (*resource leak*).

### 2. Pelaporan Anomali ODP
- Formulir pelaporan anomali melalui modal bottom sheet.
- Pengambilan snapshot nilai sinyal optik saat laporan dibuat.
- Validasi kode ODP dengan panjang minimal 4 karakter.
- Pilihan kategori anomali:
  - Macro-bending
  - Dirty connector
  - Broken core
  - High attenuation
- Kolom catatan teknisi.

### 3. Antrean Offline dan Simulasi Jaringan
- Simulasi tiga kondisi jaringan:
  - Online
  - Unstable
  - Offline
- Penyimpanan data lokal secara persisten menggunakan SQLite.
- Mekanisme percobaan ulang dengan strategi *exponential backoff*.
- Maksimal tiga percobaan sinkronisasi.
- Laporan yang gagal disinkronkan akan diberi status Failed.
- Sinkronisasi antrean secara otomatis ketika jaringan kembali Online.
- Pemrosesan antrean berdasarkan urutan FIFO (*First In, First Out*).

### 4. Riwayat Laporan Anomali
- Halaman riwayat laporan yang terpisah dari dashboard.
- Pengelompokan laporan berdasarkan status:
  - Pending
  - Failed
  - Synced

## Teknologi yang Digunakan

| Teknologi | Kegunaan |
|---|---|
| Flutter | Framework pengembangan aplikasi mobile |
| Dart | Bahasa pemrograman |
| Riverpod | Manajemen state aplikasi |
| SQLite (sqflite) | Penyimpanan data lokal |
| UUID | Pembuatan identitas unik |
| Material Design | Desain antarmuka aplikasi |

## Persyaratan Sistem

Sebelum menjalankan aplikasi, pastikan perangkat pengembangan telah memiliki:

- Flutter SDK
- Dart SDK
- Android Studio atau Visual Studio Code
- Android SDK

## Instalasi dan Menjalankan Aplikasi

**1. Clone repository**

```bash
git clone
```

**2. Masuk ke direktori project**

```bash
cd pulsesync
```

**3. Instal seluruh dependency**

```bash
flutter pub get
```

**4. Jalankan aplikasi**

```bash
flutter run
```

## Build APK Release

Untuk menghasilkan APK versi release, jalankan perintah:

```bash
flutter build apk --release
```

File APK yang dihasilkan dapat ditemukan pada direktori:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Dokumentasi Teknis

Dokumen [DECISION.md](DECISION.md) berisi penjelasan mengenai keputusan arsitektur, manajemen state, pengelolaan siklus hidup Stream, strategi penyimpanan dan sinkronisasi antrean offline, serta penggunaan AI selama proses pengembangan.

## Tujuan Pengembangan

PulseSync dikembangkan sebagai bagian dari technical test untuk posisi Mobile Developer.

Proyek ini bertujuan mendemonstrasikan implementasi real-time data streaming, manajemen state, penyimpanan data lokal, simulasi jaringan, mekanisme retry, serta penerapan arsitektur aplikasi Flutter yang modular.