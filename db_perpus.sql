-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 23 Feb 2025 pada 16.37
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_buku` (IN `pid_buku` INT)   BEGIN
    DELETE FROM buku WHERE id_buku = pid_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_peminjaman` (IN `pid_peminjaman` INT)   BEGIN 
DELETE FROM peminjaman WHERE id_peminjaman = pid_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_siswa` (IN `pid_siswa` INT)   BEGIN 
DELETE FROM siswa WHERE id_siswa = pid_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_buku` ()   BEGIN
    SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_peminjaman` ()   BEGIN
    SELECT * FROM peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_siswa` ()   BEGIN
    SELECT * FROM siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_daftar_siswa_peminjam` ()   BEGIN
    SELECT DISTINCT s.id_siswa, s.nama_siswa, s.kelas_siswa
    FROM siswa s
    JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_semua_siswa` ()   BEGIN
    SELECT s.id_siswa, s.nama_siswa, s.kelas_siswa,
IFNULL(COUNT(p.id_peminjaman), 0) AS jumlah_peminjaman
    FROM siswa s
    LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa
    GROUP BY s.id_siswa, s.nama_siswa, s.kelas_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_siswa_dengan_jumlah_peminjaman` ()   BEGIN
    SELECT s.id_siswa, s.nama_siswa, s.kelas_siswa, 
           COUNT(p.id_peminjaman) AS jumlah_peminjaman
    FROM siswa s
    LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa
    GROUP BY s.id_siswa, s.nama_siswa, s.kelas_siswa
    HAVING COUNT(p.id_peminjaman) = 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_buku` (`pjudul_buku` VARCHAR(50), `ppenulis` VARCHAR(50), `pkategori` VARCHAR(50), `pstok` INT)   BEGIN
	insert into buku (judul_buku,penulis,kategori,stok)values(pjudul_buku,ppenulis,pkategori,pstok);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_peminjaman` (IN `pid_siswa` INT, IN `pid_buku` INT, IN `ptanggal_pinjam` DATE, IN `ptanggal_kembali` DATE, IN `pstatus` VARCHAR(50))   BEGIN
    INSERT INTO peminjaman (id_siswa, id_buku, tanggal_pinjam, tanggal_kembali, status) 
    VALUES (pid_siswa, pid_buku, ptanggal_pinjam, ptanggal_kembali, pstatus);

    UPDATE buku 
    SET stok = stok - 1 
    WHERE id_buku = pid_buku AND stok > 0;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_siswa` (`pnama_siswa` VARCHAR(50), `pkelas_siswa` VARCHAR(50))   BEGIN
	insert into siswa (nama_siswa,kelas_siswa)values(pnama_siswa,pkelas_siswa);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `return_buku` (IN `pid_peminjaman` INT)   BEGIN
    DECLARE buku_id INT;

    SELECT id_buku INTO buku_id 
    FROM peminjaman 
    WHERE id_peminjaman = pid_peminjaman;

    UPDATE peminjaman 
    SET status = 'Dikembalikan', tanggal_kembali = CURRENT_DATE
    WHERE id_peminjaman = pid_peminjaman;
	
    UPDATE buku 
    SET stok = stok + 1 
    WHERE id_buku = buku_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `semua_buku` ()   BEGIN
    SELECT b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok, 
           COUNT(p.id_peminjaman) AS jumlah_peminjaman
    FROM buku b
    LEFT JOIN peminjaman p ON b.id_buku = p.id_buku
    GROUP BY b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_buku` (IN `pid_buku` INT, IN `pjudul_buku` VARCHAR(50), IN `ppenulis` VARCHAR(50), IN `pkategori` VARCHAR(50), IN `pstok` INT)   BEGIN
    UPDATE buku
    SET judul_buku = pjudul_buku, penulis = ppenulis, kategori = pkategori, stok = pstok
    WHERE id_buku = pid_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_peminjaman` (IN `pid_peminjaman` INT, IN `pstatus` VARCHAR(50))   BEGIN 
UPDATE peminjaman 
SET status = pstatus
WHERE id_peminjaman = pid_peminjaman; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_siswa` (IN `pid_siswa` INT, IN `pnama_siswa` VARCHAR(50), IN `pkelas_siswa` VARCHAR(50))   BEGIN 
UPDATE siswa 
SET nama_siswa = pnama_siswa, kelas_siswa = pkelas_siswa
WHERE id_siswa = pid_siswa; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(50) DEFAULT NULL,
  `penulis` varchar(50) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `penulis`, `kategori`, `stok`) VALUES
(1, 'Satria yang malang ', 'Satria Adi ', 'Sejarah', 10),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 7),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 4),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8),
(6, 'Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6),
(7, 'Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5),
(8, 'Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 10),
(9, 'Bahasa Inggris untuk Pemula', 'Jane Doe', 'Bahasa', 10),
(10, 'Biologi Dasar', 'Budi Rahman', 'Sains', 7),
(11, 'Kimia Organik', 'Siti Aminah', 'Sains', 5),
(12, 'Teknik Elektro', 'Ridwan Hakim', 'Teknik', 6),
(13, 'Fisika Modern', 'Albert Einstein', 'Sains', 4),
(14, 'Manajemen Waktu', 'Steven Covey', 'Pengembangan', 8);

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_siswa` int(11) DEFAULT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_siswa`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 11, 2, '2025-02-01', '2025-02-08', 'Dikembalikan'),
(2, 2, 5, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 8, '2025-02-02', '2025-02-23', 'Dikembalikan'),
(4, 4, 10, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 3, '2025-01-25', '2025-02-01', 'Dikembalikan'),
(6, 15, 7, '2025-02-01', '2025-02-08', 'Dipinjam'),
(7, 7, 1, '2025-01-29', '2025-02-05', 'Dikembalikan'),
(8, 8, 9, '2025-02-03', '2025-02-10', 'Dipinjam'),
(9, 13, 4, '2025-01-27', '2025-02-03', 'Dikembalikan'),
(11, 1, 1, '2025-01-29', '2025-02-05', 'Dikembalikan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(11) NOT NULL,
  `nama_siswa` varchar(50) DEFAULT NULL,
  `kelas_siswa` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama_siswa`, `kelas_siswa`) VALUES
(1, 'Satria Adi', 'XI-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL\r\n'),
(4, 'Dewi Kurniawan', 'XI-TKJ\r\n'),
(5, 'Eko Prasetyo', 'XII-RPL'),
(6, 'Farhan Maulana', 'XII-TKJ'),
(7, 'Gita Permata', 'X-RPL'),
(8, 'Hadi Sucipto', 'X-TKJ'),
(9, 'Intan Permadi', 'XI-RPL'),
(10, 'Joko Santoso', 'XI-TKJ'),
(11, 'Kartika Sari', 'XII-RPL'),
(12, 'Lintang Putri', 'XII-TKJ'),
(13, 'Muhammad Rizky', 'X-RPL'),
(14, 'Novi Andriana', 'X-TKJ');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
