# Source — Dokumentasi Duitku POP

Dokumen ini mengelompokkan referensi resmi Duitku POP sesuai bagian dokumentasi yang digunakan untuk menyusun dan memelihara [`duitku-pop.md`](./duitku-pop.md).

- **Penyedia:** Duitku
- **Produk:** Duitku POP
- **Bahasa:** Indonesia
- **Source of truth:** https://docs.duitku.com/pop/id/
- **Tanggal pemeriksaan:** 27 Oktober 2026

## 1. Pendahuluan

Referensi untuk pengenalan produk, gambaran alur, persiapan integrasi, kompatibilitas browser, dan library.

| Bagian | URL |
| --- | --- |
| Pendahuluan | https://docs.duitku.com/pop/id/#pendahuluan |
| Pratinjau | https://docs.duitku.com/pop/id/#pratinjau |
| Langkah Integrasi | https://docs.duitku.com/pop/id/#langkah-integrasi |
| Flowchart | https://docs.duitku.com/pop/id/#flowchart |
| Browser yang Kompatibel | https://docs.duitku.com/pop/id/#browser-yang-kompatibel |
| Library | https://docs.duitku.com/pop/id/#library |

## 2. Integrasi Backend atau Server

Referensi untuk API server, pembuatan invoice, struktur objek JSON, dan callback server-to-server.

| Bagian | URL |
| --- | --- |
| Integrasi Backend atau Server | https://docs.duitku.com/pop/id/#integrasi-backend-atau-server |
| Create Invoice | https://docs.duitku.com/pop/id/#create-invoice |
| Obyek JSON | https://docs.duitku.com/pop/id/#obyek-json |
| Callback | https://docs.duitku.com/pop/id/#callback |

## 3. Integrasi Frontend atau View

Referensi untuk pemuatan library frontend, integrasi Duitku JS, callback JavaScript, dan pengalihan browser.

| Bagian | URL |
| --- | --- |
| Integrasi Frontend atau View | https://docs.duitku.com/pop/id/#integrasi-frontend-atau-view |
| Tinjauan Umum | https://docs.duitku.com/pop/id/#tinjauan-umum |
| Duitku JS | https://docs.duitku.com/pop/id/#duitku-js |
| JS Callback | https://docs.duitku.com/pop/id/#js-callback |
| Window Redirection | https://docs.duitku.com/pop/id/#window-redirection |
| Redirect | https://docs.duitku.com/pop/id/#redirect |

## 4. Payment Method

Referensi metode pembayaran dan kode kanal yang didukung menurut dokumentasi Duitku.

| Bagian | URL |
| --- | --- |
| Payment Method | https://docs.duitku.com/pop/id/#payment-method |

## 5. Errors

Referensi untuk memahami respons HTTP dan kode respons API Duitku.

| Bagian | URL |
| --- | --- |
| Errors | https://docs.duitku.com/pop/id/#errors |
| Respon HTTP | https://docs.duitku.com/pop/id/#respon-http |
| Respon API | https://docs.duitku.com/pop/id/#respon-api |

## Aturan Penggunaan Sumber

1. Dokumentasi resmi Duitku adalah **source of truth** untuk endpoint, parameter, signature, callback, metode pembayaran, dan kode respons.
2. Gunakan bagian yang relevan di atas untuk menelusuri informasi ke sumber asli. Ringkasan repository tidak menggantikan dokumentasi resmi.
3. Jangan mengasumsikan contoh, batas parameter, kode kanal, daftar IP, atau kredensial uji selalu mutakhir. Verifikasi kembali sebelum implementasi.
4. Bedakan callback server-to-server, callback JavaScript, dan redirect browser. Jangan menetapkan status pembayaran final hanya dari parameter redirect.
5. Jika dokumentasi bertentangan atau arti suatu kode belum pasti, catat sebagai blocker dan minta konfirmasi resmi Duitku sebelum mengunci kontrak implementasi.
6. Jangan menyimpan API Key atau Merchant Key asli di file dokumentasi, frontend, commit, atau log.

## Dokumen Terkait

- [Dokumentasi teknis ringkasan Duitku POP](./duitku-pop.md)
- [Dokumentasi resmi Duitku POP](https://docs.duitku.com/pop/id/)
