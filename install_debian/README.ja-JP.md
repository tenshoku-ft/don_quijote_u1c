Debian環境構築用シェルスクリプト
===

## 準備

### Debian系

debootstrap以外はchrootの中のものを使います。

```
sudo apt-get install debootstrap
```

## 使い方

1. `/target`にお好みのファイルシステムを`mount`するか空にしておきます。
2. 次に`sudo`ができるユーザーで`common.sh`を実行します
3. 待ちます
4. できあがり

