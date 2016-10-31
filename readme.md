# Heroku buildpack

libフォルダの中身は以下に同構成で配置<br>
http://nethive.info/lib_dev/


## Tips
### make済みtar.gzを作成する場合
#### 前提条件
Dyno 上で動作させる環境と合致させるために以下の設定が必要となります。
<dl>
    <dt>OS</dt>
    <dd>Ubuntu 14.04.5 LTS</dd>
    <dt>ユーザ</dt>
    <dd>一般ユーザ</dd>
    <dt>事前に必要なディレクトリ</dt>
    <dd>/app</dd>
    <dd>/app/.vendor</dd>
    <dd>/app/tmp</dd>
</dl>

#### 作成手順
``` sh
    sudo curl -s -L http://yourservername/mecab-0.996.tar.gz | sudo tar zx -C /app/tmp
    cd /app/tmp/mecab-0.996
    sudo ./configure --silent --prefix=/app/.vendor/mecab-0.996 --sysconfdir=/app/.vendor/mecab-0.996/etc > ~/configure.log
    sudo make --silent
    sudo tar -zcf mecab-0.996.tar.gz mecab-0.996/*
```

### 別サイトからtar.gz（未make状態）を取得し、ビルドする場合
以下のように修正してください。<br />
<br />
（例）<br />
bin/steps/compile-mecab（修正前）
``` sh
    tar -zxf $LIB_DIR/mecab-0.996.tar.gz -C $CACHE_DIR
    cd $CACHE_DIR/mecab-0.996
    make install --silent | indent
```
bin/steps/compile-mecab（修正後）
``` sh
    curl -s -L http://yourservername/mecab-0.996.tar.gz | tar zx -C $CACHE_DIR
    cd $CACHE_DIR/mecab-0.996
    ./configure --silent --prefix=$INSTALL_DIR/mecab-0.996 --sysconfdir=$INSTALL_DIR/mecab-0.996/etc
    make --silent | indent
    make --silent install | indent
```

mecab-ipadic-2.7.0-20070801.tar.gz や他ライブラリについても同様です。

## その他注意
* .profile.d script でローカル $ 変数は利用不可<br />
  （ビルドパック実行後に script が走るため、ローカル $ 変数を認識できない）