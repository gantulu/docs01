# Source References — Duitku POP

Dokumen ini mencatat sumber resmi yang digunakan untuk menyusun dan memelihara `duitku-pop.md` di repository ini.

- **Penyedia dokumentasi:** Duitku
- **Produk:** Duitku POP
- **Bahasa:** Indonesia
- **Sumber utama:** https://docs.duitku.com/pop/id/
- **Tanggal pemeriksaan sumber:** 27 Oktober 2026
- **Jenis sumber:** Dokumentasi teknis resmi pihak penyedia
- **Dokumen terkait:** [duitku-pop.md](./duitku-pop.md)

## 1. Sumber Utama

| Sumber | URL | Cakupan |
| --- | --- | --- |
| Dokumentasi Duitku POP | https://docs.duitku.com/pop/id/ | Halaman referensi utama, navigasi, seluruh bagian dokumentasi, dan changelog. |

## 2. Referensi Bagian yang Diminta

Daftar berikut mempertahankan URL bagian (anchor) yang diberikan untuk memudahkan penelusuran ke sumber aslinya.

### Pengantar dan persiapan

| Bagian | URL | Penggunaan |
| --- | --- | --- |
| Pendahuluan | https://docs.duitku.com/pop/id/#pendahuluan | Gambaran umum Duitku POP. |
| Pratinjau | https://docs.duitku.com/pop/id/#pratinjau | Alur pembayaran tingkat tinggi. |
| Langkah Integrasi | https://docs.duitku.com/pop/id/#langkah-integrasi | Persiapan dan kredensial merchant. |
| Flowchart | https://docs.duitku.com/pop/id/#flowchart | Diagram alur invoice, payment page, pembayaran, dan callback. |
| Browser yang Kompatibel | https://docs.duitku.com/pop/id/#browser-yang-kompatibel | Kompatibilitas browser yang dicantumkan provider. |
| Library | https://docs.duitku.com/pop/id/#library | Library integrasi yang tersedia. |

### Integrasi backend/server

| Bagian | URL | Penggunaan |
| --- | --- | --- |
| Integrasi Backend atau Server | https://docs.duitku.com/pop/id/#integrasi-backend-atau-server | Ikhtisar pemanggilan API backend. |
| Create Invoice | https://docs.duitku.com/pop/id/#create-invoice | Endpoint, header, signature, parameter request, respons, dan aturan order ID. |
| Obyek JSON | https://docs.duitku.com/pop/id/#obyek-json | Skema `itemDetails`, `customerDetail`, `Address`, dan `creditCardDetail`. |
| Callback | https://docs.duitku.com/pop/id/#callback | Format callback, parameter, signature, persyaratan endpoint, dan retry callback. |

### Integrasi frontend/view

| Bagian | URL | Penggunaan |
| --- | --- | --- |
| Integrasi Frontend atau View | https://docs.duitku.com/pop/id/#integrasi-frontend-atau-view | Ikhtisar tampilan halaman pembayaran. |
| Tinjauan Umum | https://docs.duitku.com/pop/id/#tinjauan-umum | Pemuatan library frontend dan penggunaan reference. |
| Duitku JS | https://docs.duitku.com/pop/id/#duitku-js | Pemanggilan `checkout.process` dan opsi event. |
| JS Callback | https://docs.duitku.com/pop/id/#js-callback | Format respons callback JavaScript dan batas penggunaannya. |
| Window Redirection | https://docs.duitku.com/pop/id/#window-redirection | Redirect pelanggan ke `paymentUrl`. |
| Redirect | https://docs.duitku.com/pop/id/#redirect | Parameter return URL dan peringatan agar tidak menjadikan parameter redirect sebagai sumber status final. |

### Metode pembayaran dan error

| Bagian | URL | Penggunaan |
| --- | --- | --- |
| Payment Method | https://docs.duitku.com/pop/id/#payment-method | Kode kanal pembayaran dan persyaratan parameter per kanal. |
| Errors | https://docs.duitku.com/pop/id/#errors | Indeks referensi error. |
| Respon HTTP | https://docs.duitku.com/pop/id/#respon-http | Kode HTTP dan pesan error API. |
| Respon API | https://docs.duitku.com/pop/id/#respon-api | Kode hasil callback dan redirect menurut dokumentasi. |

## 3. Aturan Penggunaan Sumber

1. **Dokumentasi resmi Duitku adalah source of truth** untuk kontrak provider, endpoint, parameter, signature, kode respons, callback, dan metode pembayaran.
2. `duitku-pop.md` adalah rangkuman kerja untuk memudahkan pembacaan, bukan pengganti dokumentasi asli dan bukan salinan lengkapnya.
3. Jangan mengasumsikan bahwa contoh request, nilai contoh, kode kanal, daftar IP, batas parameter, atau kredensial uji selalu mutakhir. Periksa sumber resmi sebelum digunakan.
4. Bedakan respons callback server-to-server dari callback JavaScript dan redirect browser. Dokumentasi Duitku memperingatkan bahwa parameter redirect dapat diubah pelanggan; jangan menggunakannya sendiri untuk menetapkan status pembayaran.
5. Jika ada kontradiksi, istilah yang ambigu, atau status yang belum pasti, catat sebagai blocker dan minta konfirmasi resmi Duitku sebelum menetapkan kontrak implementasi.
6. Jangan menyimpan Merchant Key/API Key asli di dokumen sumber, kode frontend, commit, atau log.
7. Untuk perubahan kontrak, catat tanggal pemeriksaan, bagian yang berubah, dampak implementasi, dan tautan sumber terkait.

## 4. Pemeriksaan yang Disarankan Sebelum Implementasi

- [ ] Pastikan endpoint Sandbox dan Production sesuai dokumentasi saat ini.
- [ ] Verifikasi formula signature Create Invoice dan callback secara terpisah.
- [ ] Verifikasi parameter wajib, tipe data, batas panjang, serta relasi nominal `paymentAmount` dan `itemDetails`.
- [ ] Verifikasi kode hasil callback dan redirect secara terpisah; jangan menyamakan keduanya tanpa dasar resmi.
- [ ] Verifikasi aturan callback, format content type, respons HTTP 200, dan kebijakan pengiriman ulang.
- [ ] Verifikasi ketersediaan payment method untuk merchant dan lingkungan yang digunakan.
- [ ] Jalankan pengujian Sandbox sebelum mengaktifkan Production.

## 5. Catatan Pemeliharaan

Halaman resmi dapat berubah tanpa perubahan pada file lokal ini. Karena itu, tautan di atas harus dibuka kembali saat melakukan audit atau memperbarui `duitku-pop.md`. Tanggal pemeriksaan menunjukkan kapan sumber ditinjau untuk pekerjaan ini, bukan jaminan bahwa setiap bagian akan tetap sama setelah tanggal tersebut.

## 6. Referensi

- [Duitku POP — Dokumentasi resmi Bahasa Indonesia](https://docs.duitku.com/pop/id/)
- [Dokumentasi ringkasan repository](./duitku-pop.md)
