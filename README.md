# FixNicoCrash

iOS 版 niconico アプリが脱獄環境 (もっと具体的に言うと Substrate で MobileSafety.dylib 以外を何か一つでも有効にしている状態) でクラッシュしてしまうのを修正する Tweak です。

## repo

準備中

## 中身

niconico アプリ内になぜか `.bundle` と `.framework` で Bundle Identifier が被っている箇所があり、それが原因で Assets.car からアセットを読み込めず落ちます。

(Substrate 環境下でだけ読み込めない原因は謎。インジェクト処理が悪さしてる?)

この Tweak では、実行時に該当 bundle の Bundle Identifier を無理矢理書き換えて被らないようにすることで回避しています。

## LICENSE

See [LICENSE](LICENSE).
