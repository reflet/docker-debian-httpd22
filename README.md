# Debian8 Apache 2.2.29 (日本環境) #

オフィシャルのhttpd:2.2.29を元に日本環境の調整を行いました。

### 調整内容 ###

* locale設定 (ja.utf-8)
* タイムゾーン （Asia/Tokyo）
* 必要なツールのインストール (less vim git)
* モジュール追加 （mod_proxy.so, mod_proxy_fcgi.so)
* php-fpmを9000ポートで読み込み

### 使い方 ###

下記のコマンドにてコンテナを起動します。

```
$ docker pull reflet/debian8-httpd22
$ docker run --name httpd -d -p 80:80 -v "$PWD":/var/www/ reflet/debian8-httpd22
$ docker ps -a
$ curl http://192.168.33.10/
```

### メンテナンス ###

下記のコマンドにてソースのダウンロードとイメージの構築を実行します。

```
$ git clone https://github.com/reflet/docker-debian-httpd22.git .
$ docker build -t reflet/debian8-httpd22 .
$ docker login
$ docker tag reflet/debian8-httpd22 reflet/debian8-httpd22:{タグ}
$ docker push reflet/debian8-httpd22
```

### コンテナ操作 ( EXEC ） ###

コンテナ内に入って操作したい場合は、下記コマンドにて接続ください。
※操作を終了する場合は、「exit」でコンソールを抜けられます。

```
$ docker exec -u "www-data" -it httpd bash
```
