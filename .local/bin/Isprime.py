#!/usr/bin/env python
# Author:  Adam Graliński (https://gralin.ski)
# License: MIT

"""Provides a command to check whether a number is prime.

   Returns: 0 for prime numbers, 1 for composite (not prime) numbers,
            101 and above for errors."""
import sys
import math

def is_prime(number: int) -> bool:
    """Returns True if number is prime, False if number is composite"""
    if (number % 2 == 0 and number > 2):
        # 2 divides num (num is even and greater than two). Not prime.
        return False
    for divisor in range(3, int(math.sqrt(number)) + 1, 2):
        if number % divisor == 0:
            return False

    # At this point no divisor has been found up to ceil(sqrt(number)).
    # so the number must be a prime number.
    return True


def main():
    """The script's entry point. Calls is_prime with safety checks,
    logs the result to stdout/stderr and returns
    the appropriate value to the shell."""
    # Sanity-check: verify that a number has been provided.
    # Note: sys.argv[0] is reserved for path to source.
    #       script arguments are passed as sys.argv[1, 2, ..., N]
    if len(sys.argv) < 2:
        print("Error: missing argument. Please provide a number to be checked.", file=sys.stderr)
        sys.exit(101)

    try:
        number = int(sys.argv[1])
        result = is_prime(number)
        print("Yes" if result else "No")
        sys.exit(0 if result else 1)
    except ValueError:
        # int() call will throw ValueError for unparsable numbers (e.g. "five").
        print("Error: Could not parse that number as an integer", file=sys.stderr)
        sys.exit(102)


if __name__ == "__main__":
    main()
