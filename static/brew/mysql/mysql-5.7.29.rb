class MysqlAT5729 < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "http://mirrors.sohu.com/mysql/MySQL-5.7/mysql-boost-5.7.29.tar.gz"
  sha256 "00f514124de2bad1ba7b380cbbd46e316cae7fc7bc3a5621456cabf352f27978"

  bottle do
    sha256 "3ae76dae15820186fc74aef54f6365a55e19abc7c6d7826db5a1c774b9d9c759" => :catalina
    sha256 "85d0cd1ae169ee42eb5fbc95a6a337c17d79d042e041ffb7f01c8313874989c7" => :mojave
    sha256 "bf8272f7d912896a94f21ba7802e78ca49b70b20fc9c01f610d0f9b449469fae" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DMYSQL_UNIX_ADDR=/tmp/mysql.sock
      -DCOMPILATION_COMMENT=Homebrew
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DMYSQL_DATADIR=#{prefix}/data
      -DSYSCONFDIR=#{prefix}/conf
      -DWITH_EDITLINE=system
      -DWITH_SSL=yes
      -DWITH_UNIT_TESTS=OFF
      -DWITH_ARCHIVE_STORAGE_ENGINE=1
      -DWITH_BLACKHOLE_STORAGE_ENGINE=1
      -DENABLED_LOCAL_INFILE=1
      -DWITH_INNODB_MEMCACHED=ON
      -DWITH_INNOBASE_STORAGE_ENGINE=1
      -DWITH_PARTITION_STORAGE_ENGINE=1
      -DMYSQL_USER=_mysql
      -DMYSQL_TCP_PORT=3306
      -DWITH_BOOST=boost
      -DFORCE_INSOURCE_BUILD=1
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"
    system "#{prefix}/bin/mysqld --initialize --basedir=#{prefix} --datadir=#{prefix}/data --user=#{ENV["USER"]}"
    # Remove the tests directory
    rm_rf prefix/"mysql-test"
  end

  def caveats
rm_rf prefix/"my.cnf"
(prefix/"my.cnf").write <<~EOS
[mysqld]
# Only allow connections from localhost
bind-address = 127.0.0.1
EOS
FileUtils.cp "#{prefix}/my.cnf", "#{prefix}/my.cnf.default"
Homebrew.failed = false
  end
end
