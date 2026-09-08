## 最后一个证书可能性

- 最后一个证书是自签名，但是是受信任的根证书（最后一个证书的 subject 能在 root_certs 里找到）
  - from：最后一个，to：-1，GuoMiVerify_IS_TRUSTED_CA
- 最后一个证书是自签名的，但是不受信任（subject 在 root_certs 里找不到）
  - from：最后一个，to：-1，GuoMiVerify_SELF_SIGNED
- 最后一个证书的 issuer 能在 root_certs 里找到
  - from：最后一个，to：-1，（x509_verify_with_gmssl 返回值）
- 最后一个证书的 issuer 在 root_certs 里找不到
  - from：最后一个，to：-1，GuoMiVerify_CA_NOT_FOUNT



## 流程

- 创建空 vector
- 验证证书个数是否 >= 2 且第 1 个证书（从 0 起计数）为合法的 SM2 签名证书
- 令 i 为 [1, n - 2]
  - 判断 i 是否为自签名证书；如果为自签名，就存一个 GuoMiVerify_SELF_SIGNED，跳过后续流程
  - 验证 i，i+1
  - 直接把验证结果存到 vector 里
- 验证最后一个证书是否为自签名
- 如果最后一个证书为自签名
  - subject 是否能在 root_certs 里找到
  - 能找到
    - GuoMiVerify_IS_TRUSTED_CA
  - 不能找到
    - GuoMiVerify_SELF_SIGNED
- 如果最后一个证书不为自签名
  - issuer 是否能在 root_certs 里找到
    - 能找到
      - 验签并存入 vec
    - 不能找到
      - GuoMiVerify_CA_NOT_FOUNT
- 返回 vector