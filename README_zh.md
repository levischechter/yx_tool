[![pub package](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/yx_tool)

[English](https://pub.dev/packages/yx_tool) [中文](https://github.com/yixiaco/yx_tool/blob/master/README_zh.md)
# yx_tool

一个小巧的工具包，包含了开发常用的工具类

## 工具列表

| 文件              | Class      | **介绍**                                                     |
| ----------------- | ---------- | ------------------------------------------------------------ |
| str_util.dart     | StrUtil    | 常用字符串工具。常用包含join、toCamelCase、isEmpty、isBlank等 |
| digest_util.dart  | DigestUtil | 摘要算法。包含md2、md4、md5、RIPEMD-128、RIPEMD-160、RIPEMD-256、RIPEMD-320、SHA-1、SHA-224、SHA-256、SHA-384、SHA-512、SHA3-224、SHA3-256、SHA3-384、SM3、HMAC、SHAKE、CSHAKE、Tiger、Whirlpool、blake2b、Bcrypt。 |
| hash_util.dart    | HexUtil    | 十六进制（简写为hex或下标16）在数学中是一种逢16进1的进位制，一般用数字0到9和字母A到F表示（其中:A~F即10~15）。 例如十进制数57，在二进制写作111001，在16进制写作39。 像java,c这样的语言为了区分十六进制和十进制数值,会在十六进制数的前面加上 0x,比如0x20是十进制的32,而不是十进制的20 |
| id_util.dart      | IdUtil     | ID生成器工具类。包含uuid、snowflake、nanoId。                |
| int_util.dart     | IntUtil    | int整型工具类。包含isNumber、reverse、fib等。                |
| list_util.dart    | ListUtil   | 数组工具集。包含isEmpty、slice、reverse、fill等常用操作。    |
| random_util.dart  | RandomUtil | 随机数工具。包含randomInt、randomUint8s、randomInt8s、randomElement、randomElements等常用操作。 |
| rsa_key_util.dart | RSAKeyUtil | RSA 秘钥工具。包含：generateKeyPair（生成一组密钥对）、publicKeyToBytes、privateKeyToBytes、parsePublicKey、parsePrivateKey、privateKeyToPublicKey |

## 文本

| file                | Class         | 介绍                                                  |
| ------------------- | ------------- | ----------------------------------------------------- |
| string_builder.dart | StringBuilder | 可变的字符序列。字符串缓冲区类似于String ，但可以修改 |

## IO

| file       | Class                                                        | 介绍                                                         |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| crc4.dart  | CRC4ITU                                                      | CRC-4/ITU 循环冗余校验码                                     |
| crc5.dart  | CRC5EPC<br>CRC5ITU<br>CRC5USB                                | CRC-5/EPC 循环冗余校验码<br>CRC-5/EPC 循环冗余校验码<br>CRC-5/USB 循环冗余校验码 |
| crc6.dart  | CRC6ITU                                                      | CRC-6/ITU 循环冗余校验码                                     |
| crc7.dart  | CRC7MMC                                                      | CRC-7/MMC 循环冗余校验码                                     |
| crc8.dart  | CRC8<br>CRC8ITU<br>CRC8ROHC<br>CRC8MAXIM                     | CRC-8 循环冗余校验码<br>CRC-8/ITU 循环冗余校验码<br>CRC-8/ROHC 循环冗余校验码<br>CRC-8/MAXIM 循环冗余校验码 |
| crc16.dart | CRC16IBM<br>CRC16Ansi<br>CRC16CCITT<br>CRC16CCITTFalse<br>CRC16DNP<br>CRC16Maxim<br>CRC16Modbus<br>CRC16USB<br>CRC16X25<br>CRC16XModem | CRC16_IBM 循环冗余校验码<br>CRC16_ANSI 循环冗余校验码<br>CRC16_CCITT 循环冗余校验码<br>CRC16_CCITT_FALSE 循环冗余校验码<br>CRC16_DNP 循环冗余校验码<br>CRC16_MAXIM 循环冗余校验码<br>CRC-16 (Modbus) 循环冗余校验码<br>CRC16_USB 循环冗余校验码<br>CRC16_X25 循环冗余校验码<br>CRC-CCITT (XModem) 循环冗余校验码 |

## 加密

| file                        | Class                | 介绍                                                         |
| --------------------------- | -------------------- | ------------------------------------------------------------ |
| aead_chacha20_poly1305.dart | AEADChaCha20Poly1305 | AEAD ChaCha20Poly1305<br/ Chacha7539引擎扩展BaseStreamCipher 丹尼尔·J·伯恩斯坦的ChaCha20的RFC版本。除其他更改外，它使用了一个12字节的IV |
| aes.dart                    | AES                  | AES对称加解密算法实现                                        |
| rsa.dart                    | RSA                  | RSA非对称加解密算法实现                                      |

