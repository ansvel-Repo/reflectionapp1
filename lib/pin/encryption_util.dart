import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';

class EncryptionUtil {
  static final key = encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1');
  static final iv = encrypt.IV.fromLength(16);

  static String encryptPin(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  static String decryptPin(String encryptedText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}

// Security questions list (50 questions)
List<String> securityQuestions = [
  "What was your childhood nickname?",
  "In what city did you meet your spouse/significant other?",
  "What is the name of your favorite childhood friend?",
  "What street did you live on in third grade?",
  "What was the make and model of your first car?",
  "What was your maternal grandfather's first name?",
  "In what city or town was your first job?",
  "What was the name of your elementary school?",
  "What was your favorite food as a child?",
  "What is the first name of your best friend from childhood?",
  "What was the name of your first pet?",
  "In what city does your nearest sibling live?",
  "What was your high school mascot?",
  "What is your oldest cousin's first name?",
  "What was the name of your first boss?",
  "What was the first concert you attended?",
  "What was the name of your favorite teacher in school?",
  "Where were you when you had your first alcoholic drink?",
  "What was the name of the hospital where you were born?",
  "What was the last name of your third grade teacher?",
  "What was the name of your first stuffed animal?",
  "What was the first book you ever read?",
  "What was the name of your childhood best friend's pet?",
  "What was your favorite cartoon as a child?",
  "What was the name of your first bicycle?",
  "What was your favorite subject in high school?",
  "What was the name of your first school teacher?",
  "What was your first mobile phone number?",
  "What was the name of your first crush?",
  "What was your favorite playground game?",
  "What was the name of your childhood street?",
  "What was your first computer password?",
  "What was the name of your first email account?",
  "What was your favorite ice cream flavor as a child?",
  "What was the name of your first sports team?",
  "What was your first online username?",
  "What was the name of your childhood hero?",
  "What was your first job title?",
  "What was the name of your first neighbor?",
  "What was your favorite TV show as a teenager?",
  "What was the name of your first bank account?",
  "What was your first car's license plate number?",
  "What was the name of your first apartment complex?",
  "What was your favorite board game as a child?",
  "What was the name of your first computer?",
  "What was your first social media profile name?",
  "What was the name of your first school bus driver?",
  "What was your favorite summer camp activity?",
  "What was the name of your first library card?",
  "What was your first online shopping purchase?"
];