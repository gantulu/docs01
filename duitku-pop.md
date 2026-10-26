# Dokumentasi Duitku POP

> Ringkasan integrasi Duitku POP berdasarkan dokumentasi resmi Duitku: <https://docs.duitku.com/pop/id/>.
>
> **Source of truth:** dokumentasi resmi di URL tersebut. Dokumentasi ini merupakan panduan ringkas, bukan pengganti referensi resmi. Jika kontrak API berubah atau ada perbedaan, verifikasi langsung ke dokumentasi resmi dan konfirmasi ke Duitku sebelum mengubah implementasi pembayaran.
>
> **Terakhir diperiksa:** 27 Oktober 2026.

## Daftar Isi

- [Gambaran Umum](#gambaran-umum)
- [Lingkungan dan Kredensial](#lingkungan-dan-kredensial)
- [Alur Integrasi](#alur-integrasi)
- [Backend: Create Invoice](#backend-create-invoice)
- [Signature Create Invoice](#signature-create-invoice)
- [Parameter Create Invoice](#parameter-create-invoice)
- [Respons Create Invoice](#respons-create-invoice)
- [Callback Pembayaran](#callback-pembayaran)
- [Signature Callback](#signature-callback)
- [Aturan Pemrosesan Callback](#aturan-pemrosesan-callback)
- [Frontend: Duitku POP dan Redirect](#frontend-duitku-pop-dan-redirect)
- [Return URL](#return-url)
- [Error dan Idempotensi](#error-dan-idempotensi)
- [Sandbox dan Pengujian](#sandbox-dan-pengujian)
- [Keamanan dan Checklist Implementasi](#keamanan-dan-checklist-implementasi)
- [Referensi Resmi](#referensi-resmi)

## Gambaran Umum

Duitku POP menyediakan pengalaman pembayaran yang dapat ditampilkan dari situs atau aplikasi merchant. Backend merchant meminta invoice ke API Duitku, memperoleh referensi transaksi, lalu menampilkan pembayaran menggunakan Duitku POP/JavaScript atau mengarahkan pelanggan ke `paymentUrl`.

Duitku mendokumentasikan dua mekanisme status yang berbeda:

1. **JavaScript callback / browser redirect** untuk pengalaman pengguna.
2. **HTTP callback server-to-server** untuk notifikasi status pembayaran ke backend merchant.

Jangan menggunakan hasil dari JavaScript callback atau parameter URL redirect sebagai satu-satunya sumber untuk mengubah status pembayaran. Dokumentasi Duitku secara eksplisit memperingatkan bahwa parameter redirect dapat diubah oleh pelanggan dan menyediakan HTTP callback untuk pemrosesan status di server.

## Lingkungan dan Kredensial

| Lingkungan | Create Invoice endpoint |
| --- | --- |
| Sandbox | `https://api-sandbox.duitku.com/api/merchant/createInvoice` |
| Production | `https://api-prod.duitku.com/api/merchant/createInvoice` |

Kredensial didapatkan dari Merchant Portal Duitku:

- **Merchant Code**: pengenal proyek merchant.
- **API Key / Merchant Key**: kunci rahasia untuk membuat signature.

Simpan API Key hanya di server/backend atau secret manager. Jangan mengirimkannya ke browser, aplikasi klien, repository, log, maupun respons API. Pisahkan kredensial Sandbox dan Production.

## Alur Integrasi

1. Pelanggan memilih produk dan melakukan checkout.
2. Backend merchant memvalidasi pesanan, harga, jumlah, dan total pembayaran.
3. Backend membuat `merchantOrderId` unik dan mengirim request Create Invoice ke Duitku.
4. Duitku mengembalikan referensi (`reference`) dan URL pembayaran (`paymentUrl`), jika tersedia.
5. Backend menyimpan hubungan antara pesanan merchant dan referensi Duitku.
6. Frontend menampilkan Duitku POP dengan referensi tersebut atau membuka `paymentUrl`.
7. Duitku mengirim HTTP callback ke `callbackUrl` setelah status transaksi diproses.
8. Backend memverifikasi callback dan memperbarui status secara aman serta idempoten.
9. Browser kembali ke `returnUrl`; halaman return meminta status terbaru dari backend, bukan mempercayai parameter URL.

## Backend: Create Invoice

### Endpoint dan request

- **Method:** HTTP POST
- **Content-Type:** `application/json`
- **Path:** `/api/merchant/createInvoice`
- **Authentication headers:**
  - `x-duitku-timestamp`
  - `x-duitku-signature`
  - `x-duitku-merchantcode`
  - `Content-Type: application/json`

Timestamp yang didokumentasikan menggunakan Unix timestamp dalam **milidetik**. Ikuti format dan toleransi timestamp dari dokumentasi resmi saat implementasi.

### Signature Create Invoice

Dokumentasi menyatakan bahwa signature header dibuat menggunakan HMAC-SHA256 dengan string gabungan merchant code dan timestamp:

```text
stringToSign = merchantCode + timestamp
signature = HMAC_SHA256(stringToSign, apiKey)
```

Signature dikirim sebagai nilai header `x-duitku-signature`. Gunakan API Key sebagai secret HMAC, bukan sebagai bagian dari string yang ditandatangani. Ikuti representasi signature yang dicontohkan dokumentasi resmi.

### Parameter Create Invoice

Parameter utama yang didokumentasikan:

| Parameter | Tipe | Wajib | Keterangan |
| --- | --- | --- | --- |
| `paymentAmount` | integer | Ya | Nominal pembayaran. |
| `merchantOrderId` | string, maksimal 50 karakter | Ya | ID unik pesanan dari merchant. |
| `productDetails` | string, maksimal 255 karakter | Ya | Deskripsi produk/pesanan. |
| `email` | string, maksimal 255 karakter | Ya | Email pelanggan. |
| `callbackUrl` | string, maksimal 255 karakter | Ya | Endpoint HTTP callback server-to-server. |
| `returnUrl` | string, maksimal 255 karakter | Ya | URL tujuan browser setelah alur pembayaran selesai atau dibatalkan. |
| `additionalParam` | string, maksimal 255 karakter | Tidak | Parameter tambahan. |
| `merchantUserInfo` | string, maksimal 255 karakter | Tidak | Identitas pengguna di sistem merchant. |
| `customerVaName` | string, maksimal 20 karakter | Tidak | Nama yang ditampilkan untuk konfirmasi virtual account. |
| `phoneNumber` | string, maksimal 50 karakter | Tidak | Nomor telepon pelanggan. |
| `itemDetails` | array objek | Tidak | Detail item; contoh objek berisi `name`, `price`, `quantity`. |
| `customerDetail` | object | Tidak | Data pelanggan, billing address, shipping address, dan `merchantCustomerId` bila relevan. |
| `creditCardDetail` | object | Tidak | Opsi kartu kredit, termasuk `saveCardToken` untuk fitur tokenisasi. |
| `expiryPeriod` | integer | Tidak | Masa berlaku transaksi dalam menit menurut dokumentasi. |
| `paymentMethod` | string | Tidak | Kode metode pembayaran jika ingin mengarahkan metode tertentu. |

Contoh bentuk request yang disederhanakan (nilai contoh, bukan kredensial):

```json
{
  "paymentAmount": 40000,
  "merchantOrderId": "ORDER-UNIK-001",
  "productDetails": "Pembayaran pesanan",
  "email": "customer@example.com",
  "phoneNumber": "08123456789",
  "itemDetails": [
    {
      "name": "Produk Contoh",
      "price": 20000,
      "quantity": 2
    }
  ],
  "callbackUrl": "https://merchant.example/api/payment/callback",
  "returnUrl": "https://merchant.example/payment/return",
  "expiryPeriod": 10
}
```

Sebelum mengirim request, backend harus menghitung `paymentAmount` berdasarkan data harga dan jumlah yang dipercaya di server. Jangan mempercayai total harga dari browser. Validasi bahwa jumlah dan harga item konsisten dengan total pembayaran dan aturan bisnis merchant.

### Catatan `expiryPeriod`

Dokumentasi menyebutkan masa berlaku dalam menit dan menampilkan contoh seperti 5, 10, atau 60. Validasi nilai yang diperbolehkan terhadap dokumentasi/kontrak akun Duitku saat implementasi; jangan menganggap contoh sebagai daftar lengkap batas yang didukung.

### Respons Create Invoice

Contoh field respons yang didokumentasikan:

| Field | Makna |
| --- | --- |
| `reference` | Referensi transaksi Duitku; simpan untuk inquiry/rekonsiliasi. |
| `paymentUrl` | URL pembayaran Duitku jika menggunakan alur redirect. |
| `statusCode` | Kode status respons API; contoh sukses adalah `00`. |
| `statusMessage` | Pesan status. |

Periksa respons HTTP dan body API. Jangan menganggap request berhasil hanya karena koneksi HTTP selesai. Simpan `reference`, `merchantOrderId`, jumlah, dan metadata yang diperlukan untuk rekonsiliasi.

Dokumentasi juga menyebut respons untuk order ID yang sama dapat dipertahankan selama sekitar **5 menit**. Request paralel dengan order ID sama atau perubahan order yang terlalu cepat dapat menghasilkan pesan seperti `The transaction is still in progress` atau `Amount is different please try again later`. Terapkan idempotensi di sistem merchant dan jangan membuat order/invoice duplikat secara sembarangan.

## Callback Pembayaran

Duitku mengirim HTTP POST ke `callbackUrl` setelah transaksi diproses.

### Persyaratan endpoint

Menurut dokumentasi resmi:

- Endpoint harus dapat diakses publik.
- Port yang disebutkan: 80 atau 443.
- Request callback menggunakan `application/x-www-form-urlencoded`.
- Endpoint harus memberikan respons HTTP `200 OK` untuk callback yang berhasil diterima/diproses sesuai kontrak.
- IP outgoing Sandbox dan Production yang dicantumkan Duitku dapat digunakan sebagai input aturan whitelist jika diperlukan. Verifikasi daftar IP terbaru di dokumentasi resmi sebelum menerapkannya; jangan menjadikan IP whitelist sebagai satu-satunya verifikasi autentikasi.

### Parameter callback

| Parameter | Keterangan |
| --- | --- |
| `merchantCode` | Merchant code yang terdaftar. |
| `amount` | Nominal transaksi. |
| `merchantOrderId` | ID order milik merchant. |
| `productDetail` | Detail produk/pesanan. |
| `additionalParam` | Parameter tambahan, jika ada. |
| `paymentCode` | Kode metode pembayaran. |
| `resultCode` | Kode hasil; dokumentasi mencontohkan `00` = sukses dan `01` = gagal. |
| `merchantUserId` | ID pengguna merchant. |
| `reference` | Referensi transaksi Duitku. |
| `signature` | Signature HMAC-SHA256 untuk validasi sumber callback. |
| `publisherOrderId`, `spUserHash`, `settlementDate`, `issuerCode`, `customerName`, `bankAppCode`, `bankOrderId`, `bankRespCode`, `bankRespMsg`, `cardName`, `cardType`, `maskedNumber`, `tokenId`, `transactionState`, `transactionStateStatus`, `merchantCustomerId`, `expiryDate` | Field tambahan yang dapat muncul untuk kanal atau fitur tertentu; perlakukan sebagai opsional kecuali dokumentasi kontrak kanal menyatakan wajib. |

Duitku menambahkan beberapa parameter callback dalam changelog, termasuk `customerName` pada Juni 2026 serta parameter terkait tokenisasi pada Oktober 2025. Parser callback sebaiknya toleran terhadap field tambahan yang terdokumentasi, tanpa mengabaikan validasi field inti.

## Signature Callback

Dokumentasi mencantumkan formula berikut:

```text
stringToSign = merchantCode + amount + merchantOrderId
signature = HMAC_SHA256(stringToSign, merchantKey)
```

Validasi signature menggunakan nilai yang diterima pada callback dan Merchant Key yang disimpan secara rahasia di backend. Bandingkan signature dengan cara constant-time jika didukung platform. Pastikan format string, encoding, dan representasi hex sesuai dokumentasi resmi.

**Penting:** halaman dokumentasi dapat memuat beberapa jenis signature untuk tujuan berbeda. Signature Create Invoice menggunakan `merchantCode + timestamp`; signature callback menggunakan `merchantCode + amount + merchantOrderId`. Jangan memakai formula header Create Invoice untuk memvalidasi callback.

## Aturan Pemrosesan Callback

Rekomendasi implementasi sisi merchant, selaras dengan pemisahan callback server dan browser yang dijelaskan Duitku:

1. Batasi metode dan content type yang diterima sesuai kontrak callback.
2. Parse form body secara ketat; validasi field wajib dan format nominal.
3. Cocokkan `merchantCode` dengan konfigurasi merchant yang diharapkan.
4. Cari order berdasarkan `merchantOrderId` yang tersimpan di server.
5. Validasi `amount` terhadap total order yang disimpan.
6. Validasi signature sebelum mempercayai isi callback.
7. Cocokkan `reference` dan relasi transaksi jika sudah tersimpan.
8. Proses perubahan status dalam transaksi database yang atomik dan idempoten.
9. Callback duplikat tidak boleh menggandakan efek samping seperti pengurangan stok, pencatatan pembayaran, atau pemenuhan pesanan.
10. Simpan hasil validasi dan event yang diperlukan untuk audit tanpa mencatat API Key, token rahasia, atau data pembayaran sensitif yang tidak diperlukan.
11. Berikan respons sesuai kontrak Duitku. Jangan mengembalikan sukses untuk payload yang belum diproses dengan aman jika hal itu dapat menyebabkan kehilangan notifikasi.

### Penanganan status yang belum pasti

Dokumentasi ringkas ini tidak menetapkan seluruh state machine aplikasi merchant atau menyelesaikan semua kemungkinan konflik kode hasil. Jika hasil callback tidak valid, field penting tidak cocok, atau arti kode status belum dapat dipastikan, jangan menebak status terminal. Catat untuk investigasi/rekonsiliasi dan ikuti kontrak resmi Duitku atau klarifikasi tertulis dari Duitku sebelum menetapkan aturan status yang lebih luas.

## Frontend: Duitku POP dan Redirect

Dokumentasi Duitku menjelaskan dua cara menampilkan halaman pembayaran:

### Duitku POP / JavaScript

Backend terlebih dahulu membuat invoice dan mendapatkan `reference`. Frontend kemudian menggunakan library Duitku yang sesuai untuk menampilkan pengalaman pembayaran dan memanggil alur checkout yang didokumentasikan, termasuk `checkout.process(DUITKU_REFERENCE, options)`.

Ikuti instruksi pemasangan library, parameter, event, dan versi terbaru di bagian frontend resmi. Jangan menaruh Merchant Key atau membuat signature rahasia di frontend.

JavaScript callback berguna untuk memberi tahu pengguna tentang pengalaman transaksi di browser, tetapi bukan bukti final yang boleh digunakan sendiri untuk mengubah status order.

### Window Redirection

Alternatifnya, gunakan `paymentUrl` dari respons Create Invoice untuk mengarahkan pelanggan ke halaman pembayaran Duitku. Dokumentasi memberi contoh parameter bahasa `lang=id` atau `lang=en`. Parameter konversi mata uang `currency=USD` atau `currency=EUR` yang disebutkan bersifat estimasi dan rate dapat berubah.

Gunakan hanya URL pembayaran yang diterima dari respons API yang telah divalidasi. Jangan membangun URL pembayaran dari input pengguna.

## Return URL

Setelah alur pembayaran atau tombol kembali, browser dapat diarahkan ke `returnUrl` dengan parameter seperti:

- `merchantOrderId`
- `reference`
- `resultCode`

**Jangan memperbarui status pembayaran hanya berdasarkan parameter redirect.** URL dapat diedit manual oleh pelanggan. Tampilkan status sementara, lalu minta status resmi dari backend berdasarkan order yang terautentikasi atau token akses order yang sesuai.

## Error dan Idempotensi

Dokumentasi memiliki bagian khusus untuk [HTTP Response](https://docs.duitku.com/pop/id/#respon-http) dan [API Response](https://docs.duitku.com/pop/id/#respon-api). Gunakan daftar resmi tersebut untuk memetakan kode error, tetapi jangan menganggap semua kode non-sukses memiliki makna yang sama.

Praktik yang disarankan:

- Bedakan error transport, error HTTP, error API, dan status transaksi.
- Simpan `merchantOrderId` unik per order.
- Hindari request Create Invoice paralel untuk order yang sama.
- Terapkan idempotency di backend merchant, karena deduplikasi dari provider bukan pengganti kontrol konsistensi database.
- Jangan mengubah status order menjadi gagal hanya karena timeout jaringan atau respons yang tidak dapat dipastikan.
- Gunakan inquiry/rekonsiliasi sesuai endpoint dan kontrak resmi yang tersedia untuk memeriksa status transaksi yang belum jelas.

## Sandbox dan Pengujian

Lakukan pengujian di Sandbox sebelum Production. Dokumentasi resmi menyediakan skenario uji berdasarkan kanal, antara lain kartu kredit, virtual account, e-money, QRIS, paylater, e-banking, e-commerce, dan Pop API Demo.

Checklist minimal:

- [ ] Merchant Code dan API Key Sandbox sesuai dengan proyek Sandbox.
- [ ] Signature Create Invoice valid dan timestamp memakai milidetik.
- [ ] Request valid menghasilkan respons yang ditangani dengan benar.
- [ ] Respons error HTTP dan error API diuji.
- [ ] `merchantOrderId` unik dan retry tidak membuat order duplikat.
- [ ] Callback dengan signature valid diproses.
- [ ] Callback dengan signature tidak valid ditolak atau dikarantina dengan aman.
- [ ] Nominal, merchant code, order ID, dan reference yang tidak cocok tidak mengubah status pembayaran.
- [ ] Callback duplikat tidak menggandakan efek samping.
- [ ] Return URL dengan parameter yang dimanipulasi tidak dapat menandai order sebagai paid.
- [ ] Status yang belum pasti dapat direkonsiliasi.
- [ ] API Key tidak muncul pada log, frontend bundle, commit, atau respons klien.
- [ ] Pengujian Production dilakukan hanya setelah konfigurasi dan persetujuan deployment diverifikasi.

Jangan menggunakan kredensial atau data uji yang dipublikasikan dalam dokumentasi untuk transaksi Production. Kredensial Sandbox dan detail skenario uji dapat berubah; rujuk halaman resmi untuk data terkini.

## Keamanan dan Checklist Implementasi

- [ ] Semua request Create Invoice dibuat dari backend.
- [ ] API Key/merchant key hanya tersedia di secret manager/backend.
- [ ] Backend menentukan harga, jumlah, total, dan `merchantOrderId`.
- [ ] Callback diverifikasi dengan signature dan validasi data order.
- [ ] Pembaruan status dan efek samping database atomik serta idempoten.
- [ ] Browser callback dan redirect tidak dijadikan sumber kebenaran status pembayaran.
- [ ] Error dan transaksi yang tidak pasti ditangani tanpa menebak hasil final.
- [ ] Log tidak menyimpan secret atau data sensitif yang tidak diperlukan.
- [ ] Kontrak API, batas parameter, metode inquiry, dan aturan status diverifikasi terhadap dokumentasi resmi terbaru.
- [ ] Uji Sandbox lulus sebelum penggunaan Production.

## Referensi Resmi

- [Duitku POP — Dokumentasi Bahasa Indonesia](https://docs.duitku.com/pop/id/)
- [Create Invoice](https://docs.duitku.com/pop/id/#create-invoice)
- [Callback](https://docs.duitku.com/pop/id/#callback)
- [Frontend / Duitku JS](https://docs.duitku.com/pop/id/#duitku-js)
- [Window Redirection](https://docs.duitku.com/pop/id/#window-redirection)
- [Redirect](https://docs.duitku.com/pop/id/#redirect)
- [HTTP Response](https://docs.duitku.com/pop/id/#respon-http)
- [API Response](https://docs.duitku.com/pop/id/#respon-api)
- [Uji Coba](https://docs.duitku.com/pop/id/#uji-coba)

---

Dokumen ini merangkum bagian penting yang diperiksa dari referensi resmi, bukan salinan lengkap seluruh dokumentasi. Periksa kembali referensi resmi sebelum menetapkan kontrak implementasi, terutama untuk kode callback, inquiry, batas parameter, dan perubahan API.
