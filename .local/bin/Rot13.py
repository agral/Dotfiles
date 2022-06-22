#!/usr/bin/env python3
"""
Performs a ROT13 obfuscation algorithm on the text
provided via standard input. Prints out the obfuscated text
to the standard output.
"""

import sys
import re

PATTERN_ALNUM_LOWERCASE = re.compile("[a-z]+")
PATTERN_ALNUM_UPPERCASE = re.compile("[A-Z]+")

def Rot13(text):
    """Perform ROT13 obfuscation for a single block of text"""
    ans = []
    for character in text:
        if PATTERN_ALNUM_LOWERCASE.fullmatch(character):
            offset = (ord(character) - ord('a') + 13) % 26
            ans.append(chr(ord('a') + offset))
        elif PATTERN_ALNUM_UPPERCASE.fullmatch(character):
            offset = (ord(character) - ord('A') + 13) % 26
            ans.append(chr(ord('A') + offset))
        else:
            ans.append(character)
    return ''.join(ans)

def main():
    for arg in sys.argv[1:]:
        print(Rot13(arg))

if __name__ == "__main__":
    main()
