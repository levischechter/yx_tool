[![pub package](https://img.shields.io/badge/pub-v0.1.0-blue.svg)](https://pub.dev/packages/yx_tool)

[English](https://pub.dev/packages/yx_tool) [中文](https://github.com/yixiaco/yx_tool/blob/master/README_zh.md)
# yx_tool

A small toolkit that contains tools commonly used for development

## ToolList

| file              | Class      | **introduce**                                                     |
| ----------------- | ---------- | ------------------------------------------------------------ |
| str_util.dart     | StrUtil    | common string tools.commonly included: join、toCamelCase、isEmpty、isBlank... |
| digest_util.dart  | DigestUtil | digest algorithm.included: md2、md4、md5、RIPEMD-128、RIPEMD-160、RIPEMD-256、RIPEMD-320、SHA-1、SHA-224、SHA-256、SHA-384、SHA-512、SHA3-224、SHA3-256、SHA3-384、SM3、HMAC、SHAKE、CSHAKE、Tiger、Whirlpool、blake2b、Bcrypt. |
| hash_util.dart    | HexUtil    | hex（abbreviated as hex or subscript 16）In mathematics, it is a hexadecimal 1-bit system, generally represented by numbers 0 to 9 and letters A to F (among them: A~F is 10~15). For example, the decimal number 57 is written as 111001 in binary and 39 in hexadecimal. In order to distinguish hexadecimal and decimal values, languages like java and c add 0x in front of the hexadecimal number. For example, 0x20 is 32 in decimal, not 20 in decimal. |
| id_util.dart      | IdUtil     | id generator utility class.included: uuid、snowflake、nanoId.                |
| int_util.dart     | IntUtil    | int integer utility class.included: isNumber、reverse、fib...                |
| list_util.dart    | ListUtil   | array toolset.common operations included: isEmpty、slice、reverse、fill....    |
| random_util.dart  | RandomUtil | random number tool.common operations included: randomInt、randomUint8s、randomInt8s、randomElement、randomElements... |
| rsa_key_util.dart | RSAKeyUtil | RSA key tool.included: generateKeyPair（generate a set of key pairs）、publicKeyToBytes、privateKeyToBytes、parsePublicKey、parsePrivateKey、privateKeyToPublicKey |

## Text

| file                | Class         | introduce                                                  |
| ------------------- | ------------- | ----------------------------------------------------- |
| string_builder.dart | StringBuilder | A mutable sequence of characters. String buffers are similar to String, but can be modified |

## IO

| file       | Class                                                        | introduce                                                         |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| crc4.dart  | CRC4ITU                                                      | CRC-4/ITU cyclic redundancy check code                                     |
| crc5.dart  | CRC5EPC<br>CRC5ITU<br>CRC5USB                                | CRC-5/EPC cyclic redundancy check code<br>CRC-5/EPC cyclic redundancy check code<br>CRC-5/USB cyclic redundancy check code |
| crc6.dart  | CRC6ITU                                                      | CRC-6/ITU cyclic redundancy check code                                     |
| crc7.dart  | CRC7MMC                                                      | CRC-7/MMC cyclic redundancy check code                                     |
| crc8.dart  | CRC8<br>CRC8ITU<br>CRC8ROHC<br>CRC8MAXIM                   | CRC-8 cyclic redundancy check code<br>CRC-8/ITU cyclic redundancy check code<br>CRC-8/ROHC cyclic redundancy check code<br>CRC-8/MAXIM cyclic redundancy check code |
| crc16.dart | CRC16IBM<br>CRC16Ansi<br>CRC16CCITT<br>CRC16CCITTFalse<br>CRC16DNP<br>CRC16Maxim<br>CRC16Modbus<br>CRC16USB<br>CRC16X25<br>CRC16XModem | CRC16_IBM cyclic redundancy check code<br>CRC16_ANSI cyclic redundancy check code<br>CRC16_CCITT cyclic redundancy check code<br>CRC16_CCITT_FALSE cyclic redundancy check code<br>CRC16_DNP cyclic redundancy check code<br>CRC16_MAXIM cyclic redundancy check code<br>CRC-16 (Modbus) cyclic redundancy check code<br>CRC16_USB cyclic redundancy check code<br>CRC16_X25 cyclic redundancy check code<br>CRC-CCITT (XModem) cyclic redundancy check code |

## Encrypt

| file                        | Class                | introduce                                                         |
| --------------------------- | -------------------- | ------------------------------------------------------------ |
| aead_chacha20_poly1305.dart | AEADChaCha20Poly1305 | AEAD ChaCha20Poly1305<br/ The Chacha7539 engine extends BaseStreamCipher RFC version of Daniel J. Bernstein's ChaCha20. Among other changes, it uses a 12-byte IV |
| aes.dart                    | AES                  | AES Symmetric Encryption and Decryption Algorithm Implementation                                        |
| rsa.dart                    | RSA                  | Implementation of RSA Asymmetric Encryption and Decryption Algorithm                                      |

