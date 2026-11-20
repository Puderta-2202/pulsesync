# Dokumentasi Keputusan Teknis — PulseSync

## 1. Manajemen State

PulseSync menggunakan **Riverpod** sebagai solusi manajemen state. Riverpod dipilih karena memisahkan pengelolaan state dari komponen UI, memudahkan pengelolaan dependensi, serta mendukung pengembangan dan pengujian aplikasi.

`StreamProvider` digunakan untuk menyediakan data telemetry secara real-time, sedangkan provider lainnya mengelola status jaringan, pelaporan anomali, dan pemantauan antrean sinkronisasi.

## 2. Library dan Dependency

PulseSync menggunakan beberapa library dan dependency utama berikut:

| Library / Dependency | Versi | Kegunaan |
|---|---:|---|
| Flutter SDK | ≥ 3.38.4 | Framework utama untuk membangun aplikasi |
| `flutter_riverpod` | 3.3.2 | Manajemen state dan dependency injection |
| `sqflite` | 2.4.2+1 | Penyimpanan data lokal menggunakan SQLite |
| `path` | 1.9.1 | Pengelolaan lokasi dan path database |
| `uuid` | 4.6.0 | Pembuatan identifier unik |
| `hive` | 2.2.3 | Penyimpanan data lokal berbasis NoSQL |
| `hive_flutter` | 1.1.0 | Integrasi Hive dengan Flutter |
| `cupertino_icons` | 1.0.9 | Penyedia ikon bergaya Cupertino |
| `flutter_lints` | 6.0.0 | Aturan analisis dan kualitas kode (dev dependency) |

**Versi SDK:**
- Dart SDK: `>=3.10.4 <4.0.0`
- Flutter SDK: `>=3.38.4`

## 3. Pengelolaan Lifecycle Stream

Stream telemetry menghasilkan pembacaan sinyal optik setiap 800 milidetik menggunakan asynchronous generator.

Untuk mencegah memory leak, aplikasi menggunakan `StreamProvider.autoDispose` yang mengelola lifecycle subscription. Aktivasi stream juga dikontrol berdasarkan tab navigasi yang sedang dipilih.

Ketika pengguna berpindah dari Dashboard ke History, stream telemetry tidak lagi dikonsumsi. Ketika pengguna kembali ke Dashboard, subscription baru akan diaktifkan. Mekanisme ini mencegah konsumsi resource yang tidak diperlukan.

## 4. Penyimpanan Offline dan Mekanisme Retry

PulseSync menggunakan **SQLite melalui sqflite** untuk menyimpan laporan anomali secara lokal sebelum proses sinkronisasi. Dengan demikian, data tetap tersedia meskipun aplikasi ditutup atau perangkat mengalami gangguan jaringan.

Setiap laporan memiliki status sinkronisasi dan jumlah percobaan ulang. Layanan sinkronisasi memproses antrean berdasarkan prinsip FIFO (*First In, First Out*).

Simulator jaringan menyediakan tiga kondisi: Online, Unstable, dan Offline. Permintaan yang gagal akan dicoba kembali menggunakan mekanisme *exponential backoff*, dengan jeda 1 dan 2 detik antarpercobaan serta maksimal tiga percobaan. Laporan yang melampaui batas percobaan akan diberi status Failed.

Antrean pending diproses secara otomatis ketika jaringan berubah dari Offline menjadi Online.

## 5. Penggunaan AI

AI digunakan sebagai alat bantu selama pengembangan, khususnya untuk memperoleh panduan teknis, meninjau kode, membantu proses debugging, dan memberikan saran implementasi.

Setiap saran yang dihasilkan ditinjau, disesuaikan dengan arsitektur proyek, dan diuji oleh pengembang. AI digunakan sebagai pendukung proses pengembangan, bukan sebagai pengganti pemahaman dan validasi kode.